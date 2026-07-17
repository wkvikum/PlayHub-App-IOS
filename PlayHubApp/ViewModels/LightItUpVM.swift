//
//  LightItUpVM.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-17.
//

import SwiftUI
import Combine

class LightItUpViewModel: ObservableObject {
    // Grid Setup
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    let items = Array(1...9).map { "\($0)" }
    
    // Timer State
    @Published var timeElapsed = 0
    @Published var timerActive = false
    private var timer: Timer? = nil
    
    // Flashing Cards
    @Published var flashingCardIndexs: Set<Int> = []
    private var flashTimer: Timer? = nil
    @Published var isBlinking = false // Blink animation flag
    
    // Tap Animation
    @Published var tappedIndex: Int? = nil
    
    // Scores
    @Published var score = 0
    @Published var faultCount = 0
    @Published var showGameOver = false
    
    // High Score Storage
    @AppStorage("high_score") var highScore = 0
    @Published var isNewHighScore = false
    @Published var finalScore = 0
    
    // Unified Dynamic Level & Speed Data Tuple
    var currentLevelData: (level: String, interval: Double) {
        if !timerActive && timeElapsed == 0 { return ("01", 1.5) }
        
        switch timeElapsed {
        case 0...15:  return ("01", 1.5)
        case 16...30: return ("02", 1.2)
        case 31...45: return ("03", 1.0)
        case 46...60: return ("04", 0.8)
        default:      return ("01", 1.5)
        }
    }
    
    // MARK: - Game functions
    
    func startTimer() {
        if timeElapsed >= 60 {
            stopTimer()
            timeElapsed = 0
        }
        timerActive = true
        
        withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
            isBlinking = true
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeElapsed < 60 {
                let existingInterval = self.currentLevelData.interval
                self.timeElapsed += 1
                
                if self.currentLevelData.interval != existingInterval {
                    self.startFlashTimerLoop()
                }
            } else {
                self.endGameAndCheckHighScore()
            }
        }
        
        updateFlashingCard()
        startFlashTimerLoop()
    }
    
    func startFlashTimerLoop() {
        flashTimer?.invalidate()
        flashTimer = Timer.scheduledTimer(withTimeInterval: currentLevelData.interval, repeats: true) { [weak self] _ in
            self?.updateFlashingCard()
        }
    }
    
    func handleTap(at index: Int) {
        guard timerActive else { return }
        
        // Handle Tap UI Animation state transition
        withAnimation(.easeOut(duration: 0.15)) {
            tappedIndex = index
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeIn(duration: 0.1)) {
                if self.tappedIndex == index {
                    self.tappedIndex = nil
                }
            }
        }
        
        let isFlashing = flashingCardIndexs.contains(index) && shouldShowCard(at: index)
        if isFlashing {
            score += 1
            handleSuccessfulTap(for: index)
        } else {
            faultCount += 1
        }
    }
    
    private func handleSuccessfulTap(for tappedIndex: Int) {
        flashTimer?.invalidate()
        flashTimer = nil
        
        flashingCardIndexs.remove(tappedIndex)
        
        let availableIndices = items.indices.filter { index in
            shouldShowCard(at: index) && !flashingCardIndexs.contains(index) && index != tappedIndex
        }
        
        if let newPosition = availableIndices.randomElement() {
            flashingCardIndexs.insert(newPosition)
        }
        
        startFlashTimerLoop()
    }
    
    func updateFlashingCard() {
        let validIndices = items.indices.filter { shouldShowCard(at: $0) }
        guard !validIndices.isEmpty else { return }
        
        if currentLevelData.level == "04" {
            if validIndices.count >= 2 {
                let shuffled = validIndices.shuffled()
                flashingCardIndexs = Set(shuffled.prefix(2))
            } else {
                flashingCardIndexs = Set(validIndices)
            }
        } else {
            let uniquePositions = validIndices.filter { !flashingCardIndexs.contains($0) }
            if let randomElement = (!uniquePositions.isEmpty ? uniquePositions : validIndices).randomElement() {
                flashingCardIndexs = [randomElement]
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        flashTimer?.invalidate()
        flashTimer = nil
        timerActive = false
        flashingCardIndexs.removeAll()
        isBlinking = false
    }
    
    func resetTimer() {
        stopTimer()
        timeElapsed = 0
        score = 0
        faultCount = 0
        finalScore = 0
        isNewHighScore = false
        startTimer()
    }
    
    func endGameAndCheckHighScore() {
        stopTimer()
        
        finalScore = score - faultCount
        
        if finalScore > highScore {
            highScore = finalScore
            isNewHighScore = true
        } else {
            isNewHighScore = false
        }
        
        showGameOver = true
    }
    
    // MARK: - Rule Mapping Matrix
    func shouldShowCard(at index: Int) -> Bool {
        if !timerActive && timeElapsed == 0 { return false }
        
        switch timeElapsed {
        case 0...15:
            return index < 3
        case 16...30:
            return index < 3 || index == 4
        case 31...45:
            return index < 6
        case 46...60:
            return true
        default:
            return true
        }
    }
}
