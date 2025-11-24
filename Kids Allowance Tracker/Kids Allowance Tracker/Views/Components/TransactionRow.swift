import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(transaction.accent.opacity(0.2))
                    .frame(width: 44, height: 44)
                Image(systemName: transaction.type.icon)
                    .foregroundStyle(transaction.accent)
                    .font(.title3)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.Ink)
                Text(transaction.subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.formattedAmount)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(transaction.type == .income ? Color.Mint : Color.Sunset)
                Text(transaction.formattedDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 3)
        )
    }
}

#Preview {
    TransactionRow(
        transaction: Transaction(
            title: "Bike to school",
            subtitle: "Daily reward",
            date: .now,
            amount: 5,
            type: .income,
            tintName: "OceanBlue"
        )
    )
    .padding()
    .background(Color.Sky)
}
