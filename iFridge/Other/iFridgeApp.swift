//
//  iFridgeApp.swift
//  iFridge
//
//  Created by 刘群 on 1/22/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct iFridgeApp: App {
    

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

