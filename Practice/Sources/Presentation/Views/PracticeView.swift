import SwiftUI

public struct PracticeView: View {
    @StateObject private var viewModel = PracticeViewModel()

    public init() {}

    public var body: some View {
        Group {
            switch viewModel.screen {
            case .configuration:
                configurationView
            case .exam:
                examView
            case .results:
                resultsView
            }
        }
        .navigationTitle(navigationTitle)
        .alert(
            "No se pudo completar la solicitud",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.clearError()
                    }
                }
            )
        ) {
            Button("Aceptar", role: .cancel) {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "Inténtalo nuevamente.")
        }
    }

    private var navigationTitle: String {
        switch viewModel.screen {
        case .configuration:
            return "Configurar práctica"
        case .exam:
            return "Práctica"
        case .results:
            return "Resultados"
        }
    }

    private var configurationView: some View {
        Form {
            Section("Configuración del examen") {
                TextField("Tema", text: $viewModel.topic)

                Picker("Dificultad", selection: $viewModel.difficulty) {
                    Text("Principiante").tag("beginner")
                    Text("Intermedio").tag("intermediate")
                    Text("Avanzado").tag("advanced")
                }

                Picker("Idioma", selection: $viewModel.languageCode) {
                    Text("Español").tag("es")
                    Text("Inglés").tag("en")
                }
            }

            Section {
                Button {
                    Task {
                        await viewModel.generateExam()
                    }
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.isLoading {
                            ProgressView("Generando examen…")
                        } else {
                            Text("Generar examen")
                        }
                        Spacer()
                    }
                }
                .disabled(!viewModel.canGenerate)
            }
        }
    }

    private var examView: some View {
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

    private var resultsView: some View {
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
