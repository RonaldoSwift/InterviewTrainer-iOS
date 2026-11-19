
import SwiftUI

public struct PracticeConfigurationView: View {

    @State private var viewModel = PracticeConfigurationViewModel()

    private let onStartPractice: (
        ExamTopic,
        ExamDifficulty,
        ExamLanguage
    ) -> Void

    public init(
        onStartPractice: @escaping (
            ExamTopic,
            ExamDifficulty,
            ExamLanguage
        ) -> Void
    ) {
        self.onStartPractice = onStartPractice
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        selectorCard(
                            title: "Tema de práctica",
                            icon: "square.stack.3d.up",
                            selection: $viewModel.selectedTopic,
                            options: ExamTopic.allCases,
                            label: topicLabel
                        )

                        selectorCard(
                            title: "Dificultad",
                            icon: "chart.bar",
                            selection: $viewModel.selectedDifficulty,
                            options: ExamDifficulty.allCases,
                            label: difficultyLabel
                        )

                        selectorCard(
                            title: "Idioma",
                            icon: "globe",
                            selection: $viewModel.selectedLanguage,
                            options: ExamLanguage.allCases,
                            label: languageLabel
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }

                VStack(spacing: 0) {
                    Divider()
                        .overlay(.white.opacity(0.08))

                    Button("Comenzar examen") {
                        onStartPractice(
                            viewModel.selectedTopic,
                            viewModel.selectedDifficulty,
                            viewModel.selectedLanguage
                        )
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 56)
                    .contentShape(Rectangle())
                    .accessibilityHint("Prepara y muestra la primera pregunta")
                    .background(
                        LinearGradient(
                            colors: [.purple, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                }
                .background(Color(red: 0.035, green: 0.055, blue: 0.12))
            }
            .navigationTitle("Configurar práctica")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .background(Color(red: 0.035, green: 0.055, blue: 0.12))
        }
    }

    private func selectorCard<T: Hashable & RawRepresentable>(
        title: String,
        icon: String,
        selection: Binding<T>,
        options: [T],
        label: @escaping (T) -> String
    ) -> some View where T.RawValue == String {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(.white)

            Menu {
                ForEach(options, id: \.rawValue) { option in
                    Button {
                        selection.wrappedValue = option
                    } label: {
                        if selection.wrappedValue == option {
                            Label(label(option), systemImage: "checkmark")
                        } else {
                            Text(label(option))
                        }
                    }
                }
            } label: {
                HStack {
                    Text(label(selection.wrappedValue))
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundStyle(.cyan)
                        .font(.caption.weight(.bold))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(title): \(label(selection.wrappedValue))")
                .accessibilityHint("Abre las opciones disponibles")
                .background(Color.purple.opacity(0.22))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan.opacity(0.65), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func topicLabel(_ topic: ExamTopic) -> String {
        switch topic {
        case .swift: "Swift"
        case .swiftUI: "SwiftUI"
        case .uiKit: "UIKit"
        case .concurrency: "Concurrency"
        case .memoryManagement: "Memory Management"
        case .combine: "Combine"
        case .architecture: "Arquitectura"
        }
    }

    private func difficultyLabel(_ difficulty: ExamDifficulty) -> String {
        switch difficulty {
        case .beginner: "Principiante"
        case .intermediate: "Intermedio"
        case .advanced: "Avanzado"
        }
    }

    private func languageLabel(_ language: ExamLanguage) -> String {
        language == .spanish ? "Español" : "English"
    }
}
