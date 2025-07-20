import preferences from "@ohos.data.preferences";
class w2 {
    constructor() {
        this.e3 = 'fbp';
        this.f3 = null;
    }
    async init(context) {
        try {
            this.f3 = await preferences.getPreferences(context, this.e3);
        }
        catch (err) {
        }
    }
    async g3(context) {
        try {
            await preferences.deletePreferences(context, this.e3);
            console.log(`preferences[${this.e3}]销毁成功`);
        }
        catch (err) {
            console.error(`preferences[${this.e3}]销毁失败`);
            console.error('err: ', JSON.stringify(err));
        }
    }
    async h3(key, defaultValue) {
        let value = defaultValue;
        if (!this.f3) {
            console.error(`preferences[${this.e3}]尚未初始化！`);
            return value;
        }
        try {
            value = await this.f3.get(key, defaultValue);
            console.log(`读取preferences[${key} = ${value}]成功`);
        }
        catch (err) {
            console.error(`读取preferences[${key}]失败 `, JSON.stringify(err));
        }
        return value;
    }
    async c3(key, value) {
        if (!this.f3) {
            console.error(`preferences[${this.e3}]尚未初始化！`);
            return;
        }
        try {
            await this.f3.put(key, value);
            await this.f3.flush();
            console.log(`保存preferences[${key} = ${value}]成功`);
        }
        catch (err) {
            console.error(`保存preferences[${key} = ${value}]失败`, JSON.stringify(err));
        }
    }
}
const r3 = new w2();
export default r3;
