//
//  SettingsTab.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-23.
//

import SwiftUI

struct SettingsTab: View {
    var body: some View {
        
        HStack(){
            
            Image(systemName: "gearshape.fill")
                    .foregroundColor(.black)
                    .font(.system(size:24))
            Text(" Setting Tab")
                .font(.title2)
            Spacer()
        }.padding(20)
        
        
        List {
            Section("Preferences") {
                Label("Notifications", systemImage: "bell.fill")
                Label("Time picker", systemImage: "fitness.timer.fill")
            }
            Section("Account") {
                Label("Profile", systemImage: "person.circle.fill")
                Label("Reset All Stats", systemImage: "exclamationmark.square.fill")
            }
        }
    }
}

#Preview {
    SettingsTab()
}
