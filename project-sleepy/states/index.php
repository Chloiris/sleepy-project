<?php
require_once 'config.php';

// 添加模拟数据选项
$useMockData = false; // 设置为 true 使用模拟数据，false 使用真实 Home Assistant

if ($useMockData) {
    // 使用模拟数据
    include 'mock_data.php';
    exit;
}

// 以下是原有的真实 Home Assistant 代码
global $endpoint, $host, $token, $cacheFile, $cacheTTL;
include 'statistics/counter.php';

// 限制 JSON 编码的浮点数精度
ini_set('serialize_precision', 14);

// 指定每个实体需要保留的字段
$entities = [
    "input_boolean.private_mode" => [],
    "input_text.mars_state" => [],
    "input_text.mars_mac_mini" => [],
    "input_text.mars_legion" => [],
    "input_text.my_windows" => ["last_updated"],
    "input_text.message" => ["last_updated"],
];

function extract_entity_data($entity, $fields_to_keep) {
    $filtered_data = [
        "state" => $entity['state'] // 保留原始状态
    ];

    foreach ($fields_to_keep as $field) {
        if (in_array($field, ['last_updated', 'last_changed'])) {
            // 直接从根级获取 last_updated 和 last_changed
            $filtered_data[$field] = $entity[$field] ?? null;
        } else {
            // 默认从 attributes 获取
            $filtered_data[$field] = $entity['attributes'][$field] ?? null;
        }
    }

    return $filtered_data;
}



// 构造数据
function format_data_by_entity_id($data, $entities) {
    $formatted = [];
    foreach ($data as $entity) {
        if (isset($entities[$entity['entity_id']])) {
            $formatted[$entity['entity_id']] = extract_entity_data($entity, $entities[$entity['entity_id']]);
        }
    }
    return $formatted;
}

// 检查缓存
$cacheValid = false;
if (file_exists($cacheFile)) {
    $cachedData = json_decode(file_get_contents($cacheFile), true);
    if (isset($cachedData['timestamp']) && (time() - $cachedData['timestamp']) < $cacheTTL) {
        $cacheValid = true;
        // 缓存有效，返回缓存数据
        header("Content-Type: application/json");
        echo json_encode(array_merge([
            "cached" => true,
            "timestamp" => $cachedData['timestamp'],
            "cache_age" => time() - $cachedData['timestamp']
        ], $cachedData['data']), JSON_PRETTY_PRINT);
        exit;
    }
}

// 缓存无效，拉取新数据
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $endpoint . "/states");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Authorization: Bearer $token",
    "Content-Type: application/json",
]);

$response = curl_exec($ch);

if (curl_errno($ch)) {
    echo "cURL Error: " . curl_error($ch);
    curl_close($ch);
    exit;
}

$data = json_decode($response, true);
curl_close($ch);

// 拉取新数据并构建格式化数据
$filtered_data = format_data_by_entity_id($data, $entities);

// 检查 private_mode
$is_private_mode_on = false;
if (isset($filtered_data['input_boolean.private_mode']) && $filtered_data['input_boolean.private_mode']['state'] === 'on') {
    $is_private_mode_on = true;
}

if ($is_private_mode_on) {
    $filtered_data = array_filter($filtered_data, function ($key) {
        return in_array($key, ['input_boolean.private_mode', 'input_text.mars_state', 'input_text.message']);
    }, ARRAY_FILTER_USE_KEY);
}

// 写入缓存文件
$cacheData = [
    "timestamp" => time(),
    "data" => $filtered_data
];
file_put_contents($cacheFile, json_encode($cacheData, JSON_PRETTY_PRINT));

// 返回数据
header("Content-Type: application/json");
echo json_encode(array_merge([
    "cached" => false,
    "timestamp" => $cacheData['timestamp'],
    "cache_age" => 0
], $filtered_data), JSON_PRETTY_PRINT);