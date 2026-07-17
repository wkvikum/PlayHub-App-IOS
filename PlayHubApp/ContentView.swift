//
//  ContentView.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-16.
//

import SwiftUI

// 1. The main container that handles the navigation tabs
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Your primary Content View
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            // A secondary Search View
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            // A secondary Settings View
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        // Controls the color of the active tab icon and text
        .accentColor(.blue)
    }
}

// 2. Your actual Content View where the main app feature lives
struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome Home")
                    .font(.largeTitle)
                    .bold()
                Text("This is your primary screen content area.")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Dashboard")
        }
    }
}

// Dummy Placeholder Views for compilation
struct SearchView: View {
    var body: some View {
        Text("Search Screen")
            .font(.title)
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings Screen")
            .font(.title)
    }
}

// Preview provider for canvas rendering
#Preview {
    MainTabView()
}
