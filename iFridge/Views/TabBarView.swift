//
//  MyFridgeView.swift
//  iFridge
//
//  Created by 刘群 on 1/25/25.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Int = 0
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        if isLoggedIn{
            
            
            TabView(selection: $selectedTab) {
                
                MainPageView()
                    .tabItem {
                        Label("MyFridge", systemImage: "house.fill")
                    }
                    .tag(0)
                
                NavigationView {
                    RecipeView()
                }
                .tabItem {
                    Label("Recipe", systemImage: "heart.fill")
                }
                .tag(1)
                
                NavigationView {
                    ProfileView(isLoggedIn: $isLoggedIn)
                }
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
            }
        }else{
            LoginView(isLoggedIn: $isLoggedIn)
        }
        
    }
}
