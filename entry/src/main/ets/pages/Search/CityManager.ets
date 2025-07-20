import { CityModel } from '../../model/CityModel'
import { MaxAndMinTemperature } from '../../components/MaxAndMinTemperature'
import { t } from 'hytech'
import { promptAction, router } from '@kit.ArkUI'
import EventUtil from '../../utils/EventUtil'
import DbUtil from '../../utils/DbUtil'

/*
 * 城市管理
 * */
@Component
export struct CityManager {
  @Watch('watchCityList')
  @Link cityList: CityModel[]

  watchCityList() {
    //this.tempCityList = this.cityList
  }

  private onSelectCity(locationID: string, index: number) {

    EventUtil.send(EventUtil.EVENT_ON_CITY_SELECT, {
      msg: `${index}`
    })
    router.back()
  }

  private deleteCity(locationID: string, item: CityModel) {
    const index = this.cityList.findIndex((item) => {
      return item.locationID === locationID
    });
    if (index !== -1) {
      this.cityList.splice(index, 1)
    }
    this.cityList = this.cityList

    DbUtil.deleteCity(item.id_).then(()=>{
      promptAction.showToast({
        message: '删除数据库成功',
        duration: 1000,
        bottom: '360vp'
      })
      EventUtil.send(EventUtil.EVENT_ON_CITY_DELETE, {
        msg: `${index}`
      })
    })

  }

  private setLike(isLike: string) {
    if (isLike == '1') {
      return '0'
    }
    return '1'
  }

  private onLikeClick(item: CityModel, index: number) {

    /**
     * 解决@Link不更新UI的问题
     */
    const newList = this.cityList.map(item1 => {
      if (item1.cityName === item.cityName) {
        item1.isLike = this.setLike(item1.isLike)
        return item1;
      }
      return item1;
    });
    // 替换整个列表引用
    this.cityList = newList;

    promptAction.showToast({
      message: '更新数据库成功',
      duration: 1000,
      bottom: '360vp'
    })
    DbUtil.updateCity(item)
  }

  @Builder
  likeButton(item: CityModel, index: number) {
    Button() {
      Image(item.isLike == '1' ? $r('app.media.like_red') : $r('app.media.like_black'))
        .fillColor(Color.White)
        .width(20)
    }
    .margin({ left: 3, right: 3 })
    .width(40)
    .height(40)
    //.type(ButtonType.Circle)
    .role(item.isLike == '1' ? ButtonRole.ERROR : ButtonRole.NORMAL)
    .onClick(() => {
      this.onLikeClick(item, index)
    })
  }

  @Builder
  deleteButton(item: CityModel, index: number) {
    Button() {
      Image($r('app.media.icon_delete'))
        .fillColor(Color.White)
        .width(20)
    }
    .margin({ left: 3, right: 3 })
    .width(40)
    .height(40)
    .visibility(item.isLocationCity == '0' ? Visibility.Visible : Visibility.Hidden)
    .type(ButtonType.Circle)
    .role(ButtonRole.ERROR)
    .onClick(() => {
      this.deleteCity(item.locationID, item)
    })
  }

  aboutToAppear(): void {
    // getWeatherKvStore(getContext(this))
    //     .then((store) => {
    //         this.weatherKvStore = store
    //     })
  }

  build() {
    Column() {
      List({ space: 20 }) {
        ForEach(
          this.cityList,
          (item: CityModel, index: number) => {
            ListItem() {
              Row() {
                Column() {
                  Text(item.cityName)
                    .fontColor(Color.White)
                    .fontSize(22)
                    .margin({ bottom: 5 })

                  Row({ space: 8 }) {
                    Text(`${item.provinceName}`)
                      .fontColor(Color.White)
                    MaxAndMinTemperature({
                      options: {
                        tempMax: item.longitude,
                        tempMin: item.latitude,
                        textColor: Color.White
                      }
                    })
                  }
                }
                .alignItems(HorizontalAlign.Start)

                // Column() {
                //   Text(item.isLocationCity)
                //     .foregroundColor(Color.White)
                //     .fontSize(30)
                // }
                this.likeButton(item, index)

                this.deleteButton(item, index)
              }
              .cityCard()
              .justifyContent(FlexAlign.SpaceBetween)
            }
            //.swipeAction({ end: this.deleteButton(item.locationID) })
            .onClick(() => {
              this.onSelectCity(item.locationID, index)
            })
          }
        )
      }
      .width('100%')
      .height('100%')
      .alignListItem(ListItemAlign.Center)
      .scrollBar(BarState.Off)

    }
    .margin({ top: 20 })
    .width('100%')
    .height('100%')
    .attributeModifier(t)
  }
}


//城市管理卡片样式

@Styles
function cityCard() {
  .width('100%')
  // .backgroundColor('#a62381d8')
  .backgroundColor('#a62cd69b')
  .padding(16)
  .borderRadius(14)
  .shadow({
    radius: 4,
    color: '#f0f0f0',
    offsetX: 2,
    offsetY: 4
  })
}


