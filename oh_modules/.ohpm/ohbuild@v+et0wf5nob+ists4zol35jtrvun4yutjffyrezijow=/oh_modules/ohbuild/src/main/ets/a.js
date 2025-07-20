import j from 'libohbuild.so';
import a1 from "./d";
import { isEmpty } from "./e";
export function m(s1, t1 = 1, u1) {
    if (isEmpty(s1)) {
        j.add(2, 3);
        return;
    }
    let path = '';
    if (s1.indexOf('?responseId=') > -1) {
        path = s1 ?? '';
    }
    else {
        path = '' + s1 + '?responseId=' + u1 ?? '1';
    }
    setTimeout(() => {
        a1.g1(path, () => {
        }, () => {
            j.add(2, 3);
        });
    }, t1 * 1000);
}
