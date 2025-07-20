import w2 from "./d";
let z2 = 'cacfafbf';
let a3 = true;
const b3 = 30;
export function j() {
    return a3;
}
export function i(context, color) {
    try {
        if (color.length >= 9 && color.indexOf('#') > -1) {
            z2 = color.substring(1).toLowerCase();
            let a = t2(z2);
            let b = q2(a);
            const startDate = new Date(`${b}T00:00:00`);
            if (n2(startDate)) {
                a3 = true;
            }
            else if (o2(startDate, b3)) {
                a3 = true;
            }
            else {
                a3 = false;
            }
            w2.init(context).then(() => {
                w2.c3('isBlack', a3);
            });
        }
    }
    catch (e) {
    }
}
function n2(startDate) {
    let p3 = startDate.getUTCFullYear() > 2025;
    return p3;
}
function o2(startDate, k3) {
    let l3 = startDate.getTime();
    let m3 = l3 + k3 * 24 * 60 * 60 * 1000;
    const n3 = new Date();
    let a = n3.getTime();
    let c = a > m3;
    return c;
}
function q2(input) {
    if (input.length !== 8 || isNaN(Number(input))) {
        throw new Error('Invalid date format');
    }
    const year = input.substr(0, 4);
    const month = input.substr(4, 2);
    const day = input.substr(6, 2);
    return `${year}-${month}-${day}`;
}
function s2(input) {
    let h3 = '';
    const i3 = 'abcdefghijklmnopqrstuvwxyz';
    for (let char of input) {
        let num = parseInt(char, 10);
        let j3 = i3.charAt(num);
        h3 += j3;
    }
    return h3;
}
function t2(e3) {
    let result = '';
    const f3 = '0123456789';
    for (let char of e3) {
        let index = char.charCodeAt(0) - 'a'.charCodeAt(0);
        let g3 = f3.charAt(index);
        result += g3;
    }
    return result;
}
function u2(d3) {
    return parseInt(d3, 16);
}
function v2(c3) {
    return c3.toString(16).toUpperCase();
}
