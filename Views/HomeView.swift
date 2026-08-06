import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: SessionViewModel

    private var buttonTitle: String {
        viewModel.isWorking ? "FINALIZAR TRABAJO" : "INICIAR TRABAJO"
    }

    private var buttonColor: Color {
        viewModel.isWorking ? .red : .green
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 36) {
                VStack(spacing: 8) {
                    Text("Registro de Horas")
                        .font(.largeTitle)
                        .bold()
                    Text(DateService.formattedDate())
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                Text(viewModel.formattedElapsedTime())
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)

                Button(action: viewModel.toggleWorkState) {
                    Text(buttonTitle)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(buttonColor)
                        .cornerRadius(16)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("Aceptar", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}
