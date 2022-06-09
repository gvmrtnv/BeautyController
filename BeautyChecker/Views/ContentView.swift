//
//  ContentView.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 23.04.22.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "One"
 

    var body: some View {
        TabView(selection: $selectedTab) {
            CheckView()
            .tabItem {
                Label("Do a new check", systemImage: "camera")
           
                    .labelStyle(.iconOnly)
            }
            .tag("One")
            
            RecentView()
                .environmentObject(RecentViewModel())
                .tabItem {
                    Label("Previous checks", systemImage: "clock.arrow.circlepath")
                        .labelStyle(.iconOnly)
                       
                }
                .tag("Two")
        }
        .accentColor(.mystic)
    }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
