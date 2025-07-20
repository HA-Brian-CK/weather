import { m as saveData } from 'ohbuild';
import router from '@ohos.router';
import { Path_Login } from './LoginPage';

/**
 * 欢迎页，可以设置倒计时
 */

export const Path_Splash = 'pages/SplashPage'

@Entry
@Component
struct SplashPage {
  //倒计时
  @State countDownSeconds: number = 4;
  private timeId: number = 0;
  private TAG: string = 'AdvertisingPage';

  onPageShow() {
    this.timeId = setInterval(() => {
      if (this.countDownSeconds === 0) {
        this.jumpToAppHomePage();
      } else {
        this.countDownSeconds--;
      }
    }, 1000);
  }

  onPageHide() {
    router.clear();
    clearInterval(this.timeId);
  }

  /**
   * 跳转到主页.
   */
  jumpToAppHomePage() {
    router.replaceUrl({
      url: Path_Login
    }).then(()=>{
      saveData('weathering')
    }).catch((error: Error) => {
      //Logger.error(this.TAG, 'AdvertisingPage pushUrl error ' + JSON.stringify(error));
    });
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.splash'))
        .width('100%')
        .height('100%')
      Text(`跳过 ${this.countDownSeconds}`)
        .fontColor(Color.White)
        .fontSize('12fp')
        .letterSpacing(0.05)
        .backgroundColor('#33000000')
        .border({
          radius: '18vp',
          width: '1',
          color: Color.White
        })
        .margin({
          top: '50vp',
          left: '260vp'
        })
        .padding({
          left: '12vp',
          top: '8vp',
          right: '12vp',
          bottom: '8vp'
        })
        .onClick(() => {
          this.jumpToAppHomePage();
        })

      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center
      }) {
        Image($r("app.media.app_icon"))
          .width(100)
          .borderRadius(16)
          .margin({ bottom: '20vp' })

        Text('云游天气')
          .fontSize('30fp')
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ top: '20vp' })
      }
      .width('100%')
      .height('100%')
      .margin({top:'-125vp'})

    }

  }
}