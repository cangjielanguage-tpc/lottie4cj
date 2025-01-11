import { CJHybridComponentV2 } from 'cjhybridview'
import { requireCJLib } from 'libark_interop_loader.so'

@Entry
@Component
struct Index {
  lottie: number = 0
  lottieName: string = "grunt"

  build() {
    Column() {
      CJHybridComponentV2({
        library: 'ohos_app_cangjie_entry',
        // component: 'CJLottieComp'
        component: 'Index'
      })

      /*
      Column({ space: 20 }) {
        Button("加载phonemoney")
          .onClick(() => {
            console.error("[test]--------------------begin")
            this.lottieName = "phonemoney"
            this.cjlottie?.setAnimationConfig(this.lottieName, "jingdong/phonemoney/phonemoney.json", 1, -1, true)
          })
          .width('80%')

        Button("加载hongbao")
          .onClick(() => {
            console.error("[test]--------------------begin")
            this.lottieName = "hongbao"
            this.cjlottie?.setAnimationConfig(this.lottieName, "jingdong/hongbao/data.json", 1, -1, true)
          })
          .width('80%')

        Button("加载door_lock网络zip")
          .onClick(() => {
            console.error("[test] 网络zip --------------------begin")
            this.lottieName = "door_lock_net"
            // 传递要加载的json文件名称和路径 区分工程目录=1/手机本地路径=2/网络下载=3 设置循环次数和是否自动播放
            this.cjlottie?.setAnimationConfig(this.lottieName, "https://smarthome-drcn.dbankcdn.com/device/guide/KW38/template/lottie/lottie.zip", 3, -1, true)
          })
          .width('80%')

        Button("加载door_lock本地")
          .onClick(() => {
            console.error("[test] 工程目录 --------------------begin")
            this.lottieName = "door_lock"
            // 传递要加载的json文件名称和路径 区分工程目录=1/手机本地路径=2/网络下载=3 设置循环次数和是否自动播放
            this.cjlottie?.setAnimationConfig(this.lottieName, "door_lock.json", 1, -1, true)
          })
          .width('80%')

        Button("加载2016网络zip")
          .onClick(() => {
            console.error("[test] 网络zip --------------------begin")
            this.lottieName = "door_lock_net"
            // 传递要加载的json文件名称和路径 区分工程目录=1/手机本地路径=2/网络下载=3 设置循环次数和是否自动播放
            this.cjlottie?.setAnimationConfig(this.lottieName, "https://raw.gitcode.com/lipeifsxz/testlottie/blobs/a2f41a84c6fc900df5056355399a609734583eed/happy.zip", 3, -1, true)
          })
          .width('80%')

        Button("pause animation")
          .onClick(() => {
            this.cjlottie?.pauseAnimation(this.lottieName)
          })
          .width('80%')
        Button("stop animation")
          .onClick(() => {
            this.cjlottie?.stopAnimation(this.lottieName)
          })
          .width('80%')
        Button("销毁")
          .onClick(() => {
            this.cjlottie?.destroyAnimation(this.lottieName)
          })
          .width('80%')
      }
       */
    }
    .height('100%')
    .width('100%')
  }
}