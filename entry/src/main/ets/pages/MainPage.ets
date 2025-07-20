import { CityModel } from '../model/CityModel'
import { CityWeatherFragment } from './CityWeather/CityWeatherFragment'
import { t } from 'hytech'
import { router } from '@kit.ArkUI';
import { b1 } from "hytech"
import { Path_Search } from './Search/SearchPage';
import EventUtil, { EventData } from '../utils/EventUtil';
import DbUtil from '../utils/DbUtil';

export const Path_Main = 'pages/MainPage'

@Entry
@Component
struct MainPage {
  @State
  private cityList: Array<CityModel> = []
  private controller = new TabsController()

  /**
   * 跳转到搜索页面
   * */
  private navigateToSearchPage() {
    router.pushUrl({
      url: Path_Search
    })
  }

  onPageShow(): void {
    console.log('zhu main onPageShow()')
  }

  async aboutToAppear(): Promise<void> {
    this.cityList = await DbUtil.queryCityList()
    console.log('zhu main aboutToAppear() = '+this.cityList.length)
    let that = this
    EventUtil.register(EventUtil.EVENT_ON_CITY_SELECT, async (d) => {
      let i = parseInt(d!.msg)
      this.controller.changeIndex(i)
    })
    EventUtil.register(EventUtil.EVENT_ON_CITY_DELETE, (d) => {
      let i = parseInt(d!.msg)
      this.cityList.splice(i, 1)
      this.controller.changeIndex(0)
    })
    EventUtil.register(EventUtil.EVENT_ON_CITY_ADD, async (d) => {
      this.cityList = await DbUtil.queryCityList()
      let i = parseInt(d!.msg)

      setTimeout(() => {
        this.controller.changeIndex(i)
      }, 500)
    })
  }

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontSize(16)
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(500)
        .id(index.toString())
    }.attributeModifier(t)
    .width('100%')
  }

  build() {
    Column() {
      Blank().height(40)
      RelativeContainer() {
        // 添加地区按钮
        Row() {

          Image($r('app.media.icon_add'))
            .width(40)
            .height(40)
            .onClick(() => {
              this.navigateToSearchPage()
            })
        }
        .height(56)
        .padding({ left: 20 })
        .zIndex(5)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignSelf(ItemAlign.Center)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })

        // 主体内容区域
        Tabs({
          barPosition: BarPosition.Start,
          controller: this.controller
        }) {
          ForEach(this.cityList, (item: CityModel, index: number) => {
            TabContent() {
              CityWeatherFragment({
                locationID: item.locationID
              })
            }
            .tabBar(this.tabBuilder(index, `${item.provinceName} · ${item.cityName}`))
            .height('100%')
          })
        }
        .barWidth('70%')
        .barMode(BarMode.Scrollable)
        .attributeModifier(b1)
        .height('100%')
      }
      .layoutWeight(1)
      .width('100%')
      .height('100%')
    }.height('100%')

  }
}

