import { openPermissionsInSystemSettings, requirePermission } from '../common/permission'
import { getWeatherKvStore } from './WeatherKvStore'
import { geoLocationManager } from '@kit.LocationKit'
import { requestLocation } from '../common/location';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { fetchCityByLatitudeAndLongitude } from '../network/api';
import { Location, LocationResult } from '../network/type';
import { distributedKVStore } from '@kit.ArkData';
import { CityModel } from '../model/CityModel';
import { KEY_CITIES_INFO } from '../common/constants';
import DbUtil from './DbUtil';

class LocationUtil {
  /**
   * 检查当前定位是否与先前数据匹配
   *
   * 流程：
   * 1. 检查当前定位信息
   * 2. 比较当前定位信息和已有的定位信息比较是否变化
   *      - 如果变化则更新到键值对数据库中
   *      - 如果没有变化则无事发生
   * */
  checkLocation(context: common.UIAbilityContext) {
    // 检查定位权限是否申请
    requirePermission(
      ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION"],
      context,
      () => {
        console.log('zhu requireLocationPermission success, do actions!')
        this.requestLocationAndCheck(context)
      },
      () => {
        console.error('zhu requireLocationPermission failed, nothing to do!')
        promptAction.showToast({
          message: '未授予定位权限，无法获取当前天气信息！',
          showMode: promptAction.ToastShowMode.TOP_MOST
        })
        openPermissionsInSystemSettings(context, 'com.zushiye.weather')
      })
  }

  /**
   * 请求定位数据，并按照比较情况存储到数据库中
   * */
  async requestLocationAndCheck(context: common.UIAbilityContext) {
    let locationInfo: Optional<geoLocationManager.Location> = undefined
    // 获取当前定位信息
    try {
      locationInfo = await requestLocation()
      console.log('zhu requestLocation success', JSON.stringify(locationInfo))
    } catch (err) {
      // 无法获取定位信息，直接返回
      console.error('zhu requestLocation failed', err.message)
      promptAction.showToast({
        message: '定位信息获取失败！'
      })
      return
    }

    // 获取该定位信息对应的城市信息
    let fetchLocationInfo: Optional<Location> = undefined
    try {
      let res: LocationResult = (await fetchCityByLatitudeAndLongitude(
        locationInfo!.longitude,
        locationInfo!.latitude
      ))
      fetchLocationInfo = res.location[0]
      console.log('zhu fetch API Location Info success!', JSON.stringify(fetchLocationInfo))
    } catch (err) {
      console.error('zhu fetchCityByLatitudeAndLongitude failed', err.message)
      promptAction.showToast({
        message: '获取定位城市信息失败！'
      })
      return
    }

    let city: CityModel = this.createCityModel(fetchLocationInfo, '1')

    let c = await DbUtil.getOneCityCount(city.cityName)
    if (c <= 0) {
      await DbUtil.insertCity(city)
    }
  }

  createCityModel(fetchLocationInfo: Location, isLocal: string | undefined = '0'): CityModel {
    if (!isLocal) {
      isLocal = '0'
    }
    return {
      id_: '' + Date.now(),
      cityName: fetchLocationInfo.name,
      provinceName: fetchLocationInfo.adm1,
      createTimestamp: '' + Date.now(),
      locationID: fetchLocationInfo.id,
      isLocationCity: isLocal,
      latitude: '' + parseFloat(fetchLocationInfo.lat),
      longitude: '' + parseFloat(fetchLocationInfo.lon),
      isLike: '0'
    }
  }
}

let a = new LocationUtil()

export default a as LocationUtil