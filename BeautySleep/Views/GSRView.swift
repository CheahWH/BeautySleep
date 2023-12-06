//
//  GSRView.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 29/11/2023.
//


//TODO:
//READ IN SENSOR DATA
//PLOT DATA IN CHART
import SwiftUI
import Firebase

let database = Database.database()

struct SleepData {
    let id: String
    let time: CGFloat
    let er: CGFloat
}

func readDataForPastDay(completion: @escaping ([SleepData]?) -> Void) {
    let currentDate = Date()
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy:MMdd:HHmm:ss"

    let ref = Database.database().reference(withPath: "LJ/data")

    // Start and end timestamps for the day
    let startTimestamp = dateFormatter.string(from: yesterday)
    let endTimestamp = dateFormatter.string(from: currentDate)

    // Adjust these values based on the desired chunk size
    let pageSize = 50
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

            for (timestamp, entry) in allData {
                print("Entry Timestamp: \(timestamp), Entry: \(entry)")

                if let er = entry["gsrAverage"] as? CGFloat,
                   let time = entry["timestamp"] as? CGFloat {

                    let sleepData = SleepData(id: timestamp, time: Double(time), er: Double(er))
                    sleepDataArray.append(sleepData)
                    print(sleepData)
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
    @State private var loaded = false
    @State private var data: [SleepData] = []
    
    var body: some View {
        VStack {
            if !loaded {
                Text("Loading data...")
                    .onAppear {
                        readDataForPastDay { sleepDataArray in
                            if let sleepDataArray = sleepDataArray {
                                self.data = Array(sleepDataArray.prefix(20))
                            }
                            loaded = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                            print("loading")
                        }
                    }
            }else {
                LineChart(data: data)
            }
        }
    }
}

    
    struct GSRView_Previews: PreviewProvider {
        static var previews: some View {
            GSRView()
        }
    }
    
//struct LineChart: View {
//    let data: [SleepData]
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let maxX = data.map(\.time).max() ?? 0
//            let maxY = data.map(\.er).max() ?? 0
//            
//            let xScale = maxX > 0 ? geometry.size.width / maxX : 0
//            let yScale = maxY > 0 ? geometry.size.height / maxY : 0
//            
//            // Y-axis
//            Path { path in
//                path.move(to: CGPoint(x: 30, y: 0))
//                path.addLine(to: CGPoint(x: 30, y: geometry.size.height - 20))
//            }
//            .stroke(lineWidth: 1)
//            .foregroundColor(.black)
//            
//            // X-axis
//            Path { path in
//                path.move(to: CGPoint(x: 30, y: geometry.size.height - 20))
//                path.addLine(to: CGPoint(x: geometry.size.width - 30, y: geometry.size.height - 20))
//            }
//            .stroke(lineWidth: 1)
//            .foregroundColor(.black)
//            
//            // Data points and labels
//            ForEach(data, id: \.id) { point in
//                let x = xScale * (point.time - data[0].time) + 30 // Adjust x position based on the first timestamp
//                let y = geometry.size.height - yScale * point.er - 20
//                
//                Path { path in
//                    path.addEllipse(in: CGRect(x: x - 5, y: y - 5, width: 10, height: 10))
//                }
//                .foregroundColor(.red)
//                
//                Text("\(Int(point.er))")
//                    .position(x: x, y: y - 20)
//            }
//            
//            // Y-axis labels
//            ForEach(1..<6, id: \.self) { i in
//                let y = yScale * CGFloat(i) * maxY / 5 - 20
//                Text("\(Double(y))")
//                    .position(x: 15, y: geometry.size.height - y)
//            }
//            
//            // X-axis labels (timestamps)
//            ForEach(data, id: \.id) { point in
//                let x = xScale * (point.time - data[0].time) + 30
//                Text("\(Int(point.time))")
//                    .position(x: x, y: geometry.size.height - 10)
//            }
//            
//            // Y-axis label
//            Text("Resistance (Units)")
//                .rotationEffect(.degrees(-90))
//                .position(x: -20, y: geometry.size.height / 2)
//            
//            // X-axis label
//            Text("Time (Seconds)")
//                .position(x: geometry.size.width / 2, y: geometry.size.height + 20)
//            
//            // Connecting lines
//            Path { path in
//                for (index, point) in data.enumerated() {
//                    let x = xScale * (point.time - data[0].time) + 30
//                    let y = geometry.size.height - yScale * point.er - 20
//                    
//                    if index == 0 {
//                        path.move(to: CGPoint(x: x, y: y))
//                    } else {
//                        path.addLine(to: CGPoint(x: x, y: y))
//                    }
//                }
//            }
//            .stroke(lineWidth: 2)
//            .foregroundColor(.blue)
//        }
//    }
//}

struct LineChart: View {
    var data: [SleepData]

    var body: some View {
        VStack {
            GeometryReader { geometry in
                Path { path in
                    for i in 0..<data.count {
                        let x = CGFloat(i) * (geometry.size.width / CGFloat(data.count - 1))
                        let y = CGFloat(data[i].er) * geometry.size.height
                        let point = CGPoint(x: x, y: y)
                        
                        if i == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
            .frame(height: 200)
        }
    }
}


    

