@Component
export declare struct o {
    @Builder
    emptyBuilder(): void;
    @BuilderParam
    content: () => void;
    @Prop
    viewTag: string;
    aboutToAppear(): void;
    build(): void;
}
