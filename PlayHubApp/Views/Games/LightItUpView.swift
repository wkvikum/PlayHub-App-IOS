//
//  LightItUpView.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-17.
//

import SwiftUI

struct LightItUp: View {
    // Instantiate the ViewModel to manage our state and game logic
    @StateObject private var viewModel = LightItUpViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            VStack(spacing: 30) {   // Top stack
                Text("Light It Up")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.top, 20)
                
                HStack(spacing: 30) {
                    HStack(spacing: 10) {
                        Text("Time :")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                        
                        Text("\(viewModel.timeElapsed)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .monospacedDigit()
                            .frame(width: 50, alignment: .leading)
                    }
                    
                    HStack(spacing: 10) {
                        Text("Fault Count :")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.gray)
                        Text("\(viewModel.faultCount)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.gray)
                            .monospacedDigit()
                            .frame(width: 50, alignment: .leading)
                    }
                }
            }
                                                                                
            LazyVGrid(columns: viewModel.columns, spacing: 10) {
                ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                    let isVisible = viewModel.shouldShowCard(at: index)
                    let isFlashing = viewModel.flashingCardIndexs.contains(index) && isVisible
                    
                    Text("")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(
                            isFlashing
                            ? (viewModel.isBlinking ? Color.green : Color.green.opacity(0.6))
                            : Color.blue.opacity(isVisible ? 0.6 : 0.1)
                        )
                        .cornerRadius(14)
                        .shadow(color: isFlashing ? .green.opacity(0.8) : .clear, radius: viewModel.isBlinking ? 12 : 4)
                        .scaleEffect(viewModel.tappedIndex == index ? 0.92 : 1.0)
                        .onTapGesture {
                            viewModel.handleTap(at: index)
                        }
                }
            }
            .padding()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Level :")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text(viewModel.currentLevelData.level)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                        .monospacedDigit()
                        .frame(width: 50, alignment: .leading)
                }
                
                HStack {
                    Text("Scores :")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("\(viewModel.score)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .monospacedDigit()
                        .frame(width: 70, alignment: .leading)
                }
            }
        }
        .onAppear {
            viewModel.startTimer()
        }
        .alert(isPresented: $viewModel.showGameOver) {
            Alert(
                title: Text(viewModel.isNewHighScore ? "🏆 New High Score! 🏆" : "Game End"),
                message: Text("Score: \(viewModel.score)\nFaults: -\(viewModel.faultCount)\nFinal Score: \(viewModel.finalScore)\n\nBest Score: \(viewModel.highScore)"),
                dismissButton: .default(Text("Play Again"), action: {
                    viewModel.resetTimer()
                })
            )
        }
    }
}

#Preview {
    LightItUp()
}





