//
//  MoodTracker.swift
//  BeautySleep
//
//  Created by Rowan Pansare on 12/4/23.
//

import SwiftUI
import Firebase

let username = "rowan"
var val : Int = 0

struct MoodTrackerView: View {
    var body: some View {
        VStack(spacing: 5){
            Text("Mood Tracking")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.bottom, 5)
            Spacer()
            Text("How are you feeling today?")
            HStack(spacing:2){
                MoodButton(label:"Awful")
                MoodButton(label:"Bad")
                MoodButton(label:"Neutral")
                MoodButton(label:"Good")
                MoodButton(label:"Great")
            }
            Text("How is your energy level?")
            HStack(spacing:2){
                MoodButton(label:"Awful")
                MoodButton(label:"Bad")
                MoodButton(label:"Neutral")
                MoodButton(label:"Good")
                MoodButton(label:"Great")
            }
            Text("How are your stress levels?")
            HStack(spacing:2){
                MoodButton(label:"Awful")
                MoodButton(label:"Bad")
                MoodButton(label:"Neutral")
                MoodButton(label:"Good")
                MoodButton(label:"Great")
            }
            Text("How ready are you for the tasks ahead of you?")
            HStack(spacing:2){
                MoodButton(label:"Awful")
                MoodButton(label:"Bad")
                MoodButton(label:"Neutral")
                MoodButton(label:"Good")
                MoodButton(label:"Great")
            }
            //"How would you describe your most recent tasks?"
            Text("What were your recent tasks like?")
            HStack(spacing:2){
                MoodButton(label:"Awful")
                MoodButton(label:"Bad")
                MoodButton(label:"Neutral")
                MoodButton(label:"Good")
                MoodButton(label:"Great")
            }
            Text("How would you rate your level of relaxation?")
            HStack(spacing:2){
                MoodButton(label:"Awful")
                MoodButton(label:"Bad")
                MoodButton(label:"Neutral")
                MoodButton(label:"Good")
                MoodButton(label:"Great")
            }
            Text("How well are you able to focus?")
            HStack(spacing:2){
                MoodButton(label:"Awful")
                MoodButton(label:"Bad")
                MoodButton(label:"Neutral")
                MoodButton(label:"Good")
                MoodButton(label:"Great")
            }
            Spacer()
            Button("Finished"){
                transmitData(username: username, val: val)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .fontWeight(.bold)
            .padding(.top, 5)
            Spacer()
        }
        .padding()
        .padding(.top, -5)
    }
}

struct MoodButton: View {
    var label : String
    var body: some View {
        Button(action: {
            if (label == "Awful") {val += 0}
            if (label == "Bad") {val += 1}
            if (label == "Neutral") {val += 2}
            if (label == "Good") {val += 3}
            if (label == "Great") {val += 4}
            
        }) {
            Text(label)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .font(.system(size:14))
        }
    }
}

func transmitData(username: String, val: Int) {
    var value : Double = Double(val)/7
    let db = Database.database().reference()

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    let formattedDate = dateFormatter.string(from: Date.now)
    print(formattedDate)

    let moodEntry: [String: Any] = [
        "value": value/7,
    ]

    let userPath = "/moodEntries/\(username)/\(formattedDate)"
    let childUpdates = [userPath: moodEntry]

    db.updateChildValues(childUpdates) { error, _ in
        if let error = error {
            print("Error adding entry to database: \(error)")
        } else {
            print("Entry added successfully!")
        }
    }

    print("data: \(value) transmitted for \(username) on date: \(formattedDate)")
}


//#Preview {
//    MoodTrackerView()
//}
//
