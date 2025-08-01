import time
import signal
import requests
import pygetwindow as gw
import urllib3
import ctypes
from ctypes import wintypes
import atexit
from config import HASS_URL, HASS_TOKEN, UPDATE_INTERVAL, IGNORE_SSL_ERRORS, ATTRIBUTES

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

HEADERS = {
    "Authorization": f"Bearer {HASS_TOKEN}",
    "Content-Type": "application/json",
}

def is_system_sleeping():
    """检测系统是否处于睡眠状态"""
    try:
        # 使用Windows API检测系统状态
        ES_CONTINUOUS = 0x80000000
        ES_SYSTEM_REQUIRED = 0x00000001
        
        # 获取系统电源状态
        kernel32 = ctypes.windll.kernel32
        result = kernel32.GetSystemPowerStatus(ctypes.byref(ctypes.c_ulong()))
        
        # 检查是否有活跃的窗口
        window = gw.getActiveWindow()
        if not window:
            return True
            
        # 如果窗口标题为空或不可见，可能是睡眠状态
        if not window.title or not window.visible:
            return True
            
        return False
    except Exception as e:
        print(f"Error checking sleep status: {e}")
        return False

def get_active_window_title():
    try:
        # 首先检查是否处于睡眠状态
        if is_system_sleeping():
            return "Windows 睡眠模式"
            
        window = gw.getActiveWindow()
        return window.title if window else None
    except Exception as e:
        print(f"Error getting window title: {e}")
        return None

def update_hass_state(state):
    try:
        data = {
            "state": state,
            "attributes": ATTRIBUTES,
        }
        # 修改为Project Sleepy期望的实体名称
        api_url = f"{HASS_URL}/api/states/input_text.my_windows"
        response = requests.post(
            api_url,
            headers=HEADERS,
            json=data,
            verify=not IGNORE_SSL_ERRORS
        )
        response.raise_for_status()
        print(f"Successfully updated state: {state}")
    except requests.RequestException as e:
        print(f"Error updating Home Assistant state: {e}")

def handle_exit(signum, frame):
    print("Script exiting, setting state to 'Windows 关机'")
    update_hass_state("Windows 关机")
    exit(0)

def cleanup_on_exit():
    """程序退出时的清理函数"""
    print("Program shutting down, setting state to 'Windows 关机'")
    update_hass_state("Windows 关机")

if __name__ == "__main__":
    signal.signal(signal.SIGINT, handle_exit)
    signal.signal(signal.SIGTERM, handle_exit)
    atexit.register(cleanup_on_exit)  # 注册退出时的清理函数

    print("Script started, reporting active window title to Home Assistant...")
    try:
        while True:
            active_window_title = get_active_window_title()
            if active_window_title:
                print(f"Active window title: {active_window_title}")
                update_hass_state(active_window_title)
            time.sleep(UPDATE_INTERVAL)
    except KeyboardInterrupt:
        handle_exit(None, None)