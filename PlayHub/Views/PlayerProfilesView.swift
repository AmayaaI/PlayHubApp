import SwiftUI

struct PlayerProfilesView: View {
    @ObservedObject private var playerStore = PlayerStore.shared
    @Environment(\.dismiss) private var dismiss
    @State private var newPlayerName = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red: 0.07, green: 0.08, blue: 0.18), Color(red: 0.15, green: 0.10, blue: 0.28)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("PLAYER PROFILES")
                                .font(.caption.weight(.black))
                                .tracking(1.8)
                                .foregroundStyle(.cyan)
                            Text("Who’s playing today?")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                            Text("Choose a player to keep every score personal.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.64))
                        }

                        VStack(spacing: 10) {
                            ForEach(playerStore.players) { player in
                                playerRow(player)
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("ADD A PLAYER")
                                .font(.caption.weight(.bold))
                                .tracking(1.3)
                                .foregroundStyle(.white.opacity(0.55))

                            HStack(spacing: 10) {
                                TextField("Player name", text: $newPlayerName)
                                    .textInputAutocapitalization(.words)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 13)
                                    .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 15, style: .continuous))

                                Button {
                                    playerStore.addPlayer(named: newPlayerName)
                                    newPlayerName = ""
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.headline.bold())
                                        .foregroundStyle(.black)
                                        .frame(width: 48, height: 48)
                                        .background(.cyan, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                                }
                                .disabled(newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Players")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.bold)
                        .foregroundStyle(.cyan)
                }
            }
        }
    }

    private func playerRow(_ player: PlayerProfile) -> some View {
        let isSelected = player.id == playerStore.selectedPlayerID
        return HStack(spacing: 13) {
            Button {
                playerStore.select(player)
            } label: {
                HStack(spacing: 13) {
                Image(systemName: "person.fill")
                    .font(.title3)
                    .foregroundStyle(isSelected ? .black : .cyan)
                    .frame(width: 48, height: 48)
                    .background(isSelected ? Color.cyan : .white.opacity(0.1), in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text(player.name)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                    Text(isSelected ? "Active player" : "Tap to switch profile")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.62))
                }

                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.cyan)
                }
            }
            .padding(13)
            .background(isSelected ? Color.cyan.opacity(0.16) : .white.opacity(0.08), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? Color.cyan.opacity(0.75) : .white.opacity(0.1), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)

            if !isSelected && playerStore.players.count > 1 {
                Button(role: .destructive) {
                    playerStore.delete(player)
                } label: {
                    Image(systemName: "trash")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.55))
                        .padding(9)
                }
            }
        }
    }
}

#Preview {
    PlayerProfilesView()
}
