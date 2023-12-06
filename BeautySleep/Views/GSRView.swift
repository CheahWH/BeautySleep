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

struct SleepData {
    let id: Int
    let time: CGFloat
    let er: CGFloat
}

var data: [SleepData] = [
    SleepData(id: 1, time: 1, er: 492),
    SleepData(id: 2, time: 2, er: 648),
    SleepData(id: 3, time: 3, er: 582),
    SleepData(id: 4, time: 4, er: 436),
    SleepData(id: 5, time: 5, er: 436),
    SleepData(id: 6, time: 6, er: 500),
    SleepData(id: 7, time: 7, er: 300),
    SleepData(id: 8, time: 8, er: 212),
    SleepData(id: 9, time: 9, er: 250),
    SleepData(id: 10, time: 10, er: 190),
]

struct GSRView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack{
                Spacer()
                LineChart(data: data)
                    .padding()
                    .frame(width: 350, height: 700)
                Spacer()
            }
            Spacer()
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
        GeometryReader { geometry in
            let maxX = data.map(\.time).max() ?? 0
            let maxY = data.map(\.er).max() ?? 0

            let xScale = geometry.size.width / maxX
            let yScale = geometry.size.height / maxY

            // Y-axis
            Path { path in
                path.move(to: CGPoint(x: 30, y: 0))
                path.addLine(to: CGPoint(x: 30, y: geometry.size.height - 20))
            }
            .stroke(lineWidth: 1)
            .foregroundColor(.black)

            // X-axis
            Path { path in
                path.move(to: CGPoint(x: 30, y: geometry.size.height - 20))
                path.addLine(to: CGPoint(x: geometry.size.width - 30, y: geometry.size.height - 20))
            }
            .stroke(lineWidth: 1)
            .foregroundColor(.black)

            // Data points and labels
            ForEach(data, id: \.id) { point in
                let x = xScale * point.time + 30
                let y = geometry.size.height - yScale * point.er - 20

                Path { path in
                    path.addEllipse(in: CGRect(x: x - 5, y: y - 5, width: 10, height: 10))
                }
                .foregroundColor(.red)

                Text("\(Int(point.er))")
                    .position(x: x, y: y - 20)
            }

            // Y-axis labels
            ForEach(1..<6, id: \.self) { i in
                let y = yScale * CGFloat(i) * maxY / 5 - 20
                Text("\(Int(y))")
                    .position(x: 15, y: geometry.size.height - y)
            }

            // X-axis labels
            ForEach(1..<Int(maxX) + 1, id: \.self) { i in
                let x = xScale * CGFloat(i) + 30
                Text("\(i)")
                    .position(x: x, y: geometry.size.height - 10)
            }

            // Y-axis label
            Text("Resistance (Units)")
                .rotationEffect(.degrees(-90))
                .position(x: -20, y: geometry.size.height / 2)

            // X-axis label
            Text("Time (Seconds)")
                .position(x: geometry.size.width / 2, y: geometry.size.height + 20)

            // Connecting lines
            Path { path in
                for (index, point) in data.enumerated() {
                    let x = xScale * point.time + 30
                    let y = geometry.size.height - yScale * point.er - 20

                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(lineWidth: 2)
            .foregroundColor(.blue)
        }
    }
}

