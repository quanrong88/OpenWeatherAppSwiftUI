//
//  AppCoordinator.swift
//  OpenWeatherMVVMC
//
//  Created by Tạ Minh Quân on 23/07/2023.
//

import Foundation
import SwiftUI
import OpenWeatherBussinessLogic
import OpenWeatherDataAccess

final class AppCoordinator: ObservableObject {
    @Published var mainViewModel: MainViewModel
    @Published var forecastViewModel: ForecastViewModel?
    @Published var selectedForecast: OpenWeatherDataAccess.List?
    
    let repository = WeatherRepository(apiService: OpenWeatherService())
    
    init() {
        self.mainViewModel = MainViewModel(repository: repository)
        self.mainViewModel.selectedCell = { data in
            let viewModel = ForecastViewModel(repository: self.repository, data: data)
            viewModel.onSelect = { item in
                self.selectedForecast = item
            }
            self.forecastViewModel = viewModel
        }
    }
}

struct AppCoordinatorView: View {
    @StateObject var coordinator: AppCoordinator
    
    var body: some View {
        NavigationView {
            MainView(viewModel: coordinator.mainViewModel)
                .push(item: $coordinator.forecastViewModel, destination: { _ in
                    ForecastView(viewModel: self.coordinator.forecastViewModel!)
                        .present(item: $coordinator.selectedForecast) { item in
                            ForecastDetail(item: item)
                        }
                })
        }
        
    }
}

