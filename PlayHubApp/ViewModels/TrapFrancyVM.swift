//
//  TrapFrancyVM.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-17.
//

import SwiftUI
import Combine

class TapFrenzyVM: ObservableObject {
    // --- Game States ---
    @Published var score = 0
    @Published var timeRemaining = 10
    @Published var isGameActive = false
    @Published var gameHasStarted = false
    @Published var circlePosition = CGPoint(x: 150, y: 150) // Default starting position
    @Published var showGameOverAlert = false
    
    private var timer: Timer? = nil
    
    // --- Computed UI Styles (Derived from state) ---
    var buttonText: String {
        if !gameHasStarted {
            return "Start"
        } else if isGameActive {
            return "Can you tap"
        } else {
            return "Finish"
        }
    }
    
    var buttonColor: Color {
        if !gameHasStarted {
            return .blue.opacity(0.6)
        } else if isGameActive {
            return .blue
        } else {
            return .orange
        }
    }
    
    // --- Game Actions & Logic ---
    
    func buttonTapped(in size: CGSize) {
        if !gameHasStarted {
            startGame(in: size)
        } else if isGameActive {
            score += 1
        }
    }
    
    private func startGame(in size: CGSize) {
        score = 0
        timeRemaining = 10
        gameHasStarted = true
        isGameActive = true
        
        // Randomize position right away on start
        moveCircleRandomly(in: size)
        
        // Start a 1-second interval timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                // Move the circle only every 2 seconds (on even numbers remaining)
                if self.timeRemaining % 2 == 0 && self.timeRemaining > 0 {
                    self.moveCircleRandomly(in: size)
                }
            } else {
                self.endGame()
            }
        }
    }
    
    func moveCircleRandomly(in size: CGSize) {
        let padding: CGFloat = 90
        let randomX = CGFloat.random(in: padding...(size.width - padding))
        let randomY = CGFloat.random(in: padding...(size.height - padding))
        circlePosition = CGPoint(x: randomX, y: randomY)
    }
    
    func resetCircleToCenter(in size: CGSize) {
        circlePosition = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    func resetGame(in size: CGSize) {
        score = 0
        timeRemaining = 10
        gameHasStarted = false
        isGameActive = false
        resetCircleToCenter(in: size)
    }
    
    private func endGame() {
        isGameActive = false
        timer?.invalidate()
        timer = nil
        showGameOverAlert = true
    }
    
    deinit {
        timer?.invalidate()
    }
}
