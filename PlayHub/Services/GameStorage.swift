//
//  GameStorage.swift
//  PlayHub
//

import Foundation
import Combine
import CoreLocation

class GameStorage: ObservableObject {

    static let shared = GameStorage()

    private let key = "GameSessions"

    @Published var sessions: [GameSession] = []


    private init() {

        sessions = loadSessions()

    }


    func loadSessions() -> [GameSession] {

        guard let data = UserDefaults.standard.data(forKey: key) else {

            return []

        }


        do {

            return try JSONDecoder().decode(
                [GameSession].self,
                from: data
            )

        } catch {

            print("Loading error:", error)

            return []

        }
    }



    func saveSession(_ session: GameSession) {

        let player = PlayerStore.shared.selectedPlayer
        let coordinate = LocationService.shared.latestCoordinate
        let attributedSession = GameSession(
            id: session.id,
            mode: session.mode,
            score: session.score,
            timestamp: session.timestamp,
            // Capture the location at the exact moment this game ends.
            latitude: coordinate?.latitude ?? session.latitude,
            longitude: coordinate?.longitude ?? session.longitude,
            playerID: player?.id,
            playerName: player?.name ?? "Guest"
        )

        sessions.append(attributedSession)


        do {

            let data = try JSONEncoder().encode(sessions)

            UserDefaults.standard.set(
                data,
                forKey: key
            )


        } catch {

            print("Saving error:", error)

        }

    }

    func sessions(for playerID: UUID?) -> [GameSession] {
        sessions.filter { $0.playerID == playerID }
    }

    /// Deletes only the game sessions belonging to one player.
    func deleteSessions(for playerID: UUID?) {
        sessions.removeAll { $0.playerID == playerID }

        do {
            let data = try JSONEncoder().encode(sessions)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Saving error:", error)
        }
    }

    /// Returns one player's best score for a game mode.
    func bestScore(for mode: GameMode, playerID: UUID? = PlayerStore.shared.selectedPlayerID) -> Int {
        sessions
            .filter { $0.mode == mode && $0.playerID == playerID }
            .map(\.score)
            .max() ?? 0
    }



    func reset() {


        sessions.removeAll()


        UserDefaults.standard.removeObject(
            forKey: key
        )

    }

}
