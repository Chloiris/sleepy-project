export function runningApp(data) {
    // 当前窗口信息显示
    const currentWindow = data['input_text.my_windows']?.state;
    const messageContainer = document.querySelector('.message-container');
    
    if (currentWindow && currentWindow !== 'unavailable') {
        // 创建或更新窗口信息显示
        let windowInfo = document.getElementById('current-window-info');
        if (!windowInfo) {
            windowInfo = document.createElement('div');
            windowInfo.id = 'current-window-info';
            windowInfo.className = 'card';
            messageContainer.appendChild(windowInfo);
        }
        
        windowInfo.innerHTML = `
            <h2>当前窗口</h2>
            <p><i class="fa-solid fa-desktop"></i> ${currentWindow}</p>
        `;
    } else {
        // 如果没有窗口信息，移除显示
        const windowInfo = document.getElementById('current-window-info');
        if (windowInfo) {
            windowInfo.remove();
        }
    }
}