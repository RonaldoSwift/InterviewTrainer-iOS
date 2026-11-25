import SwiftUI

public struct HomeView: View {
    private let viewModel: HomeViewModel

    public init(onStartPractice: @escaping () -> Void) {
        viewModel = HomeViewModel(onStartPractice: onStartPractice)
    }

    public var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("InterviewTrainer")
                    .font(.largeTitle.bold())

                Text("Practica y prepárate para tu próxima entrevista.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            Button("Comenzar práctica") {
                viewModel.startPractice()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Inicio")
    }
}
