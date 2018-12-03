![](https://img.shields.io/badge/License-Apache%202-yellow.svg)
# 行人检测系统
基于深度神经网络的行人检测系统的实现，本系统基于Apache2.0协议开源，请严格遵守开源协议。
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
