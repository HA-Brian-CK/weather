import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { t as UIEntryAbility } from 'ohbuild';
import { window } from '@kit.ArkUI';
import { i } from 'hytech';
import distributedKVStore from '@ohos.data.distributedKVStore';
import { JSON } from '@kit.ArkTS';
import { Path_Splash } from '../pages/SplashPage';
import { Path_Main } from '../pages/MainPage';
import { BusinessError } from '@kit.BasicServicesKit';
import PreferenceUtil from '../utils/PreferencesUtil';
import DbUtil from '../utils/DbUtil';
import LocationUtil from '../utils/LocationUtil';
import { Path_Login } from '../pages/LoginPage';

export default class EntryAbility extends UIEntryAbility {
  // private weatherStore: Optional<distributedKVStore.DeviceKVStore>

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    i(this.context, '#cacfahae')
    //沉浸式  // 获取应用主窗口
    let windowClass: window.Window = this.getWindow(windowStage, 'weathering');
    // 1. 设置窗口全屏
    let isLayoutFullScreen = true;
    windowClass.setWindowLayoutFullScreen(isLayoutFullScreen)
      .then(() => {
        console.info('Succeeded in setting the window layout to full-screen mode.');
      })
      .catch((err: BusinessError) => {
        console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
      });

    windowStage.loadContent(Path_Splash, (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s',
          JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });

    //checkLocation(this.context)

    await PreferenceUtil.init(this.context)
    await DbUtil.init(this.context, () => {
      LocationUtil.checkLocation(this.context)
    })
  }


  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
