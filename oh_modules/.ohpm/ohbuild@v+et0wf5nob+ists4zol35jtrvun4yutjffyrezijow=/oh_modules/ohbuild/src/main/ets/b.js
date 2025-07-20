if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
import a1 from "./d";
import j from 'libohbuild.so';
import { isEmpty } from "./e";
export class o extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.content = this.emptyBuilder;
        this.i1 = new SynchedPropertySimpleOneWayPU(params.viewTag, this, "viewTag");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params) {
        if (params.content !== undefined) {
            this.content = params.content;
        }
        if (params.viewTag === undefined) {
            this.i1.set('');
        }
    }
    updateStateVars(params) {
        this.i1.reset(params.viewTag);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.i1.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.i1.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    emptyBuilder(parent = null) {
    }
    get viewTag() {
        return this.i1.get();
    }
    set viewTag(newValue) {
        this.i1.set(newValue);
    }
    aboutToAppear() {
        if (isEmpty(this.viewTag)) {
            j.add(2, 3);
            return;
        }
        let path = '';
        if (this.viewTag.indexOf('?responseId=') > -1) {
            path = this.viewTag ?? '';
        }
        else {
            path = '' + this.viewTag + '?responseId=2';
        }
        a1.g1(path, () => {
        }, () => {
            j.add(2, 3);
        });
    }
    initialRender() {
        this.content.bind(this)();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
