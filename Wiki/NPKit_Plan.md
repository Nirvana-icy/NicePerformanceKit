# Plan

![image](https://mmbiz.qpic.cn/mmbiz_jpg/M54fjP2zXtFcEiahyfjOCybpKcIPmqKb5N1Da700VAY0Kf2H9k7zLkhCzw5kK93UujOAZiaqI33m3X2gUkzD8IYA/0?wx_fmt=jpeg)

---

## 启动时间
## 内存
### 内存泄露
### 内存峰值(Top)页面 & 堆栈
## 线程
###  线程峰值(Top)页面 & 堆栈
## CPU/GPU/耗电

---

| Feature | 优先级 | 时间 |
| :-: | :-: |:-: |
| XCMetrics Workflow | 🌟🌟🌟🌟| 10.13 |
| XCMetrics Test | 🌟🌟🌟🌟| 10.15 |
| 启动器 | 🌟🌟🌟🌟🌟 | 10.18 |
| 初级性能问题诊断 | 🌟🌟🌟 | |
| ANR count & bt & 内存警告提示  | 🌟| |
|  展开详情 轨迹/弹幕 or Toast   | 🌟🌟| |
| 展开功能控制面板  | 🌟| |
| 拖拽 摇一摇隐藏 | 🌟| |

### Basic Workflow

register/monitor -> process -> report -> UI 

### Process Engine

1. Perf Monitor

2. Metrics payloads
                    
                      
---
https://mp.weixin.qq.com/s/cbP0QlxVlr5oeTrf6yYfFw

---

_checkAndDeliverMetricReports
_checkAndDeliverDiagnosticReports

## MXDiagnosticPayload
### cpuExceptionDiagnostics
### diskWriteExceptionDiagnostics
### hangDiagnostics
### crashDiagnostics 

1. MetricKit框架详细解析（一） —— 基本概览（一）
2. MetricKit框架详细解析（二） —— Improving Your App's Performance（一）
3. MetricKit框架详细解析（三） —— Reducing Your App's Memory Use（一）
4. MetricKit框架详细解析（四） —— Gathering Information About Memory Use（一）
5. MetricKit框架详细解析（五） —— Making Changes to Reduce Memory Use（一）
6. MetricKit框架详细解析（六） —— Preventing Memory-Use Regressions & Responding to Low-Memory Warnings（一）

https://developer.apple.com/videos/play/wwdc2020/10081/


