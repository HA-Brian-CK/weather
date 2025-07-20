@Component
export declare struct m {
    @Builder
    emptyBuilder(): void;
    @BuilderParam
    content: () => void;
    aboutToAppear(): void;
    build(): void;
}
