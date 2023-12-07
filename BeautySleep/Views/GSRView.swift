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
                    if (Double(er) > 750.0 || Double(er) < 600.0){
                        print(time)
                        print (sleepData)
                    }
                    sleepDataArray.append(sleepData)
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
                                self.data = Array(sleepDataArray)
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
    
struct LineChart: View {
    let data: [SleepData]
    var body: some View {
        Chart(data) {
            element in PointMark(
                x: .value ("Time", Double(element.time)),
                y: .value ("Average GSR", Double(element.er))
            )
            LineMark(
                x: .value ("Time", Double(element.time)),
                y: .value ("Average GSR", Double(element.er))
            )
        }
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


    

