import { CityManagerList } from '../../viewmodel/CityManagerViewModel'
import { CityMangerModel2, CityWeatherVO, WeatherData } from '../../model/CityManagerModel2'
import {
    fetchAndCachedForecast7DayWeather,
    fetchAndCachedRealWeatherData,
    getWeatherKvStore
} from '../../utils/WeatherKvStore'
import { distributedKVStore } from '@kit.ArkData'
import { KEY_CITIES_INFO } from '../../common/constants'
import { CityModel } from '../../model/CityModel'
import { BusinessError } from '@kit.BasicServicesKit'
import { SearchLink } from './SearchLink'
import { ForecastWeatherDayResult, RealWeatherResult } from '../../network/type'
import * as constants from '../../common/constants'
import { KVStoreCachedModel } from '../../model/KVStoreCachedModel'
import { t } from 'hytech'
import { router } from '@kit.ArkUI'
import DbUtil from '../../utils/DbUtil'

export const Path_Search = 'pages/Search/SearchPage'

export interface SearchPageWeatherData {
    temp: number,
    tempMax: number,
    tempMin: number,
    desc: string,
    locationID: string,
}


@Builder
export function SearchPageBuilder() {
    SearchPage()
}


@Entry
@Component
struct SearchPage {
    //@Provide({ allowOverride: 'pathStack' })
    // private pageStack: NavPathStack = new NavPathStack()
    // @State
    // private dataList: CityMangerModel2[] = CityManagerList //测试本地数据
    // @State
    // private tureDataList: CityWeatherVO[] = [] //真实的从主页获取来的数据
    // private weatherKvStore?: distributedKVStore.DeviceKVStore
    @State
    private cityList: CityModel[] = []
    // @State citiesData: WeatherData[] = []

    /**
     * 从数据库中加载天气数据
     * */
    // private async loadWeatherData() {
    //     const data: Array<SearchPageWeatherData> = []
    //     for (let item of this.cityList) {
    //         let weatherData: Optional<RealWeatherResult> = undefined
    //         let forecastData: Optional<ForecastWeatherDayResult> = undefined
    //         try {
    //             weatherData =
    //                 (JSON.parse(
    //                     await this.weatherKvStore!.get(constants.getRealWeatherDataKey(item.locationID)) as string
    //                 ) as KVStoreCachedModel<RealWeatherResult>).data
    //             forecastData =
    //                 (JSON.parse(
    //                     await this.weatherKvStore!.get(constants.getForecastWeatherDayDataKey(item.locationID)) as string
    //                 ) as KVStoreCachedModel<ForecastWeatherDayResult>).data
    //         } catch (err) {
    //             // 数据库没有则从网络加载
    //             weatherData = await fetchAndCachedRealWeatherData(item.locationID, this.weatherKvStore!)
    //             forecastData = await fetchAndCachedForecast7DayWeather(item.locationID, this.weatherKvStore!)
    //         }
    //
    //         data.push({
    //             temp: parseInt(weatherData.now.temp),
    //             tempMax: parseInt(forecastData.daily[0].tempMax),
    //             tempMin: parseInt(forecastData.daily[0].tempMin),
    //             desc: weatherData.now.text,
    //             locationID: item.locationID
    //         })
    //     }
    //     return data
    // }

    async aboutToAppear(): Promise<void> {
        this.cityList = await DbUtil.queryCityList()
        // getWeatherKvStore(getContext(this))
        //     .then((store) => {
        //         this.weatherKvStore = store
        //         // 从本地获取 citiesInfo
        //         this.weatherKvStore!.get(KEY_CITIES_INFO)
        //             .then((res) => {
        //                 const citiesInfo = JSON.parse(res as string) as CityModel[]
        //                 this.cityList.push(...citiesInfo)
        //                 // 从路由传参中获取天气数据
        //                 this.loadWeatherData()
        //                     .then((weatherData) => {
        //                         console.log("loadWeatherData", JSON.stringify(weatherData))
        //                         weatherData.forEach(dataItem => {
        //                             this.cityList.forEach(infoItem => {
        //                                 if (dataItem.locationID === infoItem.locationID) {
        //                                     this.tureDataList.push(
        //                                         {
        //                                             city: infoItem,
        //                                             data: {
        //                                                 temp: dataItem.temp,
        //                                                 tempMax: dataItem.tempMax,
        //                                                 tempMin: dataItem.tempMin,
        //                                                 text: dataItem.desc
        //                                             }
        //                                         }
        //                                     )
        //                                 }
        //                             })
        //                         })
        //                         console.log("mapped trueDataList", JSON.stringify(this.tureDataList))
        //
        //                     })
        //             })
        //             .catch((err: BusinessError) => {
        //                 console.error('SearchPage weatherKvStore failed', err)
        //             })
        //     })
    }

    build() {
        Column() {
            Row() {
                Image($r('app.media.back'))
                    .width(30)
                    .height(30)
                    .borderRadius(10)
                    .margin({ left: 16 })
                Text('城市选择(此页面使用数据库RDB)')
                    .fontSize(18)
                    .fontWeight(FontWeight.Medium)
                    .margin({left:16})
            }
            .margin({top:50})
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
            .onClick(() => {
                router.back()
            })
            Column() {
                // 搜索框
                SearchLink({  cityList: this.cityList })
            }
            .width('100%')
            .height('100%')
            .attributeModifier(t)
        }

    }
}


