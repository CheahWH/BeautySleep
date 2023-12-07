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
    let id : String
    let moodScore : CGFloat
    let day : Date
}

func readMoodData(completion: @escaping ([MoodData]?) -> Void) {
    let currentDate = Date()
    let lastMonth = Calendar.current.date(byAdding: .day, value: -30, to: currentDate)!
    let ref = Database.database().reference(withPath: "moodEntries/rowan")
    

    // Adjust these values based on the desired chunk size
    let pageSize = 50
    var currentPage = 0
    
    var moodDataArray: [MoodData] = []
    let dataPoint = MoodData(id: "rowan", moodScore: 3.0, day:Date())
    moodDataArray.append(dataPoint)
    
    completion(moodDataArray)
    print("data displayed")

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
            .chartXScale(domain:[thirtyDaysAgo, firstDataPoint.day])
            .chartYScale(domain:[0,5.0])
        }
    }
}


#Preview {
    MoodView()
}
