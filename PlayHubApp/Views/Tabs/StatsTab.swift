//
//  StatsTab.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-23.
//

import SwiftUI

struct StatsTab: View {
    var body: some View {
        HStack(){
            
            Image(systemName: "chart.bar.fill")
                    .foregroundColor(.black)
                    .font(.system(size:24))
            Text(" Stats Tab")
                .font(.title2)
            Spacer()
        }.padding(20)
        
        Spacer()
    }
}

#Preview {
    StatsTab()
}
