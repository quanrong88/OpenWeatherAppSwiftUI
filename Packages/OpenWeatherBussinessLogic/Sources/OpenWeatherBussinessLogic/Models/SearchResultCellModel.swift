//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 21/06/2023.
//

import Foundation
import OpenWeatherDataAccess

public struct SearchResultCellModel: Identifiable, Hashable {
    public static func == (lhs: SearchResultCellModel, rhs: SearchResultCellModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public let displayTempature: String
    public let displayHumidity: String
    public let displayIcon: String
    public let cityName: String
    public let data: SearchData
    public let id: UUID
    
    init(data: SearchData) {
        self.id = UUID()
        self.displayTempature = "Tempature: \(data.current.main.temp)°C"
        self.displayHumidity = "Humidity: \(data.current.main.humidity)%"
        self.displayIcon = "https://openweathermap.org/img/wn/\(data.current.weather.first?.icon ?? "")@2x.png"
        self.cityName = "\(data.location.name), \(data.location.country)"
        self.data = data
    }
    
    public static func mock() -> SearchResultCellModel {
        return SearchResultCellModel(data: .mock())
    }
    
    public var hashValue: Int {
        id.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
