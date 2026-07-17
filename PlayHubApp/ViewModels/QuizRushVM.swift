//
//  QuizRushVM.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-17.
//

import Foundation

// 1. Define the possible UI states
enum ViewState {
    case loading
    case loaded
    case failed
}

@MainActor
class QuizViewModel: ObservableObject {
    // 2. Published properties to drive the SwiftUI interface
    @Published var questions: [Question] = []
    @Published var currentIndex = 0
    @Published var score = 0
    @Published var streak = 0
    @Published var viewState: ViewState = .loading
    
    // Dependencies
    private let networkService = NetworkService()
    
    // 3. Helper to get the current active question safely
    var currentQuestion: Question? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }
    
    // 4. Async function to load data from the network service
    func loadQuestions() async {
        viewState = .loading
        do {
            self.questions = try await networkService.fetchQuestions()
            self.viewState = .loaded
        } catch {
            self.viewState = .failed
        }
    }
    
    // 5. Game logic function to check user answer selections
    func submitAnswer(_ selectedAnswer: String) {
        guard let currentQuestion = currentQuestion else { return }
        
        if selectedAnswer == currentQuestion.correctAnswer {
            score += 10
            streak += 1
        } else {
            score -= 5
            streak = 0 // Reset streak on a wrong answer
        }
    }
    
    // 6. Progress to the next question
    func nextQuestion() {
        if currentIndex < questions.count {
            currentIndex += 1
        }
    }
}

