![](https://img.shields.io/badge/License-Apache%202-yellow.svg)

# Automatic pedestrian detection and monitoring system based on Deep Learning
[中文文档](https://github.com/zhangpengpengpeng/PedestrianDetectionSystem/blob/master/README_zh.md)<br>

Monitoring plays an important role in security and inspections, but it is also a very tedious task. The emergence of deep learning has liberated humans from this task to some extent. This project builds a simple and effective monitoring system based on the goal detection of deep learning, which can automate the flow statistics and pedestrian detection. 

**This system is based on the Apache2.0 protocol open source, please strictly abide by the open source agreement.**

# 0x00 Introduction
The system consists of the following three sub-projects: <br>
- 1.Pedestrian detection system based on TensorFlow platform
- 2.Push flow system based on Android platform
- 3.JavaWeb-based display system

# 0x01 Server Deployment
## 1.Server configuration requirements
| Configuration        | Basic requirements |
| ---------- | ------- |
| OS | Ubuntu 16.04 x64 |
| CPU  | Main frequency 2.0GHz or more |
| RAM | 8G or more |
| GPU | NVIDIA GTX1080 or more |
| Network | The server IP address needs to be the public IP address. |

## 2.Pedestrian detection system based on TensorFlow platform
The system relies on the following:

| Dependency | Installation method |
| ---------- | ------ |
| Python3.5 | Skip |
| pip | Skip |
| TensorFlow-1.11.0-GPU | Skip |
| Python version - OpenCV | Skip |
| requests | pip3 install requests |
| frozen_inference_graph.pb | [Download Link](https://download.csdn.net/download/huplion/10825557) |
| Nginx with RTMP | [Installation Process](https://www.jianshu.com/p/b4ee6956d1ea) |

How to run the system：
- Copy the `.pb` model file obtained after training the model in the `python`directory；
- Modify the `RTMP_HOST` variable in the  `main.py`file and run`main.py`；

## 3.Push flow system based on Android platform

How to run the system：

- Import the project in the 'android' directory in an integrated development environment such as IDEA or AndroidStudio,and modify the static variavles in 'MainActivity.java'；

## 4.Display system based on SSM (SpringMVC+Spring+Mybatis) Internet lightweight framework
The system relies on the following

| Dependency | Installation method |
| ---------- | ------ |
| JDK-1.8.0 | Skip |
| Apache-Tomcat-9.0.12 | Skip |
| Maven | Skip |
| Mysql | Need to configure remote access rights |

How to run the system：
- The system is developed based on the IDEA integrated development environment. The dependencies in the SSM framework are all based on Maven configuration. Import the project under the `web` directory in Idea, export the `war` package, and put the `war` package on the server `tomcat/webapps` directory, run `./startup.sh` to start the `tomcat` container

# 0x02 Project Display

<img src="https://github.com/zhangpengpengpeng/PedestrianDetectionSystem/raw/master/img/example2.jpg" width="600" height="300">

<img src="https://github.com/zhangpengpengpeng/PedestrianDetectionSystem/raw/master/img/example1.png" width="700" height="400">

<img src="https://github.com/zhangpengpengpeng/PedestrianDetectionSystem/raw/master/img/example3.jpg" width="700" height="400">

- Added visual view of human flow statistics for large data volumes；

<img src="https://github.com/zhangpengpengpeng/PedestrianDetectionSystem/raw/master/img/example4.png" width="700" height="600">

- Show the full effect of the pedestrian detection project，[Display link](https://pan.baidu.com/s/1X7BX5QSbqZFx2Y6XElW4ZA);


# 0x03 About

- How to support the author: Click on **star** button in the upper right corner is the maximum support of the author；
- If you have questions or discuss the pedestrian detection algorithm model, please [submit an issue](https://github.com/zhangpengpengpeng/PedestrianDetectionSystem/issues/new),thanks;