//
//  GameStorage.swift
//  PlayHub
//

import Foundation
import Combine

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


        sessions.append(session)


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



    func reset() {


        sessions.removeAll()


        UserDefaults.standard.removeObject(
            forKey: key
        )

    }

}
