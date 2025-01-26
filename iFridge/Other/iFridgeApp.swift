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
    
    @State private var isLoggedIn: Bool = false
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        
        WindowGroup {
            
            if isLoggedIn {
                MainPageView()
            } else {
                //MainPageView()
                LoginView(isLoggedIn: $isLoggedIn)
            }
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

