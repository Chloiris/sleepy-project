import { marsState } from './devices/mars-state.js';
import { runningApp } from './devices/running-app.js';
import { message } from './devices/message.js';

let previousPrivateMode = false;

// 定义显示缓存状态和下一次更新的元素
const cacheStateElement = document.getElementById('cache-state');
const updateElement = document.getElementById('update');

async function fetchData() {
    try {
        const response = await fetch('states/');
        const data = await response.json();

        // 更新页面内容
        updatePage(data);

        // 更新缓存和倒计时信息
        updateCacheInfo(data);
    } catch (error) {
        console.error('Error fetching data:', error);
    }
}

function updateCacheInfo(data) {
    clearInterval(window.previousAgeInterval);
    clearInterval(window.previousCountdownInterval);

    // 隐藏缓存状态显示
    if (cacheStateElement) {
        cacheStateElement.style.display = 'none';
    }

    // 下一次更新倒计时
    let nextUpdate = 15; // 定时刷新为15秒
    if (updateElement) {
        updateElement.textContent = `下一次自动更新: ${nextUpdate} 秒后`;
    }

    window.previousCountdownInterval = setInterval(() => {
        nextUpdate--;
        if (updateElement) {
            updateElement.textContent = `下一次自动更新: ${nextUpdate} 秒后`;
        }
        if (nextUpdate <= 0) {
            clearInterval(window.previousCountdownInterval);
        }
    }, 1000);
}

function updatePage(data) {
    const privateModeState = data['input_boolean.private_mode']?.state;

    // 隐私模式检查
    if (privateModeState === 'on') {
        marsState(data);
        runningApp(data);
        message(data);
        // 隐私模式下不显示任何额外信息
        previousPrivateMode = true;
        return;
    } else if (previousPrivateMode && privateModeState === 'off') {
        window.location.reload();
        return;
    }
    previousPrivateMode = false;

    // UPDATE FUNCTIONS - 只保留基本功能
    marsState(data);
    runningApp(data);
    message(data);
}

setInterval(fetchData, 15000);
fetchData();