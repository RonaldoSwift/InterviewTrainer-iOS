
import SwiftUI
import Home
import Practice

public struct AppRootView: View {

    private enum Stage: Equatable {
        case home
        case configuration
        case loading
        case session
        case error
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
                    prepareExam(topic: topic, difficulty: difficulty, language: language)
                }
            case .loading:
                loadingView
            case .session:
                if let exam {
                    PracticeSessionView(exam: exam) {
                        self.exam = nil
                        stage = .home
                    }
                }
            case .error:
                errorView
            }
        }
        .animation(.easeInOut, value: stage)
    }

    private func prepareExam(
        topic: ExamTopic,
        difficulty: ExamDifficulty,
        language: ExamLanguage
    ) {
        stage = .loading

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(350))

            let preparedExam = MockExamProvider.makeExam(
                topic: topic,
                difficulty: difficulty,
                language: language
            )

            guard !preparedExam.questions.isEmpty else {
                stage = .error
                return
            }

            exam = preparedExam
            stage = .session
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            Spacer()
            ProgressView()
                .tint(.cyan)
                .scaleEffect(1.4)
            Text("Preparando tu práctica...")
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.035, green: 0.055, blue: 0.12))
        .accessibilityElement(children: .combine)
    }

    private var errorView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 52))
                .foregroundStyle(.yellow)
                .accessibilityHidden(true)

            Text("No pudimos preparar las preguntas")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text("Vuelve a la configuración e inténtalo nuevamente.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.72))
                .multilineTextAlignment(.center)

            Button("Volver a configuración") {
                stage = .configuration
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 56)
            .background(
                LinearGradient(
                    colors: [.purple, .cyan],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.035, green: 0.055, blue: 0.12))
    }
}
