import SwiftUI

public struct PracticeView: View {
    @StateObject private var viewModel = PracticeViewModel()

    public init() {}

    public var body: some View {
        Group {
            switch viewModel.screen {
            case .configuration:
                ConfigurationView(viewModel: viewModel)
            case .exam:
                ExamView(viewModel: viewModel)
            case .results:
                ResultsView(viewModel: viewModel)
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
}
