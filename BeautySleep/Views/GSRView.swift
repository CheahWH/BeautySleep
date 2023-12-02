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
import Charts

struct SleepData{
    let id : Int
    let time: Int
    let er: Int
}

var data : [SleepData] = [
    SleepData(id: 1, time: 5, er: 492),
    SleepData(id: 2, time: 4, er: 648),
    SleepData(id: 3, time: 3, er: 582),
    SleepData(id:4, time: 2, er: 436),
]

struct GSRView: View {
    var body: some View {
        Chart(data, id: \.id) {
                PointMark(
                    x: .value("Wing Length", $0.time),
                    y: .value("Wing Width", $0.er)
                )
            }
        .chartXAxisLabel("Time")
        .chartYAxisLabel("Resistence")
    }
}

struct GSRView_Previews: PreviewProvider {
    static var previews: some View {
        GSRView()
    }
}
