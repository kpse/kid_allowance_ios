import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: DashboardViewModel
    
    @State private var title: String = ""
    @State private var amountString: String = ""
    @State private var type: TransactionType = .expense
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("What is it for?", text: $title)
                    
                    HStack {
                        Text("$")
                        TextField("Amount", text: $amountString)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section("Type") {
                    Picker("Type", selection: $type) {
                        ForEach(TransactionType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Add Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(title.isEmpty || amountString.isEmpty)
                }
            }
        }
    }
    
    private func save() {
        guard let amount = Double(amountString) else { return }
        
        viewModel.addTransaction(
            title: title,
            subtitle: type == .income ? "Manual Income" : "Manual Expense",
            amount: amount,
            type: type,
            tintName: type == .income ? "Mint" : "Sunset"
        )
        
        dismiss()
    }
}

#Preview {
    AddTransactionView()
        .environmentObject(DashboardViewModel())
}
