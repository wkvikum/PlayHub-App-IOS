//
//  QuizModel.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-17.
//

import Foundation

// 1. The outer wrapper matching the API root
struct QuizResponse: Codable {
    let results: [Question]
}

// 2. The individual question model
struct Question: Codable, Identifiable {
    // Adding Identifiable makes it easy to loop through in SwiftUI views later
    var id: UUID { UUID() }
    
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    // CodingKeys map the API's snake_case names to Swift's preferred camelCase
    enum CodingKeys: String, CodingKey {
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
    
    // A helper property to combine and shuffle all answers for the UI
    var allAnswers: [String] {
        var answers = incorrectAnswers
        answers.append(correctAnswer)
        return answers.shuffled()
    }
}
