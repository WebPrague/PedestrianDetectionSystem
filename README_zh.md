![](https://img.shields.io/badge/License-Apache%202-yellow.svg)
# 行人检测系统
监控在安保和巡查中发挥着重要作用，但也是一项非常乏味的任务，深度学习的出现在一定程度上将人类从这一任务中解放出来。本项目基于深度学习的目标检测去搭建了一个简单有效的监控系统，能够自动化进行人流统计。本系统基于Apache2.0协议开源，请严格遵守开源协议。
# 0x00 简介
本系统由以下三个子项目组成：<br>
- 1.基于TensorFlow平台的行人检测系统
- 2.基于Android平台的推流系统
- 3.基于JavaWeb的展示系统

# 0x01 服务器部署
## 1.服务器的配置要求
| 配置        | 基本要求 |
| ---------- | ------- |
| 操作系统 | Ubuntu 16.04 x64 |
| CPU  | 主频2.0GHz 以上   |
| 内存 | 8G以上 |
| GPU | NVIDIA GTX1080以上 |
| 网络 | 服务器IP地址需是公网IP |

## 2.基于TensorFlow平台的行人检测系统
本系统依赖如下：

| 依赖项 | 安装方式 |
| ---------- | ------ |
| Python3.5 | 略 |
| pip | 略 |
| TensorFlow-1.11.0-GPU | [安装流程](https://hupeng.me/articles/48.html) |
| Python版本OpenCV | [安装流程](https://hupeng.me/articles/49.html) |
| requests | pip3 install requests |
| frozen_inference_graph.pb | [下载地址](https://download.csdn.net/download/huplion/10825557) |
| Nginx with RTMP | [安装流程](https://www.jianshu.com/p/b4ee6956d1ea) |


运行系统：
我们使用Tensorflow深度学习框架来训练一个行人检测的模型，整个过程可以被归纳为3个阶段：
- 数据准备
过去拍摄的监控录像可能是你可以获得的最准确的数据集。但是摄像机中的图像质量可能较低。一种巧妙的方法是使用[数据扩充](https://medium.com/nanonets/how-to-use-deep-learning-when-you-have-limited-data-part-2-data-augmentation-c26971dc8ced)。本质上说，我们必须添加一些噪音来降低数据集中图片的质量。我们还可以尝试模糊和侵蚀效果。为了目标检测任务，我们将使用 [TownCentre 数据集
](https://pan.baidu.com/s/1lwlmsr16v2eOtlzDPGMlIw)。我们将使用视频的前 3600 帧进行训练和验证，剩下的 900 帧用来测试。
- 训练模型
我们使用迁移学习来训练一个目标检测器，采用ResNet50的FasterRCNN结构的神经网络作为预训练模型，并在此模型上进行微调。建议使用 GPU 足够大的机器（假设你安装了 TensorFlow 的 GPU 版本）以加速训练过程。
- 模型推理
导出训练模型，也就是在python目录下的名为 frozen_inference_graph.pb 的文件，得到训练好的模型。





