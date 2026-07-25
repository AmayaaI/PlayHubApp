import Foundation
import Combine

final class PlayerStore: ObservableObject {
    static let shared = PlayerStore()

    private let profilesKey = "PlayerProfiles"
    private let selectedPlayerKey = "SelectedPlayerID"

    @Published private(set) var players: [PlayerProfile]
    @Published private(set) var selectedPlayerID: UUID?

    var selectedPlayer: PlayerProfile? {
        players.first { $0.id == selectedPlayerID }
    }

    private init() {
        players = Self.loadPlayers(forKey: profilesKey)
        selectedPlayerID = UserDefaults.standard.string(forKey: selectedPlayerKey).flatMap(UUID.init(uuidString:))

        if !players.isEmpty && selectedPlayer == nil {
            selectedPlayerID = players[0].id
            persistSelection()
        }
    }

    func addPlayer(named name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let player = PlayerProfile(name: trimmedName)
        players.append(player)
        selectedPlayerID = player.id
        persist()
    }

    func select(_ player: PlayerProfile) {
        selectedPlayerID = player.id
        persistSelection()
    }

    func delete(_ player: PlayerProfile) {
        guard players.count > 1 else { return }
        players.removeAll { $0.id == player.id }
        if selectedPlayerID == player.id {
            selectedPlayerID = players.first?.id
        }
        persist()
    }

    /// Removes every saved player profile and leaves the app ready for a new player to be added.
    func resetAllPlayers() {
        UserDefaults.standard.removeObject(forKey: profilesKey)
        UserDefaults.standard.removeObject(forKey: selectedPlayerKey)

        players = []
        selectedPlayerID = nil
    }

    private static func loadPlayers(forKey key: String) -> [PlayerProfile] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([PlayerProfile].self, from: data)) ?? []
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(players) {
            UserDefaults.standard.set(data, forKey: profilesKey)
        }
        persistSelection()
    }

    private func persistSelection() {
        UserDefaults.standard.set(selectedPlayerID?.uuidString, forKey: selectedPlayerKey)
    }
}
