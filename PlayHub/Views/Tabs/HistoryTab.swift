import SwiftUI

struct HistoryTab: View {
    @ObservedObject private var playerStore = PlayerStore.shared
    @ObservedObject private var gameStorage = GameStorage.shared

    private var sessions: [GameSession] {
        gameStorage.sessions(for: playerStore.selectedPlayerID).sorted { $0.timestamp > $1.timestamp }
    }

    var body: some View {
        ZStack {
            premiumBackground

            if sessions.isEmpty {
                ContentUnavailableView("No Games Yet", systemImage: "clock.arrow.circlepath", description: Text("Your completed games will appear here."))
                    .foregroundStyle(.white)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Every game played by \(playerStore.selectedPlayer?.name ?? "this player").")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.65))

                        ForEach(sessions) { session in
                            HStack(spacing: 14) {
                                Image(systemName: icon(for: session.mode))
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 48, height: 48)
                                    .background(accent(for: session.mode), in: RoundedRectangle(cornerRadius: 15, style: .continuous))

                                VStack(alignment: .leading, spacing: 5) {
                                    Text(session.mode.rawValue)
                                        .font(.headline.weight(.bold))
                                        .foregroundStyle(.white)
                                    Text(session.timestamp.formatted(date: .abbreviated, time: .shortened))
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.62))
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("SCORE")
                                        .font(.caption2.weight(.bold))
                                        .tracking(0.8)
                                        .foregroundStyle(.white.opacity(0.48))
                                    Text("\(session.score)")
                                        .font(.title3.bold())
                                        .foregroundStyle(.yellow)
                                }
                            }
                            .padding(15)
                            .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(.white.opacity(0.13), lineWidth: 1)
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("Game History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Game History")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
        }
    }

    private func icon(for mode: GameMode) -> String {
        switch mode {
        case .tapFrenzy: return "bolt.fill"
        case .lightItUp: return "lightbulb.fill"
        case .quizRush: return "questionmark.circle.fill"
        }
    }

    private func accent(for mode: GameMode) -> Color {
        switch mode {
        case .tapFrenzy: return .pink
        case .lightItUp: return .orange
        case .quizRush: return .cyan
        }
    }

    private var premiumBackground: some View {
        LinearGradient(
            colors: [Color(red: 0.05, green: 0.06, blue: 0.16), Color(red: 0.16, green: 0.08, blue: 0.34), Color(red: 0.03, green: 0.28, blue: 0.38)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationStack { HistoryTab() }
}
