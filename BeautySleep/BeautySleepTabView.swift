//
//  BeautySleepTabView.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 17/11/2023.
//

import SwiftUI

struct BeautySleepTabView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    var body: some View {
        TabView(selection: $selectedTab){
            HomeView()
                .tag("Home")
                .tabItem{
                    Image(systemName: "house")
                }
            ContentView()
                .tag("Content")
                .tabItem{
                    Image(systemName: "person")
                }
        }
    }
}

struct BeautySleepTabView_Previews: PreviewProvider {
    static var previews: some View {
        BeautySleepTabView()
        
    }
}
//#Preview {
//    BeautySleepTabView()
//}
