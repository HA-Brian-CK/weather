import { Chip } from '@kit.ArkUI'
import { MaxAndMinTemperature } from '../../components/MaxAndMinTemperature'

export interface RealTemperatureOptions {
  /** 当前温度 */
  curTemp: number,

  /** 当前空气指数 */
  airQualityIndex: number,

  /** 当前空气质量文本描述 */
  airQualityDesc: string,

  /** 降雨量 */
  rain: number,

  /** 天气描述 */
  weatherText: string,

  /** 最高温 */
  highTemp: number,

  /** 最低温 */
  lowTemp: number
}

@Component
export struct RealTemperature {
  @Require @State options?: RealTemperatureOptions = undefined

  getBgImage() {
    let a = this.options!.weatherText
    if (a.indexOf('云') >= 0) {
      return 'https://img0.baidu.com/it/u=591832552,1421087677&fm=253&fmt=auto&app=138&f=JPEG?w=1067&h=800'
    } else if (a.indexOf('晴') >= 0) {
      return 'https://img0.baidu.com/it/u=3445763601,2548796686&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667'
    } else if (a.indexOf('雨') >= 0) {
      return 'https://pic.rmb.bdstatic.com/bjh/events/11dd5d2a7edf96156209cec4ec433fee9136.jpeg@h_1280'
    } else if (a.indexOf('雪') >= 0) {
      return 'https://img2.baidu.com/it/u=3260450793,1761133322&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=889'
    } else if (a.indexOf('阴') >= 0) {
      return 'https://pic.rmb.bdstatic.com/bjh/news/957af60e2af8b57cdb08b353f1e0398c.png'
    } else {
      return 'https://pic.quanjing.com/cl/cm/QJ6486859335.jpg@%21350h'
    }
  }

  build() {
    RelativeContainer() {
      Image(this.getBgImage())
        .borderRadius(10)
        .width('100%')
        .height('100%')

      Text(`${this.options!.curTemp!}`)
        .font({
          size: 100,
          weight: 500,
        })
        .id('text_temp')
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center, },
        })


      Text('℃')
        .font({
          weight: 500,
          size: 20
        })
        .margin({ left: 6 })
        .alignRules({
          left: { anchor: 'text_temp', align: HorizontalAlign.End },
          top: { anchor: 'text_temp', align: VerticalAlign.Top }
        })


      Row({ space: 20 }) {
        // 描述文本 天气文本多云、晴、小雨等等
        Text(this.options!.weatherText)
        // 最高温度/最低温度
        MaxAndMinTemperature({
          options: {
            // tempMax: this.options!.highTemp,
            // tempMin: this.options!.lowTemp
            tempMax: '',
            tempMin: ''
          }
        })
      }
      .id('row_bottom')
      .alignRules({
        top: { anchor: 'text_temp', align: VerticalAlign.Bottom },
        middle: { anchor: 'text_temp', align: HorizontalAlign.Center }
      })

      Row({ space: 20 }) {
        Chip({
          label: {
            text: `空气 ${this.options!.airQualityDesc} ${this.options!.airQualityIndex}`,
            fontSize: 14,

          },
          allowClose: false,
          prefixIcon: {
            src: $r('app.media.icon_leaves'),
            size: { width: 20, height: 20 }
          }
        })

        Chip({
          label: {
            text: this.options!.rain === 0 ? '暂无降水' : `降雨量 ${this.options!.rain}mm`,
            fontSize: 14,
          },
          allowClose: false,
          prefixIcon: {
            src: $r('app.media.icon_rainy'),
            size: { width: 20, height: 20 }
          }
        })
      }
      .margin({ top: 10 })
      .alignRules({
        top: { anchor: 'row_bottom', align: VerticalAlign.Bottom },
        middle: { anchor: 'row_bottom', align: HorizontalAlign.Center }
      })
    }
    .width('100%')

    //.height('20%')
  }
}