//
//  ContentView.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 17/11/2023.
//

import SwiftUI
import FirebaseDatabase



struct ContentView: View {
    
    var body: some View {
            VStack {
                Image(systemName: "watch.analog")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Log In")
            }
            .padding()
        }
    }



#Preview {
    ContentView()
}
