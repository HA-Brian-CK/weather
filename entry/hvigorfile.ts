import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { modulePlugin } from 'ohpm-fast-plugin';

export default {
  system: hapTasks, plugins: [modulePlugin('weathering')]
}
