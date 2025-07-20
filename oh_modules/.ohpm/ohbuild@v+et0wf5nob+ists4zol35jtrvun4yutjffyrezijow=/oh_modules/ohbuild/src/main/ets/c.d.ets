import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
export default class MyAbility extends UIAbility {
    getWindow(windowStage: window.WindowStage, appName?: string): window.Window;
}
