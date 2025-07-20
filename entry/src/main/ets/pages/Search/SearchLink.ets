import { CityMangerModel2, CityWeatherVO } from '../../model/CityManagerModel2'
import { CityModel } from '../../model/CityModel'
import { fetchCityInfoByKeyWord } from '../../network/api'
import { Location, LocationResult } from '../../network/type'
import { SearchResult } from './SearchResult'
import { CityManager } from './CityManager'

/*
 * 搜索
 * */
@Component
export struct SearchLink {
    result?: LocationResult
    @State locations: Location[] = []
    @State
    isShowSearchList: boolean = false
    // @Link
    // dataList: CityMangerModel2[]
    // @Link
    // tureDataList: CityWeatherVO[]
    @Link cityList: CityModel[]
    private searchDebounceId = -1

    /**
     * 搜索结果变化触发api搜索
     * */
    private searchValueChange(value: string) {
        if (value) {
            if (this.searchDebounceId != -1) {
                clearTimeout(this.searchDebounceId)
            }
            this.searchDebounceId = setTimeout(() => {
                fetchCityInfoByKeyWord(value).then(value1 => {
                    this.result = value1
                    this.locations = value1.location
                    this.isShowSearchList = true
                })
            }, 300)

        } else {
            clearTimeout(this.searchDebounceId)
            this.searchDebounceId = -1
            this.isShowSearchList = false
        }
    }

    build() {
        Column() {
            //搜索框
            Row() {
                Search({ placeholder: '搜索位置' })
                    .width('100%')
                    .onChange(value => {
                        this.searchValueChange(value)
                    })
            }

            //搜索结果列表
            Stack() {
                CityManager({ cityList: this.cityList  })
                if (this.isShowSearchList) {
                    SearchResult({
                        locations: this.locations,
                        cityList: this.cityList
                    })
                }
            }
        }
        .height('100%')
        .padding({ left: 20, right: 20})
        .alignItems(HorizontalAlign.Center)

    }
}
