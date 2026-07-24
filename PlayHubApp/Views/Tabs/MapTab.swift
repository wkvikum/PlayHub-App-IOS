//
//  MapTab.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-23.
//

import SwiftUI

struct MapTab: View {
    var body: some View {
        HStack(){
            
            Image(systemName: "map.fill")
                    .foregroundColor(.black)
                    .font(.system(size:24))
            Text(" Map Tab")
                .font(.title2)
            Spacer()
        }.padding(20)
        
        Spacer()
    }
}

#Preview {
    MapTab()
}
