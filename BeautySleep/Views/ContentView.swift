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
                .foregroundColor(.blue)
                .font(.system(size: 40))
            
            Text("Log In")
                .font(.title)
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
