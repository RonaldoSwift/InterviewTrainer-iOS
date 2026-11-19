
import SwiftUI
import Home
import Practice

public struct AppRootView: View {

    private enum Stage: Equatable {
        case home
        case configuration
        case session
    }

    @State private var stage: Stage = .home
    @State private var exam: Exam?

    public init() {}

    public var body: some View {
        Group {
            switch stage {
            case .home:
                HomeView {
                    stage = .configuration
                }
            case .configuration:
                PracticeConfigurationView { topic, difficulty, language in
                    exam = MockExamProvider.makeExam(
                        topic: topic,
                        difficulty: difficulty,
                        language: language
                    )
                    stage = .session
                }
            case .session:
                if let exam {
                    PracticeSessionView(exam: exam) {
                        self.exam = nil
                        stage = .home
                    }
                }
            }
        }
        .animation(.easeInOut, value: stage)
    }
}
