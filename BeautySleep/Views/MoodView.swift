//
//  MoodView.swift
//  BeautySleep
//
//  Created by Rowan Pansare on 12/6/23.
//

import SwiftUI
import Charts
import Firebase

struct MoodData : Identifiable {
    let id : Int
    let moodScore : CGFloat
    let day : Date
}

import Firebase

func readMoodData(completion: @escaping ([MoodData]?) -> Void) {
    
    let currentDate = Date()
    let lastMonth = Calendar.current.date(byAdding: .day, value: -30, to: currentDate)!
    
    let userID = "rowan"
    let ref = Database.database().reference(withPath: "moodEntries/\(userID)")

    var moodDataArray: [MoodData] = []

    // Iterate through the last 30 days
    for dayOffset in 0..<30 {
        let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: currentDate)!
        let year = String(format:"%02d", Calendar.current.component(.year, from: date))
        let month = String(format:"%02d", Calendar.current.component(.month, from: date))
        let day = String(format:"%02d", Calendar.current.component(.day, from: date))

        let dateString = "\(year)/\(month)/\(day)"

        // Construct the path to the mood entry for the specific date
        let dateRef = ref.child("\(year)/\(month)/\(day)")
        
        dateRef.observeSingleEvent(of: .value) { snapshot in
            if let moodDataDict = snapshot.value as? [String: Any],
               let moodValue = moodDataDict["value"] as? Double {
                let dataPoint = MoodData(id: dayOffset, moodScore: moodValue, day: date)
                moodDataArray.append(dataPoint)
                print(dataPoint.id, " ", dataPoint.moodScore)
            }
            // Check if we have collected data for the last 30 days
            if dayOffset == 29 {
                completion(moodDataArray)
                print("Data displayed")
            }
        }
    }
}



struct ChangeMoodView : View {
    @State private var loaded = false
    @State private var data: [MoodData] = []
    @Binding var changeScreen : Bool
    
    
    var body: some View {
        VStack {
            Text("Mood vs Sleep")
            Button(action: {
                changeScreen = true
            }) {
                Text("View GSR Data From Last Night")
            }
            
            if !loaded {
                Text("Loading data...")
                    .onAppear {
                        readMoodData { moodDataArray in
                            if let moodDataArray = moodDataArray {
                                self.data = Array(moodDataArray)
                            }
                            loaded = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                            print("loading")
                        }
                    }
            }else {
                MoodLineChart(data: data)
            }
        }
    }
}

struct MoodView: View {
    @State var changeScreen = false
    var body: some View {
        if changeScreen == true {
            GSRView()
        }
        else {
            ChangeMoodView(changeScreen: $changeScreen)
        }
    }
}

struct MoodLineChart: View {
    let data: [MoodData]
    
    var body: some View {
        if let firstDataPoint = data.first {
            let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: firstDataPoint.day ) ?? Date()
            
            Chart(data) {
                element in PointMark(
                    x: .value ("Date", element.day),
                    y: .value ("MoodScore", Double(element.moodScore))
                )
                LineMark(
                    x: .value ("Date", element.day),
                    y: .value ("MoodScore", Double(element.moodScore))
                )
            }
            .chartXAxisLabel("Date")
            .chartYAxisLabel("MoodScore")
            .chartXScale(domain:[thirtyDaysAgo, firstDataPoint.day])
            .chartYScale(domain:[0,5.0])
        }
    }
}


#Preview {
    MoodView()
}
