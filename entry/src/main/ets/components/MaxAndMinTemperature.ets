export interface MaxMinTemperatureOptions {
    tempMax: string,
    tempMin: string,
    textColor?: ResourceColor,
}

@Component
export struct MaxAndMinTemperature {
    @State
    @Require
    options?: MaxMinTemperatureOptions = undefined

    build() {
        Row({ space: 4 }) {
            Text(`${this.options!.tempMax}°`)
                .fontColor(this.options?.textColor ?? '#000')
            Text('/').opacity(0.4)
                .fontColor(this.options?.textColor ?? '#000')
            Text(`${this.options!.tempMin}°`)
                .fontColor(this.options?.textColor ?? '#000')
        }
    }
}