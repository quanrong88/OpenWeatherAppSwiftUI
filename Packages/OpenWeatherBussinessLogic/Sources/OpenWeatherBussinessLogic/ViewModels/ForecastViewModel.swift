//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 29/06/2023.
//

import Foundation
import OpenWeatherDataAccess
import Combine

public class ForecastViewModel: ObservableObject {
    let repository: Repository
    public let data: SearchData
    
    @Published public var forecasts: [ForecastCellModel] = []
    @Published public var errorMessage: String = ""
    public var onSelect: Callback<OpenWeatherDataAccess.List>?
    
    var subscriptions = Set<AnyCancellable>()
    
    public init(repository: Repository, data: SearchData) {
        self.repository = repository
        self.data = data
    }
    
    public func loadData() {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm dd/MM/YYYY"
        repository.getForecast(lat: data.location.lat, lon: data.location.lon)
            .map { item -> [ForecastCellModel] in
                return item.list.map { element -> ForecastCellModel in
                    let displayTempature = "Tempature: \(element.main.temp)°C"
                    let diplayHumidity = "Humidity: \(element.main.humidity)%"
                    var iconImage  = ""
                    if let iconWeather = element.weather.first?.icon {
                        iconImage = "https://openweathermap.org/img/wn/\(iconWeather)@2x.png"
                    }
                    let date = Date(timeIntervalSince1970: TimeInterval(element.dt))
                    let dateString = dayTimePeriodFormatter.string(from: date)
                    return ForecastCellModel(displayTempature: displayTempature, displayHumidity: diplayHumidity, displayIcon: iconImage, displayDateTime: dateString, dtTxt: element.dtTxt, item: element)
                }
            }
            .sink { complete in
                if case .failure(let error) = complete {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { value in
                self.forecasts = value
            }
            .store(in: &subscriptions)
            
    }
}

public extension ForecastViewModel {
    static func mock() -> ForecastViewModel {
        let repo = MockRepository()
        let mock = ForecastViewModel(repository: repo, data: .mock())
        return mock
    }
}
