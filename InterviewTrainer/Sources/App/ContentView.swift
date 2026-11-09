import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text("InterviewTrainer AI")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Prepárate para tu próxima entrevista técnica de iOS.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Button("Comenzar práctica") {
                    print("Iniciando práctica...")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Inicio")
        }
    }
}

#Preview {
    ContentView()
}
