// 导入页面路由模块
import router from '@ohos.router';
// 导入弹窗
import promptAction from '@ohos.promptAction';
import { preferences } from '@kit.ArkData';
import PreferenceUtil from '../utils/PreferencesUtil';
import { Path_Main } from './MainPage';
import { Path_Regist } from './RegistPage';
import LocationUtil from '../utils/LocationUtil';

export const Path_Login = 'pages/LoginPage'

@Entry
@Component
struct Login {
  @State user: string = '123'; // 用户名
  @State password: string = '123'; // 密码

  build() {
    Stack() {
      Column() {
        // logo
        Image($r("app.media.icon"))
          .width(100)
          .borderRadius(16)
          .margin({ bottom: '10vp' })

        // 欢迎文字
        Text('云游天气')
          .fontSize('40fp')
          .fontColor($r('app.color.tint_main'))
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: '30vp'})

        // 用户名和密码输入框
        TextInput({ placeholder: '请输入手机号' })
          .maxLength(11)
          .onChange(data => { // 输入框的值发生变化时，触发回调，data代表输入的内容
            this.user = data;
            console.info('user:' + data)
          })
          .margin({ left: 20, right: 20, top: 20 })
          .borderWidth({bottom:2})
          .borderColor($r('app.color.tint_main'))
          .borderRadius(0)
          .backgroundColor(Color.White)
          .placeholderColor(Color.Grey)

        TextInput({ placeholder: '请输入密码' })
          .type(InputType.Password)// 输入框类型
          .onChange(data => { // 输入框的值发生变化时，触发回调，data代表输入的内容
            this.password = data;
            console.info('password:' + data)
          })
          .margin({ left: 20, right: 20, top: 10})
          .borderWidth({bottom:2})
          .borderColor($r('app.color.tint_main'))
          .borderRadius(0)
          .backgroundColor(Color.White)
          .placeholderColor(Color.Grey)

        // 文字提示
        Row() {
          // Text('短信验证码登录')
          //   .fontSize('16fp')
          //   .fontColor(Color.Blue)
          Text('忘记密码？')
            .fontSize('16fp')
            .fontColor(Color.Grey)
            .margin({ right: 30, top: 10 })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)

        // 登录按钮
        Button('登录', { type: ButtonType.Capsule })
          .width('50%')
          .margin({ top: 20 })
          .backgroundColor($r('app.color.tint_main'))
          .onClick(() => {
            this.loginBtnClick()
          })

        Row() {
          Text('注册')
            .fontSize('16fp')
            .fontColor($r('app.color.tint_main'))
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 15 ,bottom:80})
        .onClick(() => {
          this.registBtnClick()
        })

        // 其他
        Row() {
          Blank().height(0.5).layoutWeight(1)
            .backgroundColor($r('app.color.tint_gray'))
            .margin({ left: 10, right: 10 })
          Text('其他登录方式')
            .fontSize('16fp')
            .fontColor(Color.Gray)
          Blank().height(0.5).layoutWeight(1)
            .backgroundColor($r('app.color.tint_gray'))
            .margin({ left: 10, right: 10 })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 40 })

        // 三个按钮
        Row() {
          // ForEach(this.otherData, (item: string) => {
          //   Button(item, { type: ButtonType.Circle })
          //     .circleBtnStyle()
          // }, (item: string) => JSON.stringify(item))
          Row() {
            Image($r('app.media.huawei')).width(40).height(40).borderRadius(20)
            Text('华为账号').margin({left:16})
          }.layoutWeight(1).alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)

          Row() {
            Image($r('app.media.weixin')).width(40).height(40).borderRadius(20)
            Text('微信').margin({left:16})
          }.layoutWeight(1).alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .margin('20vp')
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  async loginBtnClick() {
    // 判断用户名和密码非空
    if (this.user == '' || this.password == '') {
      // 不能跳转，同时提示
      promptAction.showToast({
        message: '手机号或密码不能为空',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    let v: preferences.ValueType = await PreferenceUtil.getPreferenceValue('user_name', '')
    if (v == '') {
      promptAction.showToast({
        message: '您还未注册',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    if (v != this.user) {
      promptAction.showToast({
        message: '手机号不正确',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    let v2: preferences.ValueType = await PreferenceUtil.getPreferenceValue('pwd', '')
    if (v2 != this.password) {
      promptAction.showToast({
        message: '密码不正确',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    promptAction.showToast({
      message: '登录成功',
      duration: 1000,
      bottom: '360vp'
    })
    // 路由跳转
    router.replaceUrl({
      url: Path_Main
    }).catch((err: Error) => {
      // 错误提示
    })
  }

  registBtnClick() {
    router.pushUrl({
      url: Path_Regist
    }).catch((err: Error) => {
      // 错误提示
    })
  }
  aboutToAppear(): void {

  }
}

// 添加公共的样式函数
// @Extend装饰器：扩展组件样式
// @Extend(组件描述名称) function 样式名称
// 输入框公共样式函数
@Extend(TextInput)
function inputStyle() {
  .placeholderColor(Color.White)
  .backgroundColor('#4dffffff')
  .maxLength(6)
  .padding('12vp')
  .margin('10vp')
}

// 原型按钮公共样式函数
@Extend(Button)
function circleBtnStyle() {
  .width('60vp')
  .height('60vp')
}
