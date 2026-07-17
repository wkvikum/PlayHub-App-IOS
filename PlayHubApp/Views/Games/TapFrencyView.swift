//
//  TapFrencyView.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-17.
//

import SwiftUI

struct TapFrenzyView: View {
    // Instantiate our game View Model
    @StateObject private var viewModel = TapFrenzyVM()

    var body: some View {
        VStack(spacing: 20) {
            // 1. Score Display (Top)
            HStack(spacing: 20) {
                Text("SCORE")
                    .font(.title2)
                    .foregroundColor(.black)
                    .tracking(2)
                Text("\(viewModel.score)")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
            }
            .padding(.top)
            
            // 2. Center Game Area
            GeometryReader { geometry in
                ZStack {
                    Color.clear // Defines the boundary space
                    
                    Button(action: {
                        viewModel.buttonTapped(in: geometry.size)
                    }) {
                        Circle()
                            .fill(viewModel.buttonColor)
                            .frame(width: 180, height: 180)
                            .shadow(color: viewModel.buttonColor.opacity(0.4), radius: 10, x: 0, y: 8)
                            .overlay(
                                Text(viewModel.buttonText)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            )
                    }
                    .disabled(viewModel.gameHasStarted && !viewModel.isGameActive)
                    .position(viewModel.circlePosition)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.circlePosition)
                }
                .onAppear {
                    viewModel.resetCircleToCenter(in: geometry.size)
                }
                .alert(isPresented: $viewModel.showGameOverAlert) {
                    Alert(
                        title: Text("Game Over!"),
                        message: Text("You scored \(viewModel.score) points."),
                        dismissButton: .default(Text("Play Again"), action: {
                            viewModel.resetGame(in: geometry.size)
                        })
                    )
                }
            }
            
            // 3. Countdown Display (Bottom)
            HStack(spacing: 8) {
                Text("TIME")
                    .font(.title2)
                    .foregroundColor(.black)
                    .tracking(2)
                Text("\(viewModel.timeRemaining)s")
                    .font(.system(size: 30, weight: .semibold, design: .monospaced))
                    .foregroundColor(viewModel.timeRemaining <= 3 ? .orange : .primary)
            }
            .padding(.bottom)
        }
        .padding()
    }
}

// Preview setup
struct TapFrenzyView_Previews: PreviewProvider {
    static var previews: some View {
        TapFrenzyView()
    }
}

