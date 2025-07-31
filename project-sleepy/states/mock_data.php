<?php
// 模拟 Home Assistant 数据
header("Content-Type: application/json");

$mockData = [
    "cached" => false,
    "timestamp" => time(),
    "cache_age" => 0,
    "input_boolean.private_mode" => [
        "state" => "off",
        "last_updated" => date('c'),
        "attributes" => [
            "friendly_name" => "隐私模式",
            "icon" => "mdi:eye-off"
        ]
    ],
    "input_text.message" => [
        "state" => "正在测试 Project Sleepy！",
        "last_updated" => date('c'),
        "attributes" => [
            "friendly_name" => "消息",
            "icon" => "mdi:message-text"
        ]
    ],
    "input_text.my_windows" => [
        "state" => "Cursor - gitprojects",
        "last_updated" => date('c'),
        "attributes" => [
            "friendly_name" => "当前窗口",
            "icon" => "mdi:monitor"
        ]
    ],
    "input_boolean.awake" => [
        "state" => "on",
        "last_updated" => date('c'),
        "attributes" => [
            "friendly_name" => "醒着状态",
            "icon" => "mdi:eye"
        ]
    ],
    "sensor.temperature" => [
        "state" => "23.5",
        "last_updated" => date('c'),
        "attributes" => [
            "friendly_name" => "温度",
            "unit_of_measurement" => "°C",
            "icon" => "mdi:thermometer"
        ]
    ],
    "sensor.humidity" => [
        "state" => "65",
        "last_updated" => date('c'),
        "attributes" => [
            "friendly_name" => "湿度",
            "unit_of_measurement" => "%",
            "icon" => "mdi:water-percent"
        ]
    ],
    "sensor.pressure" => [
        "state" => "1013.25",
        "last_updated" => date('c'),
        "attributes" => [
            "friendly_name" => "气压",
            "unit_of_measurement" => "hPa",
            "icon" => "mdi:gauge"
        ]
    ],
    "sensor.light_level" => [
        "state" => "450",
        "last_updated" => date('c'),
        "attributes" => [
            "friendly_name" => "光照强度",
            "unit_of_measurement" => "lux",
            "icon" => "mdi:brightness-5"
        ]
    ]
];

echo json_encode($mockData, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?> 