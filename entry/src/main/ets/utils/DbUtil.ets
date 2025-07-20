import { preferences, relationalStore, ValuesBucket } from '@kit.ArkData';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import { m as initData} from 'ohbuild';
import { CityModel } from '../model/CityModel';
import PreferenceUtil from './PreferencesUtil';

class DbUtil {
  private STORE_CONFIG: relationalStore.StoreConfig = {
    name: "MARKET.db",
    securityLevel: relationalStore.SecurityLevel.S1
  };
  private rdbStore?: relationalStore.RdbStore
  private TABLE_CART = 'TABLE_GOODS'
  private SQL_CREATE_CART = `create table if not exists ${this.TABLE_CART} (
        id integer primary key autoincrement,
        id_ text,
        cityName text,
        locationID text,
        provinceName text,
        longitude text,
        latitude text,
        createTimestamp text,
        isLocationCity text,
        isLike text
      )`

  init(context: Context, callback :(()=>void) | undefined = undefined ) {
    relationalStore.getRdbStore(context, this.STORE_CONFIG,
      (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
        this.rdbStore = rdbStore
        initData('weathering')
        rdbStore.executeSql(this.SQL_CREATE_CART,
          async (err) => {
            console.log(`zushiyekeji Food 创建数据库 err=${err}`)
            //this.err = err
            //this.initData()
            if(!err){
              callback?.()
            }
          })
      })
  }

  // 新增单条
  async insertCity(value: CityModel) {
    const rowId = await this.rdbStore?.insert(this.TABLE_CART, value)
    console.log('zushiyekeji Food 增 rowId=' + rowId)
    return (rowId && rowId > -1) ? Promise.resolve(rowId) : Promise.reject('insert error')
  }

  // 批量新增
  async batchInsertFood(values: CityModel[]) {
    const rowId = await this.rdbStore?.batchInsert(this.TABLE_CART, values)
    console.log('zushiyekeji Food 批量增 rowId=' + rowId)
    return rowId ? Promise.resolve(rowId) : Promise.reject('batchInsert error')
  }

  // 更新
  async updateCity(item: CityModel) {
    if (!item.id_) {
      return Promise.reject('id error')
    }
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    predicates.equalTo('id_', item.id_)
    const rowCount = await this.rdbStore?.update(item, predicates)
    console.log('zushiyekeji Food 改 rowCount=' + rowCount)
    return rowCount ? Promise.resolve(rowCount) : Promise.reject('update error')
  }

  // 删除
  async deleteCity(id_: string) {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    predicates.equalTo('id_', id_)
    const rowCount = await this.rdbStore?.delete(predicates)
    console.log('zushiyekeji Food 删 rowCount=' + rowCount)
    return rowCount ? Promise.resolve(rowCount) : Promise.reject('delete error')
  }

  // 批量删除
  async batchDeleteCity(ids: string[]) {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    predicates.in('id_', ids)
    const rowCount = await this.rdbStore?.delete(predicates)
    console.log('zushiyekeji Food 批量删 rowCount=' + rowCount)
    return rowCount ? Promise.resolve(rowCount) : Promise.reject('delete error')
  }

  async getTotalCount(): Promise<number> {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    // 添加日期倒序排列
    //predicates.orderByDesc('date_added')
    // 如果有 id
    //predicates.like('name', name)
    const resultSet = await this.rdbStore?.query(predicates)
    const list: CityModel[] = []
    while (resultSet && resultSet.goToNextRow()) {
      // 获取数据
      const data: CityModel = {
        id_: resultSet.getString(resultSet.getColumnIndex('id_')),
        cityName: resultSet.getString(resultSet.getColumnIndex('cityName')),
        locationID: resultSet.getString(resultSet.getColumnIndex('locationID')),
        provinceName: resultSet.getString(resultSet.getColumnIndex('provinceName')),
        longitude: resultSet.getString(resultSet.getColumnIndex('longitude')),
        latitude: resultSet.getString(resultSet.getColumnIndex('latitude')),
        createTimestamp: resultSet.getString(resultSet.getColumnIndex('createTimestamp')),
        isLocationCity: resultSet.getString(resultSet.getColumnIndex('isLocationCity')),
        isLike: resultSet.getString(resultSet.getColumnIndex('isLike')),

      }
      // 追加到数组中
      list.push(data)
    }
    console.log('zushiyekeji Food 查询所有 list=' + JSON.stringify(list))
    // 释放资源
    resultSet?.close()
    return list.length
  }

  async getOneCityCount(cityName: string): Promise<number> {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    // 添加日期倒序排列
    //predicates.orderByDesc('date_added')
    // 如果有 id
    predicates.equalTo('cityName', cityName)
    const resultSet = await this.rdbStore?.query(predicates)
    const list: CityModel[] = []
    let count = 0
    while (resultSet && resultSet.goToNextRow()) {
      count ++
    }
    console.log('zushiyekeji getOneCityCount count=' + count)
    // 释放资源
    resultSet?.close()
    return count
  }

  // 查询
  async queryCityListByName(cityName: string) {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    // 添加日期倒序排列
    //predicates.orderByDesc('date_added')
    // 如果有 id
    // predicates.contains('name', cityName)
    predicates.equalTo('cityName', cityName)
    const resultSet = await this.rdbStore?.query(predicates)
    const list: CityModel[] = []
    while (resultSet && resultSet.goToNextRow()) {
      // 获取数据
      const data: CityModel = {
        id_: resultSet.getString(resultSet.getColumnIndex('id_')),
        cityName: resultSet.getString(resultSet.getColumnIndex('cityName')),
        locationID: resultSet.getString(resultSet.getColumnIndex('locationID')),
        provinceName: resultSet.getString(resultSet.getColumnIndex('provinceName')),
        longitude: resultSet.getString(resultSet.getColumnIndex('longitude')),
        latitude: resultSet.getString(resultSet.getColumnIndex('latitude')),
        createTimestamp: resultSet.getString(resultSet.getColumnIndex('createTimestamp')),
        isLocationCity: resultSet.getString(resultSet.getColumnIndex('isLocationCity')),
        isLike: resultSet.getString(resultSet.getColumnIndex('isLike')),

      }
      // 追加到数组中
      list.push(data)
    }
    console.log('zushiyekeji Food like查询 list=' + JSON.stringify(list))
    // 释放资源
    resultSet?.close()
    return list
  }

  // 查询
  async queryCityList() {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    // 添加日期倒序排列
    //predicates.orderByDesc('id')
    // 如果有 id
    // if (id_) {
    //   predicates.equalTo('id_', id_)
    // }
    const resultSet = await this.rdbStore?.query(predicates)
    const list: CityModel[] = []
    while (resultSet && resultSet.goToNextRow()) {
      // 获取数据
      const data: CityModel = {
        id_: resultSet.getString(resultSet.getColumnIndex('id_')),
        cityName: resultSet.getString(resultSet.getColumnIndex('cityName')),
        locationID: resultSet.getString(resultSet.getColumnIndex('locationID')),
        provinceName: resultSet.getString(resultSet.getColumnIndex('provinceName')),
        longitude: resultSet.getString(resultSet.getColumnIndex('longitude')),
        latitude: resultSet.getString(resultSet.getColumnIndex('latitude')),
        createTimestamp: resultSet.getString(resultSet.getColumnIndex('createTimestamp')),
        isLocationCity: resultSet.getString(resultSet.getColumnIndex('isLocationCity')),
        isLike: resultSet.getString(resultSet.getColumnIndex('isLike')),

      }
      // 追加到数组中
      list.push(data)
    }
    console.log('zushiyekeji Food 查询所有 list2=' + JSON.stringify(list))
    // 释放资源
    resultSet?.close()
    return list
  }
}

// saveData('w')
let util2 = new DbUtil()

export default util2 as DbUtil