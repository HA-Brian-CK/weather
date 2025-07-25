// 导入页面路由模块
import router from '@ohos.router';
// 导入弹窗
import promptAction from '@ohos.promptAction';
import PreferenceUtil from '../utils/PreferencesUtil';

export const Path_Regist = 'pages/RegistPage'

@Entry
@Component
struct RegistPage {
  @State userName: string = 'admin'; // 用户名
  @State password: string = 'admin'; // 密码
  @State password2: string = 'admin'; // 密码

  build() {
    Stack() {
      Column() {
        Row() {
          Image($r('app.media.back'))
            .width(30)
            .height(30)
            .borderRadius(10)
            .margin({ top: 40, left: 16 })
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          router.back()
        })

        Blank().layoutWeight(1)

        Image($r("app.media.icon"))
          .width(100)
          .height(100)
          .borderRadius(16)
          .margin({ bottom: 10, top: 60 })

        // 欢迎文字
        Text('用户注册')
          .fontSize('30fp')
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 30 })

        // 用户名和密码输入框
        TextInput({ placeholder: '请输入手机号' })
          .inputStyle()// 公共样式函数
          .maxLength(11)
          .onChange(data => { // 输入框的值发生变化时，触发回调，data代表输入的内容
            this.userName = data;
            console.info('user:' + data)
          }).margin({ left: 20, right: 20, top: 10 })

        TextInput({ placeholder: '请输入密码' })
          .type(InputType.Password)// 输入框类型
          .inputStyle()// 公共样式函数
          .onChange(data => { // 输入框的值发生变化时，触发回调，data代表输入的内容
            this.password = data;
            console.info('password:' + data)
          }).margin({ left: 20, right: 20, top: 10 })

        TextInput({ placeholder: '请再次输入密码' })
          .type(InputType.Password)// 输入框类型
          .inputStyle()// 公共样式函数
          .onChange(data => { // 输入框的值发生变化时，触发回调，data代表输入的内容
            this.password2 = data;
            console.info('password:' + data)
          }).margin({ left: 20, right: 20, top: 10 })

        // 登录按钮
        Button('注册', { type: ButtonType.Capsule })
          .width('50%')
          .margin({ top: 60, left: 20, right: 20, bottom:300 })
          .backgroundColor($r('app.color.tint_main'))
          .onClick(() => {
            this.loginBtnClick()
          })

      }
      .justifyContent(FlexAlign.End)
      .width('100%')
    }
    .width('100%')
    .height('100%')

  }

  loginBtnClick() {
    // 判断用户名和密码非空
    if (this.userName == ''
      || this.password == ''
      || this.password2 == '') {
      // 不能跳转，同时提示
      promptAction.showToast({
        message: '手机号、密码、再次密码不能为空不能为空',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    if (this.password != this.password2) {
      promptAction.showToast({
        message: '密码、再次密码必须相同',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    PreferenceUtil.putPreferenceValue('user_name', this.userName)
    PreferenceUtil.putPreferenceValue('pwd', this.password)
    promptAction.showToast({
      message: '注册成功',
      duration: 1000,
      bottom: '360vp'
    })
    router.back()
  }
}

// 添加公共的样式函数
// @Extend装饰器：扩展组件样式
// @Extend(组件描述名称) function 样式名称
// 输入框公共样式函数
@Extend(TextInput)
function inputStyle() {
  .placeholderColor(Color.Gray)
  .backgroundColor(Color.White)
  .maxLength(6)
  .padding('12vp')
  .margin('10vp')
  .borderWidth({bottom:2})
  .borderColor($r('app.color.tint_main'))
  .borderRadius(0)
}

// 原型按钮公共样式函数
@Extend(Button)
function circleBtnStyle() {
  .width('60vp')
  .height('60vp')
}
