//
//  ContentView.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-16.
//

import SwiftUI

// initial tabview itrms
enum AppTab: String, CaseIterable, Identifiable {
    case home
    case status
    case map
    case settings
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .status: return "Stats"
        case .map: return "Map"
        case .settings: return "Settings"
        }
    }
    
    // Changes to a filled icon when selected
    var iconName: String {
        switch self {
        case .home: return "house"
        case .status: return "chart.bar"
        case .map: return "map"
        case .settings: return "gearshape"
        }
    }
    
    var activeIconName: String {
        switch self {
        case .home: return "house.fill"
        case .status: return "chart.bar.fill"
        case .map: return "map.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

// make tabe view in content view
struct ContentView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            
            // 1. Home Tab
            NavigationStack {
                HomeTab()
            }
            .tabItem {
                Label(
                    AppTab.home.title,
                    systemImage: selectedTab == .home ? AppTab.home.activeIconName : AppTab.home.iconName
                )
            }
            .tag(AppTab.home)

            // 2. Status Tab
            NavigationStack {
                StatsTab()
            }
            .tabItem {
                Label(
                    AppTab.status.title,
                    systemImage: selectedTab == .status ? AppTab.status.activeIconName : AppTab.status.iconName
                )
            }
            .tag(AppTab.status)

            // 3. Map Tab
            NavigationStack {
                MapTab()
            }
            .tabItem {
                Label(
                    AppTab.map.title,
                    systemImage: selectedTab == .map ? AppTab.map.activeIconName : AppTab.map.iconName
                )
            }
            .tag(AppTab.map)

            // 4. Settings Tab
            NavigationStack {
                SettingsTab()
            }
            .tabItem {
                Label(
                    AppTab.settings.title,
                    systemImage: selectedTab == .settings ? AppTab.settings.activeIconName : AppTab.settings.iconName
                )
            }
            .tag(AppTab.settings)
        }
        .tint(.accentColor) // Highlights selected tab icon/text
    }
}


#Preview {
    ContentView()
}
