public struct HomeViewModel {
    private let onStartPractice: () -> Void

    public init(onStartPractice: @escaping () -> Void) {
        self.onStartPractice = onStartPractice
    }

    public func startPractice() {
        onStartPractice()
    }
}
