//
//  BeautySleepApp.swift
//  BeautySleep
//
//  Created by Cheah Wen Hui on 17/11/2023.
//
import SwiftUI
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore
import FirebaseDatabaseSwift
import FirebaseAuth
import FirebaseAppCheck


//initializes Firebase when the application starts
//main entry point for the app, configures Firebase and sets up the main SwiftUI 
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
    FirebaseApp.configure()
    return true
  }
    
}


@main
struct BeautySleepApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var manager = HealthManager()

    
    var body: some Scene {
        WindowGroup {
            BeautySleepTabView()
                .environmentObject(manager)
        }
    }

}
