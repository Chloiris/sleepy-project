import time
import signal
import requests
import pygetwindow as gw
import urllib3
from config import HASS_URL, HASS_TOKEN, UPDATE_INTERVAL, IGNORE_SSL_ERRORS, ATTRIBUTES

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

HEADERS = {
    "Authorization": f"Bearer {HASS_TOKEN}",
    "Content-Type": "application/json",
}

def get_active_window_title():
    try:
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
    print("Script exiting, setting state to 'unavailable'")
    update_hass_state("unavailable")
    exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, handle_exit)
    signal.signal(signal.SIGTERM, handle_exit)

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