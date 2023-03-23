//
//  ContentView.swift
//  WalE
//
//  Created by Shashi on 23/03/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 0) {
                HStack {
                    Text("Astronomy Picture of the Day")
                        .font(.title2)
                    
                    Spacer()
                }
                
                
                
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .background(Color.orange)
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
