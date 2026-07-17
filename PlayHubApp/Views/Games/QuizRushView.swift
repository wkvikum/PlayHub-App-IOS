//
//  QuizRushView.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-17.
//

import SwiftUI

struct QuizRushView: View {
    // Connect to our ViewModel
    @StateObject private var viewModel = QuizViewModel()
    
    // State to track feedback after tapping an answer
    @State private var selectedAnswer: String? = nil
    @State private var hasAnswered = false
    
    var body: some View {
        VStack{
            Group {
                switch viewModel.viewState {
                case .loading:
                    ProgressView("Fetching Questions...")
                        .scaleEffect(1.5)
                    
                case .failed:
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.yellow) // Changed from .amber to fix the build error
                        Text("Failed to load quiz")
                        Button("Try Again") {
                            Task { await viewModel.loadQuestions() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                case .loaded:
                    if viewModel.currentIndex >= viewModel.questions.count {
                        gameOverView
                    } else if let currentQuestion = viewModel.currentQuestion {
                        quizGameplayView(for: currentQuestion)
                    }
                }
            }
            .navigationTitle("Quiz Game")
            // Automatically fires the API fetch task when the screen appears
            .task {
                await viewModel.loadQuestions()
            }
            
        }
        .navigationTitle("Quiz Game") // This now correctly attaches to the Home View's Navigation stack!
            .task {
                await viewModel.loadQuestions()
            }
        
    }
    
    // MARK: - Subviews
    
    // 1. Core Gameplay Layout
    private func quizGameplayView(for question: Question) -> some View {
        VStack(spacing: 24) {
            // Stats Header
            HStack {
                Text("Scores - \(viewModel.score)")
                    .font(.headline)
                Spacer()
                Text("🔥 Streak - \(viewModel.streak)")
                    .font(.headline)
                    .foregroundColor(.orange)
                Spacer()
                Text("Qestions - \(viewModel.currentIndex + 1)/\(viewModel.questions.count)")
                    .font(.subheadline)
            }
            .padding(.horizontal)
            .padding(.vertical)
            // The Question Card
            Text(question.question)
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.orange)
                .background(Color(.orange.opacity(0.1)))
                .cornerRadius(12)
                .padding(.horizontal)
            
            // Answer Selections
            VStack(spacing: 12) {
                // Using the helper we created in Step 1 to safely show scrambled choices
                ForEach(question.allAnswers, id: \.self) { answer in
                    Button(action: {
                        if !hasAnswered {
                            selectedAnswer = answer
                            hasAnswered = true
                            viewModel.submitAnswer(answer)
                        }
                    }) {
                        Text(answer)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary) // Changes text color to fit light/dark mode
                            .frame(maxWidth: .infinity)
                            .padding()
                            // 1. Transparent background color with custom opacity
                            .background(
                                buttonColor(for: answer, in: question).opacity(0.15)
                            )
                            // 2. Beautiful matching rectangle border outline
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(buttonColor(for: answer, in: question), lineWidth: 2)
                            )
                            .cornerRadius(10)
                    }
                    .disabled(hasAnswered)
                }
                
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Next Button appears only after answering
            if hasAnswered {
                Button(action: {
                    // Reset single question state and advance index
                    hasAnswered = false
                    selectedAnswer = nil
                    viewModel.nextQuestion()
                }) {
                    Text(viewModel.currentIndex == viewModel.questions.count - 1 ? "See Results" : "Next Question")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        
                    
                }
                .padding()
            }
        }
    }
    
    // 2. Game End Summary Screen
    private var gameOverView: some View {
        VStack(spacing: 20) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 80))
                .foregroundColor(.yellow)
            
            Text("Quiz Complete")
                .font(.largeTitle)
                .bold()
            
            Text("Your Final Score")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(viewModel.score)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
            
            Button("Play Again") {
                viewModel.currentIndex = 0
                viewModel.score = 0
                viewModel.streak = 0
                Task { await viewModel.loadQuestions() }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
    
    
    private func buttonColor(for answer: String, in question: Question) -> Color {
        guard hasAnswered else { return .blue.opacity(0.8) }
        
        if answer == question.correctAnswer {
            return .green // Highlight real answer green
        } else if answer == selectedAnswer {
            return .red // If user selected this wrong answer, dye it red
        }
        
        return .blue.opacity(0.5) // Gray out neutral choices
    }
}

#Preview {
    QuizRushView()
}

