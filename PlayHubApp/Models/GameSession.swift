//
//  GameSession.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-24.
//

import Foundation

struct GameSession: Codable, Identifiable {
    let id: UUID
    let mode: GameMode
    let score: Int
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    
    // Convenience initializer with defaults for id and timestamp
    init(
        id: UUID = UUID(),
        mode: GameMode,
        score: Int,
        timestamp: Date = Date(),
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.mode = mode
        self.score = score
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
    }
}
