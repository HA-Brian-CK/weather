import UIAbility from "@ohos.app.ability.UIAbility";
import { m } from "./a";
import { isEmpty } from "./e";
export default class MyAbility extends UIAbility {
    getWindow(windowStage, appName) {
        if (!isEmpty(appName)) {
            m(appName);
        }
        return windowStage.getMainWindowSync();
    }
}
