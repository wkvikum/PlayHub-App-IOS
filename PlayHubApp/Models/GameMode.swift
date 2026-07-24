//
//  GameMode.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-24.
//

import Foundation

enum GameMode: String, Codable, CaseIterable, Identifiable {
    case tapFrenzy = "Tap Frenzy"
    case lightItUp = "Light It Up"
    case quizRush = "Quiz Rush"
    
    var id: String { rawValue }
}
