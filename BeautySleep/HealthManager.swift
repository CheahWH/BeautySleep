//
//  HealthManager.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 17/11/2023.
//
// HealthManager.swift
//

import Foundation
import HealthKit
import FirebaseDatabase
import SwiftUI

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthManager: ObservableObject {
    
    let database = Database.database().reference()
    @Published var activities: [String: Activity] = [:]
    let healthStore = HKHealthStore()
    @Published var selectedSleepSample: HKCategorySample?

    init() {
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        let healthTypes: Set<HKSampleType> = [sleepType]

        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print("Error fetching health data: \(error.localizedDescription)")
            }

        }
    }

    //track the last 36hours from NOW
    func fetchLastNightSleep() {
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        let startDate = Calendar.current.date(byAdding: .hour, value: -36, to: Date())!
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil else {
                print("Error fetching last night's sleep data")
                return
            }

            var totalSleepHours: Double = 0.0

            for sample in samples {
                let hours = sample.endDate.timeIntervalSince(sample.startDate) / 3600
                totalSleepHours += hours
            }
            
            let activity = Activity(id: 0, title: "Last Night's Sleep", subtitle: "Total:", image: "moon.stars", amount: totalSleepHours.formattedString(), view: AnyView(GSRView()))
            DispatchQueue.main.async {
                self.activities["lastNightSleep"] = activity
            }
        }

        healthStore.execute(query)
    }

    
    func fetchLastNightSleepDetails() {
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        let yesterdayStart = Calendar.current.date(byAdding: .day, value: -1, to: Date.startOfDay)!
        let yesterdayEnd = Date.startOfDay
        let predicate = HKQuery.predicateForSamples(withStart: yesterdayStart, end: yesterdayEnd)
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil else {
                print("Error fetching last night's sleep details")
                return
            }

            //display details for the first sample
            if let firstSample = samples.first {
                DispatchQueue.main.async {
                    self.selectedSleepSample = firstSample
                }
            }
        }

        healthStore.execute(query)
    }
}

extension Double {
    func formattedString() -> String {
        let hours = Int(self)
        let minutes = Int((self - Double(hours)) * 60)

        if hours > 0 {
            if minutes > 0 {
                return "\(hours)h \(minutes)m"
            } else {
                return "\(hours)h"
            }
        } else {
            return "\(minutes)m"
        }
    }
}



