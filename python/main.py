import cv2
import numpy as np
import requests
from inference import OD
import subprocess as sp
import threading
import time
from PIL import Image

RTMP_HOST = '183.175.12.160'

rtmpUrl = 'rtmp://' + RTMP_HOST + ':1935/live/stream'
od = OD()

use_channel = 1
shared_image = (np.ones((540, 960, 3), dtype=np.uint8) * 255).astype(np.uint8)
process_image = (np.ones((540, 960, 3), dtype=np.uint8) * 255).astype(np.uint8)
people_count = 0




class SecondThread(threading.Thread):
    def __init__(self):
        super(SecondThread, self).__init__()  # 注意：一定要显式的调用父类的初始化函数。
        # self.arg=arg

    def run(self):  # 定义每个线程要运行的函数
        print('second thread is run!')
        global shared_image
        while True:
            camera = cv2.VideoCapture('rtmp://' + RTMP_HOST + '/live/android')
            if (camera.isOpened()):
                print ('Open camera 1')
                break
            else:
                print ('Fail to open camera 1!')
                time.sleep(0.05)
        camera.set(cv2.CAP_PROP_FRAME_WIDTH, 864)  # 2560x1920 2217x2217 2952×1944 1920x1080
        camera.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
        # camera.set(cv2.CAP_PROP_FPS, 5)

        size = (int(camera.get(cv2.CAP_PROP_FRAME_WIDTH)), int(camera.get(cv2.CAP_PROP_FRAME_HEIGHT)))
        sizeStr = str(960) + 'x' + str(540)
        fps = camera.get(cv2.CAP_PROP_FPS)  # 30p/self
        # fps = int(fps)

        fourcc = cv2.VideoWriter_fourcc(*'XVID')
        out = cv2.VideoWriter('res_mv.avi', fourcc, fps, size)
        while True:
            ret, frame = camera.read()  # 逐帧采集视频流
            if frame is not None:
                image = Image.fromarray(frame)
                image = image.resize((960, 540))
                frame = np.array(image)

                # frame.resize((960, 540))
                if use_channel == 1:
                    shared_image = frame





class TFThread(threading.Thread):
    def __init__(self):
        super(TFThread, self).__init__()  # 注意：一定要显式的调用父类的初始化函数。
        # self.arg=arg

    def run(self):  # 定义每个线程要运行的函数
        print('tensorflow thread is run!')
        global shared_image
        global process_image
        global people_count
        while True:
            frame, pc = od.infer(shared_image)
            process_image = frame
            people_count = pc
            time.sleep(0.05)
            # print(process_image)


command = ['ffmpeg',
    '-y',
    '-f', 'rawvideo',
    '-vcodec','rawvideo',
    '-pix_fmt', 'bgr24',
    '-s', '960x540',
    '-r', str(5),
    '-i', '-',
    '-c:v', 'libx264',
    '-pix_fmt', 'yuv420p',
    '-preset', 'ultrafast',
    '-f', 'flv',
    rtmpUrl]

global pipe
pipe = sp.Popen(command, stdin=sp.PIPE)


class PushThread(threading.Thread):
    def __init__(self):
        super(PushThread, self).__init__()  # 注意：一定要显式的调用父类的初始化函数。
        # self.arg=arg

    def run(self):  # 定义每个线程要运行的函数
        print('push thread is run!')
        global process_image
        url = "http://127.0.0.1:8080/PeopleDetection/people"
        count = 0
        while True:
            ###########################图片采集
            #print(process_image)
            #print(pipe)
            #print(pipe.stdin)
            pipe.stdin.write(process_image.tostring())  # 存入管道
            # print('push!')
            param = {'peopleNum': str(people_count)}
            count += 1
            if count % 25 == 0:
                try:
                    r = requests.post(url=url, data=param)
                except:
                    pass
            time.sleep(0.198)


class GetChannelThread(threading.Thread):
    def __init__(self):
        super(GetChannelThread, self).__init__()  # 注意：一定要显式的调用父类的初始化函数。
        # self.arg=arg

    def run(self):  # 定义每个线程要运行的函数
        print('get channel thread is run!')
        global use_channel
        url = 'http://127.0.0.1:8080/PeopleDetection/get_channel'
        while True:
            try:
                r = requests.get(url=url)
                use_channel = int(eval(r.content)['data'])
                print('当前通道：' + str(use_channel))
            except:
                pass
            time.sleep(5)



second_thread = SecondThread()
second_thread.start()



tf_thread = TFThread()
tf_thread.start()

push_thread = PushThread()
push_thread.start()

get_channel_thread = GetChannelThread()
#get_channel_thread.start()
