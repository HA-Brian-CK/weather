import log from '../../common/log'
import { promptAction, router } from '@kit.ArkUI'
import { d1 } from "hytech"
import {
  ForecastWeatherDayResult,
  ForecastWeatherHourResult,
  NowAirResult,
  RealWeatherResult
} from '../../network/type'
import { distributedKVStore } from '@kit.ArkData'
import {
  checkDataValidate,
  fetchAndCachedForecast24HourWeather,
  fetchAndCachedForecast7DayWeather,
  fetchAndCachedNowAirData,
  fetchAndCachedRealWeatherData,
  getWeatherKvStore
} from '../../utils/WeatherKvStore'
import * as constants from '../../common/constants'
import { t } from 'hytech'
import { RealTemperature } from './RealTemperature'
import { Fetch3dayWeather } from './Fetch3dayWeather'
import { DayTrendPageNavParam, Path_DayTrend } from '../DayTrend/DayTrendPage'
import { Forecast24HourWetherComponent, Hour24PageNavParam,
  Path_Hour24Page } from './Forecast24Hour/Forecast24HourWeather'
import { RealTimeWeather } from './RealTimeWeather'
import { BusinessError } from '@kit.BasicServicesKit'
import Api2 from '../../network/Api2';
import { CityModel } from '../../model/CityModel';


export interface CityWeatherOptions {
  locationID: string,
}

interface RealTemperatureVO {
  curTemp: number
  weatherDesc: string
  airQualityIndex: number
  airQualityDesc: string,
  rain: number,
  highestTemp: number,
  lowestTemp: number,
}

function transformRealTemperatureVO(
  realWeatherData: RealWeatherResult,
  airData: NowAirResult,
  forecastData: ForecastWeatherDayResult
) {
  const vo: RealTemperatureVO = {
    curTemp: parseInt(realWeatherData.now.temp),
    weatherDesc: realWeatherData.now.text,
    airQualityIndex: parseInt(airData.now.aqi),
    airQualityDesc: airData.now.category,
    rain: parseFloat(realWeatherData.now.precip),
    highestTemp: parseInt(forecastData.daily[0].tempMax),
    lowestTemp: parseInt(forecastData.daily[0].tempMin),

  }
  return vo
}


/**
 * 城市天气的主要组件
 * 主要逻辑：
 * 1. 从本地缓存中获取历史数据，使用该数据，如果超过过期时间，进行更新~
 * 2. 下拉刷新操作
 * */
@Entry
@Component
export struct CityWeatherFragment {
  //@Consume("pageStack") pathStack: NavPathStack
  @Watch('watchProp')
  @Prop locationID: string
  /** 刷新状态 */
  @State
  private refreshing: boolean = false
  /** 当前刷新完成数 */
  @State
  private refreshingCounter: number = 0
  @State
  private refreshingText: string = '刷新中...'
  // private kvStore?: distributedKVStore.DeviceKVStore = undefined
  /** 实时天气数据 */
  @State
  //@Watch('updateRealTemperatureVOData')
  private realWeatherData?: RealWeatherResult = undefined
  /** 7天预测数据 */
  @State
  private forecast7DayData?: ForecastWeatherDayResult = undefined

  /** 24小时预测数据 */
  @State
  private hour24Data?: ForecastWeatherHourResult = undefined

  /** 空气数据 */
  @State
  private nowAirData?: NowAirResult = undefined

  /** 实时天气数据VO */
  @State
  private realTemperatureVOData?: RealTemperatureVO = undefined

  /**
   * 开始刷新操作
   * */
  private startRefreshing() {
    this.refreshing = true
    this.refreshingCounter++
    this.refreshingText = "刷新中..."
  }

  /**
   * 刷新完毕操作
   * */
  private completedRefreshing() {
    this.refreshingCounter--;
    if (this.refreshingCounter === 0) {
      this.refreshingText = "刷新成功！"
      setTimeout(() => {
        this.refreshing = false
      }, 500)
    }
  }

  /**
   * 刷新实时天气数据(实时温度、空气数据、7天数据)
   * */
  private async requestAllData() {
    log.log('zhu requestAllData()')
    this.startRefreshing()
    try {
      this.realWeatherData = await Api2.fetchAndCachedRealWeatherData(this.locationID)
      this.nowAirData = await Api2.fetchAndCachedNowAirData(this.locationID)
      this.forecast7DayData = await Api2.fetchAndCachedForecast7DayWeather(this.locationID)
      this.hour24Data = await Api2.fetch24Data(this.locationID)

      // 更新状态变量
      this.realTemperatureVOData =
        transformRealTemperatureVO(this.realWeatherData!, this.nowAirData!, this.forecast7DayData!)

    } catch (error) {
      promptAction.showToast({
        message: '网络错误！请重新刷新！'
      })
      log.error('zhu fetchRealWeatherData', error)
    } finally {
      this.completedRefreshing()
    }
  }

  watchProp(): void {
    console.log('zhu fragment watchProp()')
    this.requestAllData()
  }

  aboutToAppear(): void {
    console.log('zhu fragment aboutToAppear()')
    this.requestAllData()
  }

  private go24Page() {
    const data: Hour24PageNavParam = {
      dataList: this.hour24Data?.hourly
    }
    //this.pathStack.pushDestinationByName("Hour24Page", data, true)
    router.pushUrl({
      url: Path_Hour24Page,
      params: data
    })
  }

  private goTrendPage() {
    const data: DayTrendPageNavParam = {
      shouldShowNavigation: false,
      added: true,
      locationID: this.locationID,
      cityName: '',
      data: this.forecast7DayData!
    }
    //this.pathStack.pushDestinationByName("day_trend", data, true)
    router.pushUrl({
      url: Path_DayTrend,
      params: data
    })
  }

  build() {
    Refresh({ refreshing: $$this.refreshing, promptText: this.refreshingText }) {
      Scroll() {

        Column({ space: 24 }) {
          if (this.realTemperatureVOData) {
            Column() {
              RealTemperature({
                options: {
                  curTemp: this.realTemperatureVOData!.curTemp,
                  weatherText: this.realTemperatureVOData!.weatherDesc,
                  highTemp: this.realTemperatureVOData!.highestTemp,
                  lowTemp: this.realTemperatureVOData!.lowestTemp,
                  rain: this.realTemperatureVOData!.rain,
                  airQualityIndex: this.realTemperatureVOData!.airQualityIndex,
                  airQualityDesc: this.realTemperatureVOData!.airQualityDesc,
                }
              })
                .height(300)
                .margin({top:16})

              RealTimeWeather({
                options: {
                  sunset: this.forecast7DayData!.daily[0].sunset ?? '',
                  sunrise: this.forecast7DayData!.daily[0].sunrise ?? '',
                  moonrise: this.forecast7DayData!.daily[0].moonrise ?? '',
                  moonset: this.forecast7DayData!.daily[0].moonset ?? '',
                  uvIndex: this.forecast7DayData!.daily[0].uvIndex,
                  realData: this.realWeatherData!
                }
              }).margin({top:20})

              Button("查看今日预报")
                .backgroundColor($r('app.color.tint_main'))
                .width("100%")
                .fontColor('#fff')
                .margin({ top: 20 })
                .onClick(() => {
                  this.go24Page()
                })

              Button("查看一周天气")
                .backgroundColor($r('app.color.tint_main'))
                .width("100%")
                .fontColor('#fff')
                .margin({ top: 20, bottom: 20 })
                .onClick(() => {
                  this.goTrendPage()
                })

            }
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Start)
            //.justifyContent(FlexAlign.SpaceBetween) // 保证分开两部分
            .width('100%')

          }
        }
        .attributeModifier(t)
        .width("100%")
        .padding({ left: 16, right: 16 })
        .backgroundColor($r('app.color.gray_bg'))
      }
      .height('100%')
      .width('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .attributeModifier(d1)
    }
    .height('100%')
    .width('100%')
    .onRefreshing(() => {
      this.requestAllData()
    })
  }
}


