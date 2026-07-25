////
////  PlayHubApp.swift
////  PlayHub
////
////  Created by Amaya Mahavithane on 2026-07-06.
////
//

import SwiftUI

enum AppTab: Hashable {
    case home, stats, map, settings
}

@main
struct PlayHubApp: App {

    @State private var selectedTab: AppTab = .home

    var body: some Scene {

        WindowGroup {

            let _ = LocationService.shared
            let _ = NotificationService.shared
            
            TabView(selection: $selectedTab) {

                HomeTab()
                    .tag(AppTab.home)
                    .tabItem {
                        Label("Home",
                              systemImage: "house.fill")
                    }

                StatsTab(selectedTab: $selectedTab)
                    .tag(AppTab.stats)
                    .tabItem {
                        Label("Stats",
                              systemImage: "chart.bar.fill")
                    }

                MapTab()
                    .tag(AppTab.map)
                    .tabItem {
                        Label("Map",
                              systemImage: "map.fill")
                    }

                SettingsTab()
                    .tag(AppTab.settings)
                    .tabItem {
                        Label("Settings",
                              systemImage: "gearshape.fill")
                    }

            }

        }

    }

}
