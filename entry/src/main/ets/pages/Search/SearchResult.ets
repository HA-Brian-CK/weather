import { CityMangerModel2, CityWeatherVO } from '../../model/CityManagerModel2'
import { CityModel } from '../../model/CityModel'
import { fetchForecast7DayWeather } from '../../network/api'
import { ForecastWeatherDayResult, Location, RealWeatherResult } from '../../network/type'
import {
  fetchAndCachedForecast24HourWeather,
  fetchAndCachedForecast7DayWeather,
  fetchAndCachedNowAirData,
  fetchAndCachedRealWeatherData,
  getWeatherKvStore,
  updateCitiesInfo
} from '../../utils/WeatherKvStore'
import { distributedKVStore } from '@kit.ArkData'
import { promptAction, router } from '@kit.ArkUI'
import { IconButton } from '../../components/IconButton'
import { DayTrendPageNavParam } from '../DayTrend/DayTrendPage'
import { BusinessError } from '@kit.BasicServicesKit'
import EventUtil from '../../utils/EventUtil'
import LocationUtil from '../../utils/LocationUtil'
import DbUtil from '../../utils/DbUtil'


// function transformToCityWeatherVO(
//   cityInfo: Location,
//   realData: RealWeatherResult,
//   forecastData: ForecastWeatherDayResult
// ): CityWeatherVO {
//   return {
//     city: {
//       cityName: cityInfo.name,
//       locationID: cityInfo.id,
//       isLocationCity: false,
//       createTimestamp: Date.now(),
//       provinceName: cityInfo.adm1,
//       latitude: parseFloat(cityInfo.lat),
//       longitude: parseFloat(cityInfo.lon)
//     },
//     data: {
//       temp: parseInt(realData.now.temp),
//       tempMax: parseInt(forecastData.daily[0].tempMax),
//       tempMin: parseInt(forecastData.daily[0].tempMin),
//       text: realData.now.text,
//
//     }
//   }
// }

//搜索结果卡片样式

@Styles
function searchCard() {
  .width('100%')
  .backgroundColor(Color.Transparent)
  .padding({ top: 12, bottom: 12 })
}


/*
 * 搜索结果列表
 * */
@Component
export struct SearchResult {

  /**
   * 搜索结果列表
   * */
  @Link
  locations: Location[]

  @Link
  cityList: CityModel[]

  private async onCitySelect(item: Location) {
    try {

      let city = LocationUtil.createCityModel(item, '0')
      await DbUtil.insertCity(city)
      this.cityList.push(city)

      let index = this.cityList.length - 1
      EventUtil.send(EventUtil.EVENT_ON_CITY_ADD, {
        msg: `${index}`
      })
      router.back()
    } catch (error) {
      console.error('fetchCityWeatherData failed!', JSON.stringify(error))
      promptAction.showToast({
        message: "网络出错！添加该城市失败!"
      })
    }
  }

  private getCityName(cityName: string, adm1: string, adm2: string, countryName: string) {
    if (adm1.slice(0, adm1.length - 1) === adm2 || adm1 === adm2) {
      return `${cityName} · ${adm1} · ${countryName}`
    } else {
      return `${cityName} · ${adm2} · ${adm1} · ${countryName}`
    }
  }

  build() {
    Column() {
      List() {
        ForEach(
          this.locations,
          (item: Location) => {
            ListItem() {
              Row() {
                Text(this.getCityName(item.name, item.adm1, item.adm2, item.country))
                  .lineBreakStrategy(LineBreakStrategy.HIGH_QUALITY)
                  .width('80%')
                if (
                  !this.cityList.some((existed) => {
                    return existed.locationID === item.id
                  })
                ) {
                  IconButton({
                    options: {
                      iconRes: $r('app.media.icon_add'),
                      iconColor: Color.Gray,
                      buttonColor: Color.Transparent
                    }
                  })
                    .onClick(() => {
                      //this.onCitySelect(item)
                    })
                } else {
                  Row({ space: 6 }) {
                    Text("已添加")
                      .height(36)
                      .font({ size: 14, weight: 300 })
                      .fontColor(Color.Gray)

                    Image($r("app.media.icon_right_arrow"))
                      .size({ height: 20, width: 20 })
                  }
                  .alignItems(VerticalAlign.Center)
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
            }
            .searchCard()
            .onClick(() => {
              //this.navigateToTrendPage(item.id, item.name, item)
              this.onCitySelect(item)
            })
          }
        )
      }
      .scrollBar(BarState.Off)
      .height('100%')
      .width('100%')
    }
    .backgroundColor(Color.White)
    .height('100%')
  }
}
