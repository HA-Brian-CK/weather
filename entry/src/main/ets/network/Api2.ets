import { fetchForecast24HourWeather, fetchForecast7DayWeather, fetchNowAir, fetchRealWeather } from './api'

class Api2 {
  async fetchAndCachedRealWeatherData(locationID: string) {
    const data = await fetchRealWeather(locationID)
    return data
  }

  async fetchAndCachedNowAirData(locationID: string) {
    const data = await fetchNowAir(locationID)
    return data
  }

  async fetchAndCachedForecast7DayWeather(locationID: string) {
    const data = await fetchForecast7DayWeather(locationID)
    return data
  }

  async fetch24Data(locationID: string) {
    const data = await fetchForecast24HourWeather(locationID)
    return data
  }


}

let a = new Api2()

export default a as Api2