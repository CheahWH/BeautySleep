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

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthManager: ObservableObject {
    @Published var activities: [String: Activity] = [:]
    let healthStore = HKHealthStore()

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

    func fetchLastNightSleep() {
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!

        // Define the date range for last night
        let yesterdayStart = Calendar.current.date(byAdding: .day, value: -1, to: Date.startOfDay)!
        let yesterdayEnd = Date.startOfDay

        // Predicate for samples within the last night
        let predicate = HKQuery.predicateForSamples(withStart: yesterdayStart, end: yesterdayEnd)
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

            let activity = Activity(id: 0, title: "Last Night's Sleep", subtitle: "", image: "moon.stars", amount: totalSleepHours.formattedString())
            DispatchQueue.main.async {
                self.activities["lastNightSleep"] = activity
            }

            print(totalSleepHours.formattedString())
        }

        healthStore.execute(query)
    }
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2

        if let formattedValue = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedValue
        } else {
            return "N/A" // You can provide a default value or handle this case accordingly
        }
    }
}



/* //source code
import Foundation
import HealthKit

extension Date{
    static var startOfDay: Date{
        Calendar.current.startOfDay(for: Date())
    }
}
class HealthManager: ObservableObject{
 @Published var activities: [String: Activity] = [:]
    let healthStore = HKHealthStore()
    init(){
        let steps = HKQuantity(.stepCount)
        let healthTypes = Set = [steps]
        Task{
            do{
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            }catch{
                print("error fetching health data! :(")
            }
        }
    }
    func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
        //let health kit know what day we seaching for
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate){_, result, error in guard let quantity = result?.sumQuantity(), error == nil else{
                print("error fetching todays sleep data")
                return
            }
            let stepCount = quantity.doubleValue(for: .count())
            //step to be first index 0, calorie to be index 1
            let activity = Activity(id: 0, title: "Today steps", subtitle: "Goal 10,000 ", image: "figure.walk", amount: stepCount.formattedString())
            DispatchQueue.main.async{
                self.activities["todaySteps"] = activity
            }
            print(stepCount.formattedString())
        }
        healthStore.execute(query)
    }
}
extension Double{
    func formattedString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
*/
