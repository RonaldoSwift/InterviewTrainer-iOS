import Observation

@Observable
@MainActor
public final class HomeViewModel {

    public var title = HomeLocalization.title

    public var subtitle = HomeLocalization.subtitle

    public var isShowingPractice = false

    public init() {}

    public func startPractice() {
        isShowingPractice = true
    }
}
