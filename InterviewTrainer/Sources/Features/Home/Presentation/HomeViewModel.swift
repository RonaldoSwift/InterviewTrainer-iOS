import Observation

@Observable
@MainActor
public final class HomeViewModel {

    public var title = "InterviewTrainer AI"

    public var subtitle = "Prepárate para tu próxima entrevista técnica de iOS."

    public var isShowingPractice = false

    public init() {}

    public func startPractice() {
        isShowingPractice = true
    }
}
