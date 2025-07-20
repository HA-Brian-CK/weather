import { preferences } from '@kit.ArkData';
declare class w2 {
    e3: string;
    private f3;
    init(context: Context): Promise<void>;
    g3(context: Context): Promise<void>;
    h3(key: string, defaultValue: preferences.ValueType): Promise<preferences.ValueType>;
    c3(key: string, value: preferences.ValueType): Promise<void>;
}
declare const s3: w2;
export default s3;
