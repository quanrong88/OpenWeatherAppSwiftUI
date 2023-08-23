//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 24/06/2023.
//

import Foundation
import Combine

public protocol Repository {
    func search(word: String) -> AnyPublisher<SearchData, AppError>
    func getForecast(lat: Double, lon: Double) -> AnyPublisher<WeatherForecastResponse, AppError>
}

public class WeatherRepository: Repository {
    let apiService: OpenWeatherService
    
    public init(apiService: OpenWeatherService) {
        self.apiService = apiService
    }
    
    public func search(word: String) -> AnyPublisher<SearchData, AppError> {
        guard word.count > 2 else {
            return Fail(error: AppError.locationNotFound).eraseToAnyPublisher()
        }
        return apiService.getLocation(q: word)
            .tryMap({ locations in
                guard let location = locations.first else {
                    throw AppError.locationNotFound
                }
                return location
            })
            .mapError { error in
                AppError.locationNotFound
            }
            .flatMap({ location in
                return self.apiService.getCurrentWeather(lat: location.lat, lon: location.lon)
                    .mapError{ AppError.network($0) }
                    .map { SearchData(location: location, current: $0) }
                    .eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
    
    public func getForecast(lat: Double, lon: Double) -> AnyPublisher<WeatherForecastResponse, AppError> {
        return apiService.getWeatherForecast(lat: lat, lon: lon)
            .mapError { AppError.network($0) }
            .eraseToAnyPublisher()
    }
}

public class MockRepository: Repository {
    public init() {}
    
    public func search(word: String) -> AnyPublisher<SearchData, AppError> {
        return Just(SearchData.mock1()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
    
    public func getForecast(lat: Double, lon: Double) -> AnyPublisher<WeatherForecastResponse, AppError> {
        return Just(WeatherForecastResponse.mock()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}
