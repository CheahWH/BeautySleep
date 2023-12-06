////
////  HomeView.swift
////  BeautySleep
////
////  Created by Cheah Wen Hui on 17/11/2023.
////

//import SwiftUI
//
//struct HomeView: View {
//    @EnvironmentObject var manager: HealthManager
//    @State private var isShowingDetails = false
//
//    var body: some View {
//        VStack {
//            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
//                ForEach(manager.activities.filter { $0.key.lowercased().contains("sleep") }, id: \.key) { item in
//                    ActivityCard(activity: item.value)
//                        .onTapGesture {
//                            if let sleepSample = manager.selectedSleepSample {
//                                manager.selectedSleepSample = sleepSample
//                                isShowingDetails = true
//                            }
//                        }
//                }
//            }
//            .padding(.horizontal)
//        }
//        .onAppear() {
//            manager.fetchLastNightSleep()
//            manager.fetchLastNightSleepDetails()
//        }
//        .sheet(isPresented: $isShowingDetails) {
//            if let sleepSample = manager.selectedSleepSample {
//                SleepDetailsView(sleepSample: sleepSample)
//            }
//        }
//    }
//}
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    @State private var isShowingDetails = false

    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                ForEach(manager.activities.filter { $0.key.lowercased().contains("sleep") }, id: \.key) { item in
                    ActivityCard(activity: item.value)
                        .onTapGesture {
                            if let sleepSample = manager.selectedSleepSample {
                                manager.selectedSleepSample = sleepSample
                                isShowingDetails = true
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
        .onAppear() {
            manager.fetchLastNightSleep()
            manager.fetchLastNightSleepDetails()

            // Auto-present sleep details when available
            if let sleepSample = manager.selectedSleepSample {
                isShowingDetails = true
            }
        }
        .sheet(isPresented: $isShowingDetails) {
            if let sleepSample = manager.selectedSleepSample {
                SleepDetailsView(sleepSample: sleepSample)
            }
        }
    }
}


//#Preview {
//    HomeView()
//}






//
//import SwiftUI
//
//struct HomeView: View {
//    @EnvironmentObject var manager: HealthManager
//    var body: some View {
//        VStack{
//            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)){
//                ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id}), id: \.key) { item in ActivityCard(activity: item.value)
//
//                }
////                ActivityCard(activity: Activity(id: 0, title: "Last Night's Sleep", subtitle: "Goal: 8", image: "moon.zzz.fill", amount: "5"))
////
////                ActivityCard(activity: Activity(id: 0, title: "Last Night's Sleepp", subtitle: "Goal: 8", image: "moon.zzz.fill", amount: "5"))
//            }
//            .padding(.horizontal)
//        }
//        .onAppear(){
//            manager.fetchLastNightSleep()
//            manager.displayGSRData()
//        }
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//
//    }
//}




//
//import SwiftUI
//
//struct HomeView: View {
//    @EnvironmentObject var manager: HealthManager
//    @State private var isShowingDetails = false
//
//    var body: some View {
//        VStack {
//            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
//                ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
//                    ActivityCard(activity: item.value)
//                        .onTapGesture {
//                            if item.key == "lastNightSleep", let sleepSample = manager.selectedSleepSample {
//                                manager.selectedSleepSample = sleepSample
//                                isShowingDetails = true
//                            }
//                        }
//                }
//            }
//            .padding(.horizontal)
//        }
//        .onAppear() {
//            manager.fetchLastNightSleep()
//            manager.displayGSRData()
//            manager.fetchLastNightSleepDetails()
//        }
//        .sheet(isPresented: $isShowingDetails) {
//            if let sleepSample = manager.selectedSleepSample {
//                SleepDetailsView(sleepSample: sleepSample)
//            }
//        }
//    }
//}
//
//
