import emitter from '@ohos.events.emitter'
export class EventData{
    msg  = ''
}
class EventUtil {
  EVENT_ON_CITY_SELECT = 0
  EVENT_ON_CITY_DELETE = 1
  EVENT_ON_CITY_ADD = 2
  send(eventId: number, data1: EventData | undefined = undefined) {
    console.log('zushiye->emitter发送数据--')
    if (data1) {
      console.log('zushiye->emitter发送数据：' + JSON.stringify(data1))
    }
    emitter.emit({ eventId: eventId }, {
      data: data1
      // data: {
      //   img_id: item.img_id, //播放歌曲的图片
      //   name: item.name, // 歌曲名称
      //   author: item.author //歌手
      // }
    })
  }

  register(eventId: number, callback: (res: EventData | undefined) => void) {
    emitter.on({ eventId: eventId }, (eventData) => {
      console.log('zushiye->emitter接收数据--')
      if (eventData) {
        console.log('zushiye->emitter接收数据：' + JSON.stringify(eventData))
      }
      // 将其他页面发送过来的数据赋值给当前的curSong这个状态变量
      // {"data":{"author":"光泽","img":"http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/4.jpg","name":"空心"}}
      //this.curSong = eventData.data as SongBean
      // this.isplaying = AVPlayerManager.isplaying
      let d = eventData.data as EventData

      callback(d)
    })
    //// 注册emitter 的on事件，用来监听 emitter.emit发送过来的数据

  }
  off(eventId: number){
    emitter.off(eventId)
  }
}

let eventUtil = new EventUtil()

export default eventUtil as EventUtil