export declare class CJLottieItem {
    setAnimationConfig(name: string, path: string, pathType: number, loop: number, autoPlay: boolean): void
    playAnimation(lottieName: string): void
    pauseAnimation(lottieName: string): void
    stopAnimation(lottieName: string): void
    destroyAnimation(lottieName: string): void
    goAndStopAnimation(value: number, isFrame: boolean, lottieName: string): void
    constructor ()
}

export declare function testCJ(s: string): string