//
//  HomeView.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 17/11/2023.
//



import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    @State private var isShowingDetails = false

    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id}), id: \.key) { item in
                    ActivityCard(activity: item.value)
                        .onTapGesture {
                            if item.key == "lastNightSleep", let sleepSample = manager.selectedSleepSample {
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
            manager.displayGSRData()
            manager.fetchLastNightSleepDetails()
        }

        .sheet(isPresented: $isShowingDetails) {
            if let sleepSample = manager.selectedSleepSample {
                SleepDetailsView(sleepSample: sleepSample)
            }
            if let sleepSample = manager.selectedSleepSample {
                SleepDetailsView(sleepSample: sleepSample)
            }
        }
    }
}




//#Preview {
//    HomeView()
//}
