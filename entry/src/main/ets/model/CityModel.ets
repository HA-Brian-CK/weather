import { faceDetector } from "@kit.CoreVisionKit";
import { ValuesBucket } from "@kit.ArkData";

export interface CityModel extends ValuesBucket{

  id_: string,

  /** 城市名字 */
  cityName: string,

  /** id */
  locationID: string,

  /** 所属省份 */
  provinceName: string,

  /** 经度 */
  longitude: string,

  /** 纬度 */
  latitude: string,

  /** 定位城市 */
  isLocationCity: string,

  /**
   * 创建时间
   * */
  createTimestamp: string,

  /** 是否喜欢 */
  isLike: string,
}
//
// export class CityOne implements CityModel {
//   cityName: string = '';
//   locationID: string = '';
//   provinceName: string = '';
//   longitude: number = 0;
//   latitude: number = 0;
//   isLocationCity: boolean = false;
//   createTimestamp: number = 0;
// }


export interface RealWeatherData {
  /** 数据观测时间 */
  obsTime: string,

  /** 温度，默认单位摄氏度 */
  temp: string,

  /** 体感温度 */
  feelsLike: string,

  /** 图标代码 */
  icon: string,

  /** 天气描述 */
  text: string,

  /** 风向360角 */
  wind360: string,

  /** 风向 */
  windDir: string,

  /** 风力等级 */
  windScale: string,

  /** 风速 km/h */
  windSpeed: string,

  /** 湿度 % */
  humidity: string,

  /** 当前小时累计降水量，mm */
  precip: string,

  /** 大气压强，百帕 */
  pressure: string,

  /** 能见度， km */
  vis: string,

  /** 云量，百分比，可能为空 */
  cloud?: string,

  /** 露点温度，可能为空 */
  dew?: string,
}