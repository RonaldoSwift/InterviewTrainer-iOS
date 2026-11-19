
import Observation

@Observable
@MainActor
public final class PracticeConfigurationViewModel {

    public var selectedTopic: ExamTopic = .swift

    public var selectedDifficulty: ExamDifficulty = .beginner

    public var selectedLanguage: ExamLanguage = .spanish

    public init() {}
}
