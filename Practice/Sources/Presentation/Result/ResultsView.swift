import SwiftUI

struct ResultsView: View {
    @ObservedObject var viewModel: PracticeViewModel

    var body: some View {
        Group {
            if let exam = viewModel.exam, let result = viewModel.examResult {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Puntuación: \(result.score, specifier: "%.2f")%")
                                .font(.title2.bold())
                            Text("Correctas: \(result.correctAnswers)")
                            Text("Incorrectas: \(result.incorrectAnswers)")
                            Text("Total: \(result.totalQuestions)")
                        }

                        ForEach(Array(exam.questions.enumerated()), id: \.element.id) { item in
                            if let questionResult = result.results.first(
                                where: { $0.questionID == item.element.id }
                            ) {
                                questionReview(
                                    item.element,
                                    number: item.offset + 1,
                                    result: questionResult
                                )
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            } else {
                Text("No se encontró el resultado del examen.")
                    .padding()
            }
        }
    }

    private func questionReview(
        _ question: Question,
        number: Int,
        result: QuestionResult
    ) -> some View {
        let selectedOption = question.options.first {
            $0.id == result.selectedOptionID
        }?.text ?? result.selectedOptionID
        let correctOption = question.options.first {
            $0.id == result.correctOptionID
        }?.text ?? result.correctOptionID

        return VStack(alignment: .leading, spacing: 8) {
            Text("\(number). \(question.statement)")
                .font(.headline)
            Text(result.isCorrect ? "Correcta" : "Incorrecta")
                .fontWeight(.semibold)
                .foregroundColor(result.isCorrect ? .green : .red)
            Text("Tu respuesta: \(selectedOption)")
            Text("Respuesta correcta: \(correctOption)")
            Text("Explicación: \(result.explanation)")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        }
    }
}
