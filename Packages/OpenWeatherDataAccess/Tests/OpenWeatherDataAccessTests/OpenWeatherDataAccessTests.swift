import XCTest
@testable import OpenWeatherDataAccess
import Combine
import Moya


final class OpenWeatherDataAccessTests: XCTestCase {
    let apiService = OpenWeatherService()
    var subscriptions = Set<AnyCancellable>()
    
    enum TestError: Error {
        case locationNotFound
        case network(Error)
    }
    
    
    
    func testLoadLocation() {
        let exp = expectation(description: "Load API")
        var searchDebouncer = CurrentValueSubject<String, Never>("Ha noi")
        //
        searchDebouncer
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .first()
            .flatMap({ word in
                self.apiService.getLocation(q: word)
            })
        
//            .print("[Debug]")
            .mapError{ TestError.network($0) }
//            .print("[Debug]")
            .tryMap({ locations in
                guard let location = locations.first else {
                    throw TestError.locationNotFound
                }
                return location
            })
            .print("[Debug]")
            .flatMap({ location in
                return self.apiService.getCurrentWeather(lat: location.lat, lon: location.lon, unit: .standard).mapError{ TestError.network($0) }
            })

            .print("[Debug]")
            .sink { _ in
                print("Complete")
                exp.fulfill()
            } receiveValue: { value in
                print(value)
            }
            .store(in: &subscriptions)
            
        waitForExpectations(timeout: 5)
        
        searchDebouncer.send("hanoi")
    }
    
    func testLoadWeatherForecast() {
        let exp = expectation(description: "Load API")
        apiService.getWeatherForecast(lat: 21.0294498, lon: 105.8544441)
            .sink { _ in
                print("Complete")
                exp.fulfill()
            } receiveValue: { value in
                print(value)
            }
            .store(in: &subscriptions)
        waitForExpectations(timeout: 5)
    }
    
    func testSearch() {
        let exp = expectation(description: "Load API")
        apiService.getLocation(q: "hanoi")
            .mapError{ TestError.network($0) }
            .tryMap({ locations in
                guard let location = locations.first else {
                    throw TestError.locationNotFound
                }
                return location
            })
            .print("[Debug]")
            .flatMap({ location in
                return self.apiService.getCurrentWeather(lat: location.lat, lon: location.lon, unit: .standard)
                    .mapError{ TestError.network($0) }
                    .map { SearchData(location: location, current: $0) }
            })
            
            .print("[Debug]")
            .sink { _ in
                print("Complete")
                exp.fulfill()
            } receiveValue: { value in
                print(value)
            }
            .store(in: &subscriptions)
        waitForExpectations(timeout: 5)
    }
    
    func testRepo() {
        let repository = Repository(apiService: apiService)
        let exp = expectation(description: "Load API")
        repository.search(word: "ha")
            .sink { _ in
                exp.fulfill()
            } receiveValue: { data in
                print(data)
            }
            .store(in: &subscriptions)
        waitForExpectations(timeout: 5)
    }
}

