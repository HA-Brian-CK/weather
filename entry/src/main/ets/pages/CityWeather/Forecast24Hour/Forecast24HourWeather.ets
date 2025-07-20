import { Forecast24HourWeatherViewModel } from '../../../viewmodel/Forecast24HourWeatherViewModel'
import { HourlyWeatherResult } from '../../../network/type'
import { COMPONENT_BACKGROUND_COLOR } from '../../../common/constants'
import { o } from "hytech"
import { ForecastHourItem, ForecastHourItemOptions } from './ForecastHourItem'
import { max, min } from '../../../utils/MathUtils'
import { checkLast } from '../../../utils/ArrayUtils'
import { router } from '@kit.ArkUI'

function transformForecastHourItemOptions(
  res: HourlyWeatherResult[],
): Array<ForecastHourItemOptions> {


  const tempMin = min((item) => {
    return parseInt(item.temp)
  }, ...res)

  const tempMax = max((item) => {
    return parseInt(item.temp)
  }, ...res)

  const result: Array<ForecastHourItemOptions> = res.map((item, index): ForecastHourItemOptions => {
    return {
      data: item,
      tempMax: tempMax,
      tempMin: tempMin,
      leftTemp: index != 0 ? parseInt(res[index - 1].temp) : undefined,
      rightTemp: !checkLast(index, res) ? parseInt(res[index + 1].temp) : undefined,
      index: index,
    }
  })
  return result
}


@Builder
export function Hour24View() {
  Forecast24HourWetherComponent({
    dataList: Forecast24HourWeatherViewModel.hourly
  })
}

export interface Hour24PageNavParam {
  dataList: HourlyWeatherResult[] | undefined;
}

export const Path_Hour24Page = 'pages/CityWeather/Forecast24Hour/Forecast24HourWeather'

@Entry
@Component
export struct Forecast24HourWetherComponent {
  @State @Require
  dataList: HourlyWeatherResult[] | undefined = Forecast24HourWeatherViewModel.hourly

  // @State
  // private param: Optional<Hour24PageNavParam> = undefined

  // @Provide({ allowOverride: 'pathStack' })
  // private pageStack: NavPathStack = new NavPathStack()

  /** 从 NavPathStack 获取展示数据 */
  // private getParamFromPathStack() {
  //     this.param = this.pageStack.getParamByName("Hour24Page")[0] as Hour24PageNavParam
  //     console.log('h24 navigation param',)
  //     this.dataList = (this.param.dataList)
  // }
  aboutToAppear(): void {
    console.log('zhu 24HourWether aboutToAppear' + JSON.stringify(router.getParams()))
    const routeParam = router.getParams() as Hour24PageNavParam
    this.dataList = routeParam.dataList
  }

  @Builder
  today24hour() {
    Stack() {
      Image($r('app.media.bg6'))
        .objectFit(ImageFit.Cover)
        .width('100%')
        .height('100%')

      Column({ space: 8 }) {
        // header
        Row({ space: 8 }) {
          Image($r('app.media.icon_clock'))
            .width(20)
            .fillColor(Color.Gray)
          Text('24小时预报')
            .fontColor(Color.Gray)
        }
        .width('100%')

        List() {
          ForEach(
            transformForecastHourItemOptions(this.dataList!),
            (item: ForecastHourItemOptions) => {
              ListItem() {
                ForecastHourItem({
                  options: item
                })
              }
              .width('20%')
            }
          )
        }
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
      }
      .padding({
        top: 12,
        bottom: 12,
        left: 12,
        right: 12
      })
      .borderRadius(16)
      //.backgroundColor(COMPONENT_BACKGROUND_COLOR)
      //.backgroundColor(Color.White)
      .backdropBlur(10)
      .height('100%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .attributeModifier(o)
  }

  build() {
    /*NavDestination() {
      Stack() {
        Image($r('app.media.bg6'))
          .objectFit(ImageFit.Cover)
          .width('100%')
          .height('100%')

        Column({ space: 8 }) {
          // header
          Row({ space: 8 }) {
            Image($r('app.media.icon_clock'))
              .width(20)
              .fillColor(Color.Gray)
            Text('24小时预报')
              .fontColor(Color.Gray)
          }
          .width('100%')

          List() {
            ForEach(
              transformForecastHourItemOptions(this.dataList!),
              (item: ForecastHourItemOptions) => {
                ListItem() {
                  ForecastHourItem({
                    options: item
                  })
                }
                .width('20%')
              }
            )
          }
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)
          .width('100%')
          .height('100%')
        }
        .padding({
          top: 12,
          bottom: 12,
          left: 12,
          right: 12
        })
        .borderRadius(16)
        //.backgroundColor(COMPONENT_BACKGROUND_COLOR)
        //.backgroundColor(Color.White)
        .backdropBlur(10)
        .height('100%')
        .width('100%')
      }
      .width('100%')
      .height('100%')
    }
    .title(`今日24小时`)
    .height('100%')
    .width('100%')
    .onReady((context) => {
      //this.pageStack = context.pathStack
      //this.getParamFromPathStack()
    })
    .margin({ top: 40 })*/

    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(30)
          .height(30)
          .borderRadius(10)
          .margin({ left: 16 })
        Text('未来24小时预报')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
      }
      .margin({ top: 50, bottom: 16 })
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        router.back()
      })

      Column() {
        this.today24hour()
      }
      .width('100%')
      .height('100%')

    }

  }
}
