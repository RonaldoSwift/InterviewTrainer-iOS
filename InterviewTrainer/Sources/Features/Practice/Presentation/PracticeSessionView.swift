
import SwiftUI

public struct PracticeSessionView: View {

    @State private var viewModel: PracticeSessionViewModel
    private let onFinish: () -> Void

    public init(exam: Exam, onFinish: @escaping () -> Void = {}) {
        _viewModel = State(
            initialValue: PracticeSessionViewModel(exam: exam)
        )
        self.onFinish = onFinish
    }

    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.state == .empty {
                    emptyView
                } else if viewModel.state == .error,
                          let errorMessage = viewModel.errorMessage {
                    sessionErrorView(errorMessage)
                } else if viewModel.isFinished {
                    resultView
                } else {
                    questionView
                }
            }
            .navigationTitle("Práctica")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.035, green: 0.055, blue: 0.12))
        }
    }

    private var questionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Pregunta \(viewModel.questionNumber) de \(viewModel.totalQuestions)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                            Spacer()
                            Text("\(Int((Double(viewModel.questionNumber) / Double(viewModel.totalQuestions)) * 100))%")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.cyan)
                        }

                        ProgressView(
                            value: Double(viewModel.questionNumber),
                            total: Double(viewModel.totalQuestions)
                        )
                        .tint(.cyan)
                        .accessibilityLabel(
                            "Progreso: pregunta \(viewModel.questionNumber) de \(viewModel.totalQuestions)"
                        )
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    Text(viewModel.currentQuestion.statement)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.top, 4)
                        .accessibilityAddTraits(.isHeader)

                    VStack(spacing: 12) {
                        ForEach(viewModel.currentQuestion.options, id: \.optionId) { option in
                            Button {
                                viewModel.selectOption(option.optionId)
                            } label: {
                                HStack {
                                    Text(option.optionId)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .frame(width: 30, height: 30)
                                        .background(optionLetterBackground(for: option.optionId))
                                        .clipShape(Circle())

                                    Text(option.text)
                                        .foregroundStyle(.white)

                                    Spacer()

                                    if viewModel.isShowingFeedback {
                                        if option.optionId == viewModel.currentFeedback?.correctOptionId {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.green)
                                        } else if option.optionId == viewModel.selectedOptionId {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.red)
                                        }
                                    } else if option.optionId == viewModel.selectedOptionId {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.cyan)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(optionBackground(for: option.optionId))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(optionBorder(for: option.optionId), lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.isShowingFeedback)
                            .frame(minHeight: 56)
                            .contentShape(Rectangle())
                            .accessibilityLabel(alternativeAccessibilityLabel(for: option.optionId, text: option.text))
                        }
                    }

                    if viewModel.isShowingFeedback,
                       let feedback = viewModel.currentFeedback {

                        VStack(alignment: .leading, spacing: 8) {
                            Text(
                                viewModel.selectedOptionId == feedback.correctOptionId
                                ? "¡Respuesta correcta!"
                                : "Respuesta incorrecta"
                            )
                            .font(.headline)
                            .foregroundStyle(
                                viewModel.selectedOptionId == feedback.correctOptionId
                                ? .green
                                : .red
                            )

                            Text(feedback.explanation)
                                .font(.body)
                                .foregroundStyle(.white.opacity(0.82))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.07))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .accessibilityElement(children: .combine)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }

            VStack(spacing: 0) {
                Divider()
                    .overlay(.white.opacity(0.08))

                if viewModel.isShowingFeedback {
                    Button(
                        viewModel.questionNumber == viewModel.totalQuestions
                        ? "Ver resultados"
                        : "Siguiente pregunta"
                    ) {
                        viewModel.nextQuestion()
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [.purple, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(minHeight: 56)
                    .contentShape(Rectangle())
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                    .accessibilityHint("Muestra la siguiente pregunta")
                } else {
                    Button("Responder") {
                        viewModel.submitAnswer()
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        viewModel.canSubmitAnswer
                        ? LinearGradient(
                            colors: [.purple, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        : LinearGradient(
                            colors: [.white.opacity(0.10), .white.opacity(0.10)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .disabled(!viewModel.canSubmitAnswer)
                    .frame(minHeight: 56)
                    .contentShape(Rectangle())
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                    .accessibilityHint(
                        viewModel.canSubmitAnswer
                        ? "Valida la alternativa seleccionada"
                        : "Selecciona una alternativa antes de responder"
                    )
                }
            }
            .background(Color(red: 0.035, green: 0.055, blue: 0.12))
        }
    }

    private var resultView: some View {
        VStack(spacing: 18) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 64))
                .foregroundStyle(.yellow)
                .padding(.top, 28)
                .accessibilityLabel("Práctica completada")

            Text("¡Práctica completada!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text("\(scorePercentage)%")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.cyan)

            Text("\(viewModel.correctAnswers) de \(viewModel.totalQuestions) respuestas correctas")
                .foregroundStyle(.white.opacity(0.72))

            HStack(spacing: 12) {
                resultCard(
                    count: viewModel.correctAnswers,
                    title: "Correctas",
                    color: .green,
                    icon: "checkmark.circle.fill"
                )

                resultCard(
                    count: viewModel.incorrectAnswers,
                    title: "Incorrectas",
                    color: .red,
                    icon: "xmark.circle.fill"
                )
            }

            Spacer()

            Button("Volver al inicio") {
                onFinish()
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [.purple, .cyan],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(minHeight: 56)
            .contentShape(Rectangle())
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "questionmark.circle")
                .font(.system(size: 52))
                .foregroundStyle(.cyan)
                .accessibilityHidden(true)

            Text("No hay preguntas disponibles")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text("Regresa y genera otra práctica.")
                .foregroundStyle(.white.opacity(0.72))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(24)
    }

    private func sessionErrorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 52))
                .foregroundStyle(.yellow)
                .accessibilityHidden(true)

            Text(message)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Button("Intentar esta pregunta nuevamente") {
                viewModel.retryFeedback()
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 56)
            .contentShape(Rectangle())
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
    }

    private func optionBackground(for optionId: String) -> Color {
        if viewModel.isShowingFeedback {
            if optionId == viewModel.currentFeedback?.correctOptionId {
                return .green.opacity(0.2)
            }

            if optionId == viewModel.selectedOptionId {
                return .red.opacity(0.2)
            }
        } else if optionId == viewModel.selectedOptionId {
            return .blue.opacity(0.2)
        }

        return .secondary.opacity(0.1)
    }

    private func optionLetterBackground(for optionId: String) -> Color {
        if viewModel.isShowingFeedback,
           optionId == viewModel.currentFeedback?.correctOptionId {
            return .green
        }

        if optionId == viewModel.selectedOptionId {
            return .purple
        }

        return .white.opacity(0.12)
    }

    private func optionBorder(for optionId: String) -> Color {
        if viewModel.isShowingFeedback,
           optionId == viewModel.currentFeedback?.correctOptionId {
            return .green
        }

        if optionId == viewModel.selectedOptionId {
            return .cyan
        }

        return .white.opacity(0.08)
    }

    private var scorePercentage: Int {
        guard viewModel.totalQuestions > 0 else { return 0 }
        return Int(
            (Double(viewModel.correctAnswers) / Double(viewModel.totalQuestions)) * 100
        )
    }

    private func resultCard(
        count: Int,
        title: String,
        color: Color,
        icon: String
    ) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(color)

            Text("\(count)")
                .font(.title.weight(.bold))
                .foregroundStyle(.white)

            Text(title)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.72))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white.opacity(0.06))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.45), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func alternativeAccessibilityLabel(
        for optionId: String,
        text: String
    ) -> String {
        var status = ""

        if viewModel.isShowingFeedback {
            if optionId == viewModel.currentFeedback?.correctOptionId {
                status = "Alternativa correcta"
            } else if optionId == viewModel.selectedOptionId {
                status = "Tu alternativa incorrecta"
            }
        } else if optionId == viewModel.selectedOptionId {
            status = "Alternativa seleccionada"
        }

        let prefix = status.isEmpty ? "Alternativa \(optionId)" : "Alternativa \(optionId), \(status)"
        return "\(prefix). \(text)"
    }
}
