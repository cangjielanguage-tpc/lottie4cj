import { CJHybridComponentV2 } from '@cangjie/cjhybridview';
import { requireCJLib } from 'libark_interop_loader.so';
import { CJLottieItem, testCJ } from 'libohos_app_cangjie_entry.so';

interface CJLib {
  setContext(context: Context): string
}

export class CangjieLib {
  private constructor() {}

  private static instance: CJLib;

  public static getInstance(): CJLib {
    if (!CangjieLib.instance) {
      CangjieLib.instance = requireCJLib("libohos_app_cangjie_entry.so") as CJLib
    }
    return CangjieLib.instance;
  }
}

@Entry
@Component
struct Index {

  lottieName: string = "lottieName"
  cjLottieItem: CJLottieItem|null = null

  aboutToAppear(): void {
    this.cjLottieItem = new CJLottieItem()
  }

  build() {
    Flex({direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center}) {
      CJHybridComponentV2({
        library: "ohos_app_cangjie_entry",
        component: "CJLottieComp"
      }).height('30%')

      Column({space: 15}) {
        Button("加载2016-happy")
          .onClick(() => {
            console.error("[test]--------------------begin")
            this.lottieName = "2016"
            this.cjLottieItem?.setAnimationConfig(this.lottieName, "data.json", 1, -1, true)
          })
          .width('80%')

        Button("加载grunt")
          .onClick(() => {
            console.error("[test]--------------------begin")
            this.lottieName = "grunt"
            this.cjLottieItem?.setAnimationConfig(this.lottieName, "grunt.json", 1, -1, true)
          })
          .width('80%')

        Button("加载网络json")
          .onClick(() => {
            console.error("[test]--------------------begin")
            this.lottieName = "lf20_sF7uci.json"
            this.cjLottieItem?.setAnimationConfig(this.lottieName, "https://assets7.lottiefiles.com/packages/lf20_sF7uci.json", 3, -1, true)
          })
          .width('80%')

        // Button("加载phonemopney")
        //   .onClick(() => {
        //     console.error("[test]--------------------begin")
        //     this.lottieName = "phonemopney"
        //     this.cjLottieItem?.setAnimationConfig(this.lottieName, "jingdong/phonemoney/phonemoney.json", 1, -1, false)
        //   })
        //   .width('80%')

        Button("pause animation")
          .onClick(() => {
            this.cjLottieItem?.pauseAnimation(this.lottieName)
          })
          .width('80%')
        Button("stop animation")
          .onClick(() => {
            this.cjLottieItem?.stopAnimation(this.lottieName)
          })
          .width('80%')
        Button("play animation")
          .onClick(() => {
            this.cjLottieItem?.playAnimation(this.lottieName)
          })
          .width('80%')
        Button("destroy animation")
          .onClick(() => {
            this.cjLottieItem?.destroyAnimation(this.lottieName)
          })
          .width('80%')
        Button("go and stop at 50 frame")
          .onClick(() => {
            this.cjLottieItem?.goAndStopAnimation(50, true, this.lottieName)
          })
          .width('80%')
      }
    }
    .width('100%')
    .height('100%')
  }
}