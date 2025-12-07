import SwiftUI

struct PendientesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Pedidos Pendientes")
                .font(.title)
                .bold()
            Text("Aquí verás la lista de pedidos pendientes.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        PendientesView()
            .navigationTitle("Pendientes")
    }
}
