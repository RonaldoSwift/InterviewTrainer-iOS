
import SwiftUI

public struct HomeView: View {

    @State private var viewModel = HomeViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text(viewModel.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(viewModel.subtitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Button("Comenzar práctica") {
                    viewModel.startPractice()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Inicio")
            .alert("¡Vamos a practicar!", isPresented: $viewModel.isShowingPractice) {
                Button("Aceptar", role: .cancel) {}
            } message: {
                Text("Tu primera práctica estará disponible próximamente.")
            }
        }
    }
}

#Preview {
    HomeView()
}
