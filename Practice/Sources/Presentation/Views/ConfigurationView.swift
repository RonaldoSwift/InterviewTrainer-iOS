import SwiftUI

struct ConfigurationView: View {
    @ObservedObject var viewModel: PracticeViewModel

    var body: some View {
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
}
