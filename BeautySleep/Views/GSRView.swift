//
//  GSRView.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 29/11/2023.
//




import SwiftUI
import Firebase
import Charts


let database = Database.database()

struct SleepData: Identifiable {
    let id: String
    let time: Date
    let er: CGFloat
}


func readDataForPastDay(completion: @escaping ([SleepData]?) -> Void) {
    
//    let currentDate = Date()
    let currentDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!


    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy:MMdd:HHmm:ss"

    let ref = Database.database().reference(withPath: "LJ/data")

    // Start and end timestamps for the day
    let startTimestamp = dateFormatter.string(from: yesterday)
    let endTimestamp = dateFormatter.string(from: currentDate)

    // Adjust these values based on the desired chunk size
    let pageSize = 10000000
    var currentPage = 0

    // Function to fetch data for the current page
    func fetchDataForPage(page: Int, completion: @escaping ([SleepData]?) -> Void) {
        let query = ref.queryOrderedByKey()
            .queryStarting(atValue: startTimestamp)
            .queryEnding(atValue: endTimestamp)
            .queryLimited(toFirst: UInt(pageSize * (page + 1)))  // Adjust limit based on page size

        query.observeSingleEvent(of: .value, with: { snapshot in
            guard let allData = snapshot.value as? [String: [String: Any]] else {
                print("No data found for the past day")
                completion(nil)
                return
            }

            var sleepDataArray: [SleepData] = []
            var counter = 0

            for (timestamp, entry) in allData {
                counter += 1
//                print("Entry Timestamp: \(timestamp), Entry: \(entry)")
                
                if let er = entry["gsrAverage"] as? CGFloat{
                    
                    if let date = dateFormatter.date(from: timestamp) {

                        let sleepData = SleepData(id: timestamp, time: date, er: Double(er))
                        if (Double(er) > 750.0 || Double(er) < 600.0){
//                            print(time)
//                            print (sleepData)
                        }
                        if (counter % 15 == 0) {sleepDataArray.append(sleepData)
                        }
                    }
                }
            }

            completion(sleepDataArray)
            print("data displayed")
        }) { error in
            print("Error reading data:", error.localizedDescription)
            completion(nil)
        }
    }

    // Fetch the first page
    fetchDataForPage(page: currentPage) { sleepDataArray in
        if let sleepDataArray = sleepDataArray {
            completion(sleepDataArray)
        } else {
            completion(nil)
        }
    }
}

struct GSRView: View {
    @State var changeScreen = false
    var body: some View {
        if changeScreen == true {
            MoodView()
        }
        else {
            ChangeGSRView(changeScreen: $changeScreen)
        }
    }
}


struct ChangeGSRView: View {
    @State private var loaded = false
    @State private var data: [SleepData] = []
    @Binding var changeScreen : Bool
    
    var body: some View {
        VStack {
            Text("GSR Data From Last Night")
            Button(action: {
                changeScreen = true
            }) {
                Text("View Mood vs Sleep")
            }
            if !loaded {
                Text("Loading data...")
                    .onAppear {
                        readDataForPastDay { sleepDataArray in
                            if let sleepDataArray = sleepDataArray {
                                self.data = Array(sleepDataArray)
                            }
                            loaded = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                            print("loading")
                        }
                    }
            }else {
                GSRLineChart(data: data)
            }
        }
    }
}

    
    struct GSRView_Previews: PreviewProvider {
        static var previews: some View {
            GSRView()
        }
    }
    
//struct GSRLineChart: View {
//    let data: [SleepData]
//
//    var body: some View {
//        let firstDataPoint = data.first
//        let startOfDay = Calendar.current.startOfDay(for: firstDataPoint?.time ?? Date())
//        
//        let minX = Double((data.min { $0.time < $1.time }?.time.timeIntervalSince(startOfDay) ?? 0) / 3600.0)
//        let maxX = Double((data.max { $0.time < $1.time }?.time.timeIntervalSince(startOfDay) ?? 0) / 3600.0)
//        let minY = Double(data.min { $0.er < $1.er }?.er ?? 0)
//        let maxY = Double(data.max { $0.er < $1.er }?.er ?? 1)
//
//        return Chart(data) { element in
//            let timeSinceMidnight = element.time.timeIntervalSince(startOfDay) / 3600.0
//            PointMark(
//                x: .value("Time", Double(timeSinceMidnight)),
//                y: .value("Average GSR", Double(element.er))
//            )
//            .symbolSize(10)
//        }
//        .chartXAxisLabel("Time (Hours)")
//        .chartYAxisLabel("GSR Data")
//        .chartXScale(domain: [0,24])
//        .chartYScale(domain: [minY - 100, maxY + 100])
//    }
//}

struct GSRLineChart: View {
    let data: [SleepData]

    var body: some View {
        let firstDataPoint = data.first
        let startOfDay = Calendar.current.startOfDay(for: firstDataPoint?.time ?? Date())

        let minX = data.min { $0.time < $1.time }?.time.timeIntervalSince(startOfDay) ?? 0
        let maxX = data.max { $0.time < $1.time }?.time.timeIntervalSince(startOfDay) ?? 0
        let minY = Double(data.min { $0.er < $1.er }?.er ?? 0)
        let maxY = Double(data.max { $0.er < $1.er }?.er ?? 1)

        return Chart(data) { element in
//            let timeSinceMidnight = element.time.timeIntervalSince(startOfDay)
            PointMark(
                x: .value("Time", element.time),
                y: .value("Average GSR", Double(element.er))
            )
            .symbolSize(10)
        }
        .chartXAxisLabel("Time")
        .chartYAxisLabel("GSR Data")
        .chartXScale(domain: [startOfDay, startOfDay.endOfDay])
        .chartYScale(domain: [minY - 100, maxY + 100])
    }
}














//struct LineChart: View {
//    var data: [SleepData]
//
//    var body: some View {
//        VStack {
//            GeometryReader { geometry in
//                Path { path in
//                    for i in 0..<data.count {
//                        let x = CGFloat(i) * (geometry.size.width / CGFloat(data.count - 1))
//                        let y = CGFloat(data[i].er) * geometry.size.height
//                        let point = CGPoint(x: x, y: y)
//                        
//                        if i == 0 {
//                            path.move(to: point)
//                        } else {
//                            path.addLine(to: point)
//                        }
//                    }
//                }
//                .stroke(Color.blue, lineWidth: 2)
//            }
//            .frame(height: 200)
//        }
//    }
//}


    

