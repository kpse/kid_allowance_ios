import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: DashboardViewModel

    @State private var showAddTransaction = false

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [.Sky, .OceanBlue],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    header
                    balanceCard
                    rulesCard
                    streakCard
                    todayTasks
                    recentActivity
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
        }
        .overlay(alignment: .topTrailing) {
            if viewModel.showConfetti {
                ConfettiView()
                    .frame(width: 200, height: 200)
                    .offset(y: 40)
            }
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView()
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "face.smiling.fill")
                .font(.title)
                .foregroundStyle(.white)
                .padding(12)
                .background(.white.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text("Hi, \(viewModel.kidName)!")
                    .font(.title3).bold()
                    .foregroundStyle(.white)
                Text("Track your pocket money")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }

            Spacer()

            Button(action: { showAddTransaction = true }) {
                Image(systemName: "plus")
                    .font(.title3).bold()
                    .foregroundStyle(Color.OceanBlue)
                    .padding(10)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            }
            .accessibilityLabel("Add a new record")
        }
        .padding(.top, 8)
    }

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("My balance")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.9))
                    Text(viewModel.balanceText)
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Label("Goal: $120", systemImage: "target")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                    ProgressView(value: viewModel.balance / 120)
                        .tint(.white)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                }
            }

            HStack(spacing: 12) {
                Button {
                    showAddTransaction = true
                } label: {
                    ActionPill(title: "Add income", systemImage: "arrow.down.circle.fill", tint: .Mint)
                }
                
                Button {
                    showAddTransaction = true
                } label: {
                    ActionPill(title: "Add spending", systemImage: "arrow.up.circle.fill", tint: .Sunset)
                }
                
                Button {
                    // Reminder logic or just a placeholder
                } label: {
                    ActionPill(title: "Set reminder", systemImage: "alarm.fill", tint: .Lavender)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.OceanBlue, .Mint],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.OceanBlue.opacity(0.3), radius: 12, x: 0, y: 8)
        )
    }

    private var rulesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Allowance rules")
                .font(.headline)
                .foregroundStyle(Color.Ink)
            HStack(spacing: 12) {
                ForEach(viewModel.incomeRules) { rule in
                    Button {
                        // Optional: Could trigger quick add for these rules too, but "Today's quests" handles it better.
                        // For now, let's just show details or do nothing.
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Image(systemName: rule.icon)
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(rule.tint)
                                .clipShape(Circle())
                            Text(rule.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color.Ink)
                            Text(rule.reward)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
                        )
                    }
                }
            }
        }
    }

    private var streakCard: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Today tasks")
                    .font(.headline)
                    .foregroundStyle(Color.Ink)
                HStack(spacing: 6) {
                    ForEach(0..<viewModel.todayTotal, id: \.self) { index in
                        Circle()
                            .fill(index < viewModel.todayCompleted ? Color.Mint : Color.PillGrey)
                            .frame(width: 14, height: 14)
                    }
                    Spacer()
                    Text("\(viewModel.todayCompleted)/\(viewModel.todayTotal) done")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                Button {
                    // Manual check off if needed, but quests below handle it
                } label: {
                    Label("Check off a task", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.bold))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.Mint.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .center, spacing: 10) {
                Text("Streak")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(viewModel.streakText)
                    .font(.title2.bold())
                    .foregroundStyle(Color.OceanBlue)
                Text("Keep going!")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 140)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white)
            )
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 8)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
        )
    }

    private var todayTasks: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's quests")
                    .font(.headline)
                    .foregroundStyle(Color.Ink)
                Spacer()
                Text("Fun and easy")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                Button {
                    viewModel.completeQuest(title: "Bike to school", amount: 5, tintName: "OceanBlue")
                } label: {
                    questRow(title: "Bike to school", reward: "+$5", completed: viewModel.todayCompleted >= 1, tint: .OceanBlue)
                }
                .disabled(viewModel.todayCompleted >= 1) // Simple logic: disable if already done enough tasks? Or just let them click.
                // Actually, logic in ViewModel prevents > total. But let's just disable if this specific one is "done" conceptually.
                // Since we don't track *which* quest is done, just count, we'll just leave it enabled until total is reached or similar.
                // For better UX, let's just let them click and see confetti if count < total.
                
                Button {
                    viewModel.completeQuest(title: "All homework A", amount: 5, tintName: "Mint")
                } label: {
                    questRow(title: "All homework A", reward: "+$5", completed: viewModel.todayCompleted >= 2, tint: .Mint)
                }
                
                questRow(title: "Room tidy bonus", reward: "+$2", completed: false, tint: .Lavender)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 8)
        )
    }

    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Activity")
                    .font(.headline)
                    .foregroundStyle(Color.Ink)
                Spacer()
                Text("This week")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            ForEach(viewModel.transactions) { transaction in
                TransactionRow(transaction: transaction)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 8)
        )
        .padding(.bottom, 16)
    }

    private func questRow(title: String, reward: String, completed: Bool, tint: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.18))
                    .frame(width: 42, height: 42)
                Image(systemName: completed ? "checkmark.seal.fill" : "sparkles")
                    .foregroundStyle(tint)
                    .font(.title3)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.Ink)
                Text(reward)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(completed ? tint : Color.PillGrey)
                .font(.title3)
                .animation(.easeInOut, value: completed)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
        )
    }
}

struct ConfettiView: View {
    var body: some View {
        TimelineView(.animation) { context in
            Canvas { context, size in
                for index in 0..<30 {
                    var copy = context
                    let x = CGFloat.random(in: 0...size.width)
                    let y = CGFloat.random(in: 0...size.height)
                    let angle = Angle.degrees(Double.random(in: 0...360))
                    copy.translateBy(x: x, y: y)
                    copy.rotate(by: angle)
                    let rect = CGRect(x: -2, y: -6, width: 4, height: 12)
                    copy.fill(
                        Rectangle().path(in: rect),
                        with: .color(randomColor(index: index))
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func randomColor(index: Int) -> Color {
        let palette: [Color] = [.pink, .yellow, .mint, .blue, .orange, .purple]
        return palette[index % palette.count]
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(DashboardViewModel())
            .preferredColorScheme(.light)
    }
}
