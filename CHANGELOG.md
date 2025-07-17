
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