//
//  BeautySleepTabView.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 17/11/2023.
//
import SwiftUI
import HealthKit

struct BeautySleepTabView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"

    var body: some View {
        TabView(selection: $selectedTab) {
            // Directly show SleepDetailsView for the "Home" tab
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "moon.zzz.fill")
                }

//            LoginView()
//                .tag("Login")
//                .tabItem {
//                    Image(systemName: "person")
//                }

            GSRView()
                .tag("GSR")
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                }

            MoodTrackerView()
                .tag("MoodTracker")
                .tabItem {
                    Image(systemName: "smiley")
                }
        }
        .accentColor(.purple) 
    }

   
    private func defaultSleepSample() -> HKCategorySample {
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        return HKCategorySample(type: sleepType, value: HKCategoryValueSleepAnalysis.asleep.rawValue, start: Date(), end: Date())
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
