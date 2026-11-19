
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
        ZStack {
            Color(red: 0.035, green: 0.055, blue: 0.12)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                practiceHeader(PracticeLocalization.configurationTitle)

                VStack(spacing: 12) {
                    selectorCard(
                        title: PracticeLocalization.topic,
                        icon: "square.stack.3d.up",
                        selection: $viewModel.selectedTopic,
                        options: ExamTopic.allCases,
                        label: PracticeLocalization.topicLabel
                    )

                    selectorCard(
                        title: PracticeLocalization.difficulty,
                        icon: "chart.bar",
                        selection: $viewModel.selectedDifficulty,
                        options: ExamDifficulty.allCases,
                        label: PracticeLocalization.difficultyLabel
                    )

                    selectorCard(
                        title: PracticeLocalization.language,
                        icon: "globe",
                        selection: $viewModel.selectedLanguage,
                        options: ExamLanguage.allCases,
                        label: PracticeLocalization.languageLabel
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
            .safeAreaPadding(.top)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack(spacing: 0) {
                    Divider()
                        .overlay(.white.opacity(0.08))

                    Button {
                        onStartPractice(
                            viewModel.selectedTopic,
                            viewModel.selectedDifficulty,
                            viewModel.selectedLanguage
                        )
                    } label: {
                        Text(PracticeLocalization.startExam)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .contentShape(Rectangle())
                            .background(
                                LinearGradient(
                                    colors: [.purple, .cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint(PracticeLocalization.startExamHint)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                }
                .background(Color(red: 0.035, green: 0.055, blue: 0.12))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func practiceHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.top, 8)
    }

    private func selectorCard<T: Hashable & RawRepresentable>(
        title: String,
        icon: String,
        selection: Binding<T>,
        options: [T],
        label: @escaping (T) -> String
    ) -> some View where T.RawValue == String {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
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
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 40)
                .contentShape(Rectangle())
                .accessibilityElement(children: .combine)
                .accessibilityLabel(
                    PracticeLocalization.formatted(
                        "practice.selector_accessibility",
                        title,
                        label(selection.wrappedValue)
                    )
                )
                .accessibilityHint(PracticeLocalization.selectorHint)
                .background(Color.purple.opacity(0.22))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan.opacity(0.65), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

}
