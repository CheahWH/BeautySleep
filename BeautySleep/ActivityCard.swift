//
//  ActivityCard.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 17/11/2023.
//
//
import SwiftUI

struct Activity {
    let id: Int
    let title: String
    let subtitle: String
    let image: String?
    let amount: String?
    let view: AnyView?
}

struct ActivityCard: View {
    @State var viewPressed: Bool = false
    @State var activity: Activity
    
    var body: some View {
        NavigationLink(destination: activity.view) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(uiColor: .systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(titleColor(), lineWidth: 2)  // Set border color based on title
                    )
                
                VStack(spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(activity.title)
                                .font(.system(size: 20))
                                .foregroundColor(titleColor())  // Set text color based on title
                            
                            Text(activity.subtitle)
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        if let imageName = activity.image {
                            Image(systemName: imageName)
                                .foregroundColor(.purple)
                        }
                    }
                    
                    if let amount = activity.amount {
                        Text(amount)
                            .font(.system(size: 24))
                            .foregroundColor(activity.title == "Last Night's Sleep" ? .white : .black)
                    }
                }
                .padding()
            }
        }
    }
    
    private func titleColor() -> Color {
        switch activity.title {
        case "Last Night's Sleep", "GSR Data":
            return .purple  // Set color to purple
        default:
            return .black
        }
    }
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCard(activity: Activity(id: 0, title: "Last Night's Sleep", subtitle: "Goal: 8", image: "moon.zzz.fill", amount: "5", view: AnyView(HomeView())))
    }
}
