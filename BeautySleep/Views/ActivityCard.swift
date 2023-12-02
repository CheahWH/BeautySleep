//
//  ActivityCard.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 17/11/2023.
//
//
import SwiftUI

struct Activity{
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
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            NavigationView{
                VStack(spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(activity.title)
                                .font(.system(size: 20))
                            
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
                    }
                }
                .padding()
                NavigationLink(destination: activity.view){
                    EmptyView()
                }
            }

        }
    }
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCard(activity: Activity(id: 0, title: "Last Night's Sleep", subtitle: "Goal: 8", image: "moon.zzz.fill", amount: "5", view: AnyView(HomeView())))
    }
}

