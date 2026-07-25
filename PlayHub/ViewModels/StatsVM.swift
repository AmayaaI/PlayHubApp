//
//  StatsVM.swift
//  PlayHub
//
//  Created by Amaya Mahavithane on 2026-07-06.
//

import Foundation
import Combine

class StatsVM: ObservableObject {

    @Published var sessions: [GameSession] = []

    init() {
        loadSessions(for: PlayerStore.shared.selectedPlayerID)
    }

    func loadSessions(for playerID: UUID?) {

        sessions = GameStorage.shared.sessions(for: playerID)

    }

    func highScores(for mode: GameMode) -> [GameSession] {
        let scoresByPlayer = Dictionary(grouping: GameStorage.shared.sessions.filter { $0.mode == mode }) {
            $0.playerID?.uuidString ?? $0.playerName
        }
        return scoresByPlayer.values
            .compactMap { $0.max(by: { $0.score < $1.score }) }
            .sorted { $0.score > $1.score }
    }
    var bestTapFrenzy: Int {
        sessions
            .filter { $0.mode == .tapFrenzy }
            .map { $0.score }
            .max() ?? 0
    }

    var bestLightItUp: Int {
        sessions
            .filter { $0.mode == .lightItUp }
            .map { $0.score }
            .max() ?? 0
    }

    var bestQuizRush: Int {
        sessions
            .filter { $0.mode == .quizRush }
            .map { $0.score }
            .max() ?? 0
    }

}
