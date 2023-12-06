//
//  SleepDetailsView.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 01/12/2023.
//


import SwiftUI
import HealthKit

struct SleepDetailsView: View {
    let sleepSample: HKCategorySample
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    }

    var body: some View {
        VStack {
            Text("Sleep Details")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()

            HStack {
                Text("Start Date:")
                Spacer()
                Text("\(yesterday.startOfDay, formatter: dateFormatter)")
            }
            .padding()

            HStack {
                Text("End Date:")
                Spacer()
                Text("\(yesterday.endOfDay, formatter: dateFormatter)")
            }
            .padding()
            
            HStack {
                Text("Time In Bed:")
                Spacer()
                Text("\(totalTimeInBed())")
            }
            .padding()

            HStack {
                Text("REM Sleep Duration:")
                Spacer()
                Text("\(formattedHoursMinutes(from: durationInCategory(.inBed)))")
            }
            .padding()

            HStack {
                Text("Core Sleep Duration:")
                Spacer()
                Text("\(formattedHoursMinutes(from: durationInCategory(.asleep)))")
            }
            .padding()

            HStack {
                Text("Deep Sleep Duration:")
                Spacer()
                Text("\(formattedHoursMinutes(from: durationInCategory(.inBed)))")
            }
            .padding()

            Spacer()
        }
    }
    
    private func totalTimeInBed() -> String {
        let totalTimeInSeconds = sleepSample.endDate.timeIntervalSince(yesterday.startOfDay)
        return formattedHoursMinutes(from: totalTimeInSeconds)
    }

    private func durationInCategory(_ category: HKCategoryValueSleepAnalysis) -> TimeInterval {
        let healthStore = HKHealthStore()
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let predicate = HKQuery.predicateForSamples(withStart: yesterday.startOfDay, end: yesterday.endOfDay, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil else {
                print("Error fetching sleep data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let categorySamples = samples.filter { $0.value == category.rawValue }
            let duration = categorySamples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
            
            DispatchQueue.main.async {
                // Update UI or store the duration as needed
                print("Duration in \(category): \(duration) seconds")
            }
        }
        
        healthStore.execute(query)
        
        // Return a default value, as the actual duration will be fetched asynchronously
        return 0
    }

    private func formattedHoursMinutes(from seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: seconds) ?? "N/A"
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
}
