//
//  MoodTracker.swift
//  BeautySleep
//
//  Created by Rowan Pansare on 12/4/23.
//

import SwiftUI
import Firebase

struct MoodTracker: View {
    var body: some View {
        VStack(spacing: 10){
            Text("Mood Tracking")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
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
            Text("How would you describe your most recent tasks?")
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
                
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .fontWeight(.bold)
            Spacer()
        }
    }
}

struct MoodButton: View {
    var label : String
    var body: some View {
        Button(action: {
            var val : Int
            val = 0
            if (label == "Awful") {val = 0}
            if (label == "Bad") {val = 1}
            if (label == "Neutral") {val = 2}
            if (label == "Good") {val = 3}
            if (label == "Great") {val = 4}
            transmitData(val: val,date : Date.now)
        }) {
            Text(label)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .font(.system(size:14))
        }
    }
}

func transmitData(val : Int, date : Date){
    let db = Firestore.firestore()
    let moodEntry: [String:Any] = [
            "value": val,
            "date": date
        ]
    
    db.collection("moodEntries").addDocument(data: moodEntry) { error in
        if let error = error {
            print("Error adding document: \(error)")
        } else {
            print("Document added successfully!")
        }
    }

    print("data: " , val , " transmitted on date: " , date)
}

#Preview {
    MoodTracker()
}
