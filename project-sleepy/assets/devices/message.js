export function message(data) {
    const messageContainer = document.querySelector('.message-container');
    const currentWindow = data['input_text.my_windows']?.state;
    const lastUpdated = data['input_text.my_windows']?.last_updated;
    
    // 检查当前窗口信息是否有效，并且不是 "unavailable" 或 "未知"
    if (currentWindow && currentWindow !== 'unavailable' && currentWindow !== '未知') {
        // 创建一个新的 Date 对象，表示最后更新时间
        const updatedDate = new Date(lastUpdated);
        
        // 获取当前日期并检查是否是今天
        const currentDate = new Date();
        const isToday = updatedDate.toDateString() === currentDate.toDateString();
        
        // 获取小时和分钟
        let hours = updatedDate.getHours();
        const minutes = updatedDate.getMinutes();
        
        // 确定时间段，并转换为 12 小时制
        let timePeriod = '';
        if (hours >= 0 && hours < 7) {
            timePeriod = '凌晨';
        } else if (hours >= 7 && hours < 12) {
            timePeriod = '上午';
        } else if (hours >= 12 && hours < 13) {
            timePeriod = '中午';
        } else if (hours >= 13 && hours < 18) {
            timePeriod = '下午';
        } else {
            timePeriod = '晚上';
        }

        // 12 小时制转换
        const ampmHours = hours % 12 || 12; // 0 点转换为 12
        const formattedMinutes = minutes.toString().padStart(2, '0'); // 确保分钟始终两位数
        
        // 组合时间格式
        const timeString = `${timePeriod}${ampmHours}:${formattedMinutes}`;
        
        let dateString = '';
        if (!isToday) {
            const month = updatedDate.getMonth() + 1; // 月份从 0 开始
            const day = updatedDate.getDate();
            dateString = `${month}月${day}日`;
        }
        
        // 构建 HTML 结构，显示当前窗口信息
        messageContainer.innerHTML = `
            <div class="card">
                <h2><i class="fa-solid fa-desktop"></i> ${currentWindow}</h2>
                <h4>当前窗口 更新于${dateString}${timeString}</h4>
            </div>
        `;
    } else {
        // 如果窗口信息无效，则隐藏消息容器
        messageContainer.innerHTML = '';
    }
}