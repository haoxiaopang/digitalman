import asyncio
import websockets
import json
import tkinter as tk
from PIL import Image, ImageTk
import requests
from io import BytesIO
import threading

class ImageDisplayApp:
    def __init__(self, root):
        """初始化 Tkinter 窗口和显示图片的 Label。"""
        self.root = root
        self.root.title("动态图片显示")
        
        self.label = tk.Label(root, text="等待图片...")
        self.label.pack(padx=20, pady=20)

    def update_image(self, url: str):
        """根据给定的图片 URL，下载并更新显示。"""
        try:
            response = requests.get(url)
            response.raise_for_status()
            image_data = response.content

            pil_image = Image.open(BytesIO(image_data))
            pil_image = pil_image.resize((400, 400), Image.Resampling.LANCZOS)
            tk_image = ImageTk.PhotoImage(pil_image)

            self.label.config(image=tk_image, text="")
            self.label.image = tk_image  # 避免被 Python 垃圾回收
        except Exception as e:
            self.label.config(text=f"图片加载失败：{e}")

async def listen_websocket(uri: str, app: ImageDisplayApp):
    """
    连接指定的 WebSocket，循环接收消息并更新图片。
    由于 Tkinter 不是线程安全的，需要使用 app.root.after() 在主线程更新 UI。
    """
    async with websockets.connect(uri) as websocket:
        while True:
            message = await websocket.recv()
            data = json.loads(message)

            # 从 JSON 中解析出图片 URL
            robot_url = data.get("robot")
            if robot_url:
                # 使用 Tkinter 主线程来更新 UI
                app.root.after(0, app.update_image, robot_url)

def start_websocket_loop(uri: str, app: ImageDisplayApp):
    """在单独的事件循环中运行 listen_websocket 协程。"""
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.run_until_complete(listen_websocket(uri, app))

def main():
    # 创建 Tkinter 主窗体
    root = tk.Tk()
    app = ImageDisplayApp(root)

    # 启动一个线程来跑 websocket 事件循环
    ws_thread = threading.Thread(
        target=start_websocket_loop, 
        args=("ws://127.0.0.1:10002", app),
        daemon=True
    )
    ws_thread.start()

    # 启动 Tkinter 主循环
    root.mainloop()

if __name__ == "__main__":
    main()
