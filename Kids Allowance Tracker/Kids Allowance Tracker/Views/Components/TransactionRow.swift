import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            // Use simple paw print with rotation
            ZStack {
                Circle()
                    .fill(
                        transaction.type == .income 
                            ? Color.pink.opacity(0.15) 
                            : Color.black.opacity(0.1)
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: "pawprint.fill")
                    .foregroundStyle(transaction.type == .income ? Color.pink : Color.black)
                    .font(.title3)
                    .rotationEffect(.degrees(transaction.type == .income ? 0 : 180))
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
                    .foregroundStyle(transaction.type == .income ? Color.pink : Color.black)
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
    VStack(spacing: 12) {
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
        
        TransactionRow(
            transaction: Transaction(
                title: "Comic Book",
                subtitle: "Fun purchase",
                date: .now,
                amount: 9,
                type: .expense,
                tintName: "Sunset"
            )
        )
    }
    .padding()
    .background(Color.Sky)
}
