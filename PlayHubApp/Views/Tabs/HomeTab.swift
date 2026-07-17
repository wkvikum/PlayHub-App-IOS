//
//  HomeTab.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-17.
//

import SwiftUI


// This is the Home page

 struct HomeTab: View {
    var body: some View {
        NavigationStack {
            VStack(){
                Text("Select The Game")
                    .font(.title)
//                    .bold()
            }
            .padding(.horizontal, 40)
            VStack(spacing: 40) {
                
                NavigationLink(destination: TapFrenzyView()) {
                    Text("Tap Frenzy")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.green)
                        .padding()
                        .frame(maxWidth: 200, maxHeight: 100)
                        .background(Color.green.opacity(0.15))
                        .cornerRadius(10)
                    
                }
                .padding(.horizontal, 40)
                // The NavigationLink acts as a clickable button
                NavigationLink(destination: LightItUpView()) {
                    Text("Light It UP")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: 200, maxHeight: 100)
                        .background(Color.blue.opacity(0.15))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                
                
                // Quiz
                
                NavigationLink(destination: QuizRushView()) {
                    Text("Quiz Rush")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.orange)
                        .padding()
                        .frame(maxWidth: 200, maxHeight: 100)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
            .navigationTitle("") // Sets
        }
    }
}

struct SecondView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Second Page!")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("You successfully navigated here.")
                .foregroundColor(.secondary)
        }
        .navigationTitle("Second Page")
        // This ensures the title displays nicely in the navigation bar
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HomeTab()
}
