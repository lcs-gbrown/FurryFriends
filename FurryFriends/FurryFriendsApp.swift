//
//  FurryFriendsApp.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

@main
struct FurryFriendsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                
                TabView {
                    PetView(petIsDog: false)
                        .tabItem {
                            Image(systemName: "pawprint.circle")
                        }
                    
                    PetView(petIsDog: true) 
                        .tabItem {
                            Image(systemName: "pawprint.circle.fill")
                        }
                    
                }
                
            }
        }
    }
}
