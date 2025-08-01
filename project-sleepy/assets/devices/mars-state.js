export function marsState(data) {
    const marsStateElement = document.getElementById('mars-state');
    const marsState = data['input_text.my_windows']?.state; // Changed from input_text.mars_state
    const lastSeen = data['input_text.my_windows']?.attributes?.last_seen;
    
    if (marsState) {
        // 根据窗口标题判断状态
        const windowTitle = marsState.toLowerCase();
        
        // 处理SSH终端 - 显示为"醒着"而不是显示服务器名
        if (windowTitle.includes('ubuntu') || 
            windowTitle.includes('ssh') || 
            windowTitle.includes('terminal') ||
            windowTitle.includes('命令提示符') ||
            windowTitle.includes('cursor') || 
            windowTitle.includes('chrome') || 
            windowTitle.includes('firefox') || 
            windowTitle.includes('edge') || 
            windowTitle.includes('word') || 
            windowTitle.includes('excel') || 
            windowTitle.includes('powerpoint') ||
            windowTitle.includes('notepad') ||
            windowTitle.includes('code')) {
            marsStateElement.textContent = '醒着';
            marsStateElement.style.color = 'green';
            
            // 添加在线提示
            let statusHint = document.getElementById('status-hint');
            if (!statusHint) {
                statusHint = document.createElement('div');
                statusHint.id = 'status-hint';
                statusHint.style.cssText = 'font-size: 16px; color: white; margin-top: 15px; font-weight: normal;';
                marsStateElement.parentNode.appendChild(statusHint);
            }
            statusHint.textContent = '目前在线，可以通过任何可用的联系方式联系本人。';
            statusHint.style.display = 'block';
        } else if (windowTitle.includes('sleep') || 
                   windowTitle.includes('idle') || 
                   windowTitle.includes('lock') ||
                   windowTitle.includes('screensaver') ||
                   windowTitle.includes('锁屏界面') ||
                   windowTitle.includes('关机') ||
                   windowTitle.includes('shutdown') ||
                   windowTitle.includes('power off') ||
                   windowTitle.includes('shut down') ||
                   windowTitle.includes('睡眠模式') ||
                   windowTitle.includes('windows 关机')) {
            marsStateElement.textContent = '睡似了';
            marsStateElement.style.color = 'gray';
            
            // 隐藏在线提示
            let statusHint = document.getElementById('status-hint');
            if (statusHint) {
                statusHint.style.display = 'none';
            }
        } else {
            marsStateElement.textContent = '醒着'; // Default to awake if not recognized as sleeping
            marsStateElement.style.color = 'green';
            
            // 添加在线提示
            let statusHint = document.getElementById('status-hint');
            if (!statusHint) {
                statusHint = document.createElement('div');
                statusHint.id = 'status-hint';
                statusHint.style.cssText = 'font-size: 16px; color: white; margin-top: 15px; font-weight: normal;';
                marsStateElement.parentNode.appendChild(statusHint);
            }
            statusHint.textContent = '目前在线，可以通过任何可用的联系方式联系本人。';
            statusHint.style.display = 'block';
        }
    } else {
        // 检查是否因为关机而离线
        if (lastSeen) {
            const lastSeenTime = new Date(lastSeen);
            const now = new Date();
            const timeDiff = now - lastSeenTime;
            
            // 如果超过5分钟没有更新，可能是关机了
            if (timeDiff > 5 * 60 * 1000) {
                marsStateElement.textContent = '睡似了';
                marsStateElement.style.color = 'gray';
            } else {
                marsStateElement.textContent = '未知';
                marsStateElement.style.color = 'red';
            }
        } else {
            marsStateElement.textContent = '未知';
            marsStateElement.style.color = 'red';
            
            // 隐藏在线提示
            let statusHint = document.getElementById('status-hint');
            if (statusHint) {
                statusHint.style.display = 'none';
            }
        }
    }
}