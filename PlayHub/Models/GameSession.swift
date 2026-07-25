//
//  GameSession.swift
//  PlayHub
//
//  Created by Amaya Mahavithane on 2026-07-06.
//
import Foundation

struct GameSession: Codable, Identifiable {

    let id: UUID
    let mode: GameMode
    let score: Int
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    let playerID: UUID?
    let playerName: String

    init(id: UUID, mode: GameMode, score: Int, timestamp: Date, latitude: Double, longitude: Double, playerID: UUID? = nil, playerName: String = "Guest") {
        self.id = id
        self.mode = mode
        self.score = score
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
        self.playerID = playerID
        self.playerName = playerName
    }

    private enum CodingKeys: String, CodingKey {
        case id, mode, score, timestamp, latitude, longitude, playerID, playerName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        mode = try container.decode(GameMode.self, forKey: .mode)
        score = try container.decode(Int.self, forKey: .score)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        playerID = try container.decodeIfPresent(UUID.self, forKey: .playerID)
        playerName = try container.decodeIfPresent(String.self, forKey: .playerName) ?? "Guest"
    }
}
