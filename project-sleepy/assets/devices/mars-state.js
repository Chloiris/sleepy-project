export function marsState(data) {
    const marsStateElement = document.getElementById('mars-state');
    const marsState = data['input_text.my_windows']?.state; // Changed from input_text.mars_state
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
        } else if (windowTitle.includes('sleep') || 
                   windowTitle.includes('idle') || 
                   windowTitle.includes('lock') ||
                   windowTitle.includes('screensaver') ||
                   windowTitle.includes('锁屏界面') ||
                   windowTitle.includes('关机') ||
                   windowTitle.includes('shutdown') ||
                   windowTitle.includes('power off') ||
                   windowTitle.includes('shut down') ||
                   windowTitle.includes('睡眠模式')) {
            marsStateElement.textContent = '睡似了';
            marsStateElement.style.color = 'gray';
        } else {
            marsStateElement.textContent = '醒着'; // Default to awake if not recognized as sleeping
            marsStateElement.style.color = 'green';
        }
    } else {
        marsStateElement.textContent = '未知';
        marsStateElement.style.color = 'red';
    }
}