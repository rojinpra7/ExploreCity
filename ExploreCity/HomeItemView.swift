//
//  HomeItemView.swift
//  ExploreCity
//
//  Created by Rojin Prajapati on 12/8/23.
//

import SwiftUI

struct HomeItemView: View {
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 8)
            base.fill(.teal)
            VStack {
                Label("Apartment", systemImage: "house.fill").font(.title2)
                    .labelStyle(.iconOnly)
                Text("Apartment").padding(3)
            }
        }.padding()
        
            
    }
}

#Preview {
    HomeItemView()
}
