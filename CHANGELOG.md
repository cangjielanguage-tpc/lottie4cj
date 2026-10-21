## 1.0.7

- 修复缺失 saveLayer 和 restoreLayer 接口造成的图层层级显示效果 bug;
- 修复 setFrameRate 设置播放帧率不生效 bug;
- 增加动画尺寸自适应 UI 页面设置的大小功能。

## 1.0.6

- 适配 DevEco Studio 6.1.1。
  - DevEco Studio 6.1.1 Release (6.1.1.280)
  - Cangjie Support Plugin 6.1.1 Beta1 (6.1.1.280)
  - Cangjie Compiler: v1.1.3
  - compatibility-sdk-6.1.1.280

## 1.0.5

- 适配仓颉 1.1.0。
  - DevEco Studio 6.0.0 Release(6.0.0.879)
  - Cangjie Support Plugin 6.0.0.879
  - Cangjie Compiler: 1.1.0 (cjnative)

## 1.0.4

- 修复页面单动画多次连续点击 destroy 和 loadAnimation，卡主几秒后崩溃退出。
- 适配仓颉 1.0.5。
  - DevEco Studio 5.1.1 Release
  - Cangjie Support Plugin 5.1.1.851
  - Cangjie Compiler: 1.0.5 (cjnative)

## 1.0.3

- 适配仓颉 1.0.0。
  - DevEco Studio 5.1.0 Release(5.1.0.828SP1)
  - Cangjie Support Plugin 5.1.0.828
  - Cangjie Compiler: 1.0.0 (cjnative)

## 1.0.2

- 修复动画播放中循环打印 warn 日志 bug。
- 适配仓颉 0.53.21。
  - DevEco Studio 5.0.5 Release(5.0.13.210)
  - Cangjie Support Plugin 5.0.13.210
  - Cangjie Compiler: 0.53.21 (cjnative)

## 1.0.1

- 修复并发图片下载后动画显示不全的 bug。
- 适配仓颉 0.53.19。
    - DevEco Studio 5.0.4 Release(5.0.11.100)
    - Cangjie Support Plugin 5.0.11.100
    - Cangjie Compiler: 0.53.19 (cjnative)

## 1.0.0

- 支持加载本地文件方式加载动画
- 支持加载网络资源以URI路径方式加载动画,支持json和zip/gzip格式,gzip格式只能是单json文件压缩，且结尾为.tar.gz或者.gz
- 支持构建animationData对象加载动画
- 支持动画播放、暂停、销毁等功能