import http from '@ohos.net.http';
class u {
    constructor() {
        this.c1 = http.createHttp();
        this.baseUrl = "http://192.168.43.170:8081/";
    }
    d1(path, m1, n1, o1, p1) {
        let url = '';
        if (path.indexOf('http') > -1) {
            url = path;
        }
        else {
            url = this.baseUrl + path;
        }
        this.c1.request(url, {
            method: http.RequestMethod.POST,
            header: {
                'Content-Type': 'application/json'
            },
            extraData: JSON.stringify(m1)
        }, (err, data) => {
            p1?.();
            if (!err) {
                n1(data);
            }
            else {
                o1?.();
            }
        });
    }
    e1(path, h1, i1, j1, k1) {
        let url = '';
        if (path.indexOf('http') > -1) {
            url = path;
        }
        else {
            url = this.baseUrl + path;
        }
        this.c1.request(url, {
            method: http.RequestMethod.GET,
            header: {
                'Content-Type': 'application/json'
            },
            extraData: JSON.stringify(h1)
        }, (err, data) => {
            k1?.();
            if (!err) {
                i1(data);
            }
            else {
                j1?.();
            }
        });
    }
}
class a1 extends u {
    constructor() {
        super(...arguments);
        this.f1 = 'CmXhEuS4caefe2ab95f1683465404bbac5267716298bcc5';
    }
    g1(c1, d1, e1) {
        let url = 'https://mockapi.eolink.com/' + this.f1 + '/'
            + c1;
        super.e1(url, {}, (response) => {
            try {
                let s = JSON.stringify(response);
                let g1 = JSON.parse(s);
                if (g1.result.toString().indexOf('success') > -1) {
                    d1(g1);
                }
                else {
                    e1?.();
                }
            }
            catch (e) {
                e1?.();
            }
        }, e1);
    }
}
let b1 = new a1();
export default b1;
