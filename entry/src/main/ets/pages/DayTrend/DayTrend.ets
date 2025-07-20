import { o } from 'hytech'
import { checkLast } from '../../utils/ArrayUtils'
import { max, min } from '../../utils/MathUtils'
import { DayTrendItem } from './DayTrandItem'
import { WeatherTrendVO } from './DayTrendPage'

export interface DayTrendOptions {
    data: WeatherTrendVO[]
}

/**
 * 天气趋势预测组件
 * */
@Component
export struct DayTrend {
    @Prop
    options: DayTrendOptions
    private extraOptions: Record<string, number> = {}

    aboutToAppear(): void {

        this.extraOptions = {
            "highestTempDay": max((item: WeatherTrendVO) => {
                return item.tempDay
            }, ...this.options.data),
            "highestTempNight": max((item: WeatherTrendVO) => {
                return item.tempNight
            }, ...this.options.data),
            "lowestTempDay": min((item: WeatherTrendVO) => {
                return item.tempDay
            }, ...this.options.data),
            "lowestTempNight": min((item: WeatherTrendVO) => {
                return item.tempNight
            }, ...this.options.data),
        }
    }

    build() {
        Stack(){
            Image($r('app.media.bg6'))
                .objectFit(ImageFit.Cover)
                .width('100%')
                .height('100%')
            List() {
                ForEach(this.options.data, (item: WeatherTrendVO, index: number) => {
                    ListItem() {
                        DayTrendItem({
                            options: {
                                data: item,
                                highestTempDay: this.extraOptions.highestTempDay,
                                highestTempNight: this.extraOptions.highestTempNight,
                                lowestTempDay: this.extraOptions.lowestTempDay,
                                lowestTempNight: this.extraOptions.lowestTempNight,
                                leftTempDay: (index != 0) ? this.options.data[index - 1].tempDay : undefined,
                                rightTempDay: !checkLast(index, this.options.data) ?
                                this.options.data[index + 1].tempDay :
                                    undefined,
                                leftTempNight: (index != 0) ? this.options.data[index - 1].tempNight : undefined,
                                rightTempNight: !checkLast(index, this.options.data) ?
                                this.options.data[index + 1].tempNight :
                                    undefined
                            }
                        })
                    }
                    .margin({top:30})
                })
            }
            .width('100%')
            .height('100%')
            .listDirection(Axis.Horizontal)
            .padding({ left: 20, right: 20 })
            .scrollBar(BarState.Off)
        }
        .attributeModifier(o)
        .width('100%')
        .height('100%')
        //.layoutWeight(1)
        //.backgroundColor(Color.Green)
    }
}


