//
//  BeautySleepApp.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 17/11/2023.
//

import SwiftUI

@main
struct BeautySleepApp: App {
    @StateObject var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            BeautySleepTabView()
                .environmentObject(manager)
        }
    }
}
