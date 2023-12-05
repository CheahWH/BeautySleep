//
//  MyAppCheckProviderFactory.swift
//  BeautySleep
//
//  Created by Rowan Pansare on 12/4/23.
//

import Firebase

class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    #if targetEnvironment(simulator)
      // App Attest is not available on simulators.
      // Use a debug provider.
      return AppCheckDebugProvider(app: app)
    #else
      // Use App Attest provider on real devices.
      return AppAttestProvider(app: app)
    #endif
  }
}
