<?php
header('Content-Type: application/json');
$request_start = microtime(true);

// 载入配置
include 'config.php';

// 只允许 POST 请求，防止直接访问
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["code" => 405, "message" => "Method Not Allowed"]);
    exit;
}

// 获取请求参数
$times = isset($_POST['times']) ? (int)$_POST['times'] : 0;
$message = isset($_POST['message']) ? trim($_POST['message']) : '';
$recaptcha = isset($_POST['recaptcha']) ? $_POST['recaptcha'] : '';

// 检查点击次数
if ($times < 1) {
    echo json_encode(["code" => 400, "message" => "Invalid times parameter."]);
    exit;
}

// **Google reCAPTCHA 验证（仅在启用时）**
if ($enable_recaptcha) {
    $recaptcha_response = file_get_contents("https://recaptcha.net/recaptcha/api/siteverify?secret={$recaptcha_secret}&response={$recaptcha}");
    $recaptcha_result = json_decode($recaptcha_response, true);

    if (!$recaptcha_result['success'] || $recaptcha_result['score'] < 0.5) {
        echo json_encode(["code" => 403, "message" => "reCAPTCHA verification failed."]);
        exit;
    }
}

// 获取 IP 地址
$ip_start = microtime(true);
$client_ip = $_SERVER['REMOTE_ADDR'] ?? 'N/A';
$geo_json = @file_get_contents("https://ip-addr.is/json/{$client_ip}");
$ip_end = microtime(true);

$geo_info = json_decode($geo_json, true);
$country = $geo_info['country'] ?? 'N/A';
$city = $geo_info['city'] ?? 'N/A';
$subdivision = $geo_info['subdivision'] ?? 'N/A';

$location = "";
if ($country !== 'N/A') {
    if ($subdivision === 'N/A') {
        $location = "$country";
    } elseif ($city !== $subdivision && $city !== 'N/A') {
        $location = "$city, $subdivision, $country";
    } else {
        $location = "$subdivision, $country";
    }
}

// 记录到日志文件
$log_entry = date('Y-m-d H:i:s') . " - 用户点击了 $times 次";
if (!empty($message)) {
    $log_entry .= "，附言: $message";
}
$log_entry .= " - IP: $client_ip";
if (!empty($location)) {
    $log_entry .= " - 位置: $location";
}
$log_entry .= "\n";

file_put_contents(__DIR__ . '/boom.log', $log_entry, FILE_APPEND | LOCK_EX);

// 构造 Telegram API 请求
$message_text = "🔔 *Project Sleepy 提醒*\n\n";
$message_text .= "你被点击了 *$times* 次";
if (!empty($message)) {
    $message_text .= "\n附言: $message";
}

if (!empty($location)) {
    $message_text .= "\n\n📍 来自: $location";
} else {
    $message_text .= "\n\n📍 来自: $client_ip";
}

$message_text .= "\n\n🌐 [查看网站](https://sleepy.chlogonia.top)";

$post_data = [
    'chat_id' => $chat_id,
    'text' => $message_text,
    'parse_mode' => 'Markdown',
    'disable_web_page_preview' => true
];

// 记录 API 请求的时间
$api_start = microtime(true);
$context = stream_context_create([
    'http' => [
        'method' => 'POST',
        'header' => 'Content-Type: application/x-www-form-urlencoded',
        'content' => http_build_query($post_data)
    ]
]);
$response = @file_get_contents($endpoint . $key . '/sendMessage', false, $context);
$api_end = microtime(true);

if ($response === false) {
    $error = error_get_last();
    echo json_encode([
        "code" => 500, 
        "message" => $error ? $error['message'] : "Request failed.",
        "timing" => [
            "total" => round(microtime(true) - $request_start, 4) . "s",
            "ip_lookup" => round($ip_end - $ip_start, 4) . "s",
            "api_request" => round($api_end - $api_start, 4) . "s"
        ]
    ]);
    exit;
}

// 返回 API 响应，附带时间信息
$request_end = microtime(true);
echo json_encode(array_merge(
    json_decode($response, true),
    [
        "timing" => [
            "total" => round($request_end - $request_start, 4) . "s",
            "ip_lookup" => round($ip_end - $ip_start, 4) . "s",
            "api_request" => round($api_end - $api_start, 4) . "s"
        ]
    ]
));