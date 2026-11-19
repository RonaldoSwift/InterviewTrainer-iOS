import Observation

@Observable
@MainActor
public final class HomeViewModel {

    public var title = HomeStrings.Home.title

    public var subtitle = HomeStrings.Home.subtitle

    public var isShowingPractice = false

    public init() {}

    public func startPractice() {
        isShowingPractice = true
    }
}
