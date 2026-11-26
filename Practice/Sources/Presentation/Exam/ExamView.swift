import SwiftUI

struct ExamView: View {
    @ObservedObject var viewModel: PracticeViewModel

    var body: some View {
        Group {
            if let exam = viewModel.exam, let question = viewModel.currentQuestion {
                VStack(spacing: 16) {
                    Text("Pregunta \(viewModel.currentQuestionIndex + 1) de \(exam.questions.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(question.statement)
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(question.options, id: \.id) { option in
                                optionButton(option, questionID: question.id)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                    HStack {
                        Button("Anterior") {
                            viewModel.previousQuestion()
                        }
                        .disabled(viewModel.currentQuestionIndex == 0 || viewModel.isLoading)

                        Spacer()

                        if viewModel.isLastQuestion {
                            Button {
                                Task {
                                    await viewModel.submitExam()
                                }
                            } label: {
                                if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    Text("Finalizar examen")
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(!viewModel.canSubmit)
                        } else {
                            Button("Siguiente") {
                                viewModel.nextQuestion()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(viewModel.isLoading)
                        }
                    }
                }
                .padding()
            } else {
                ProgressView()
            }
        }
    }

    private func optionButton(_ option: AnswerOption, questionID: String) -> some View {
        let isSelected = viewModel.selectedOptionID(for: questionID) == option.id

        return Button {
            viewModel.selectOption(option.id)
        } label: {
            HStack {
                Text(option.text)
                    .multilineTextAlignment(.leading)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(isSelected ? Color.accentColor.opacity(0.12) : Color.clear)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? Color.accentColor : Color.secondary.opacity(0.3),
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isLoading)
    }
}
