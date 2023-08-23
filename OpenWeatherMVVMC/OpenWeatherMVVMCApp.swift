//
//  OpenWeatherMVVMCApp.swift
//  OpenWeatherMVVMC
//
//  Created by Tạ Minh Quân on 03/06/2023.
//

import SwiftUI
import OpenWeatherDataAccess
let service = OpenWeatherService()

@main
struct OpenWeatherMVVMCApp: App {
    @StateObject var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
//            MainView(viewModel: .mock())
//            ContentView()
            AppCoordinatorView(coordinator: appCoordinator)
        }
    }
}
