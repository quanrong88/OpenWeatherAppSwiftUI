import XCTest
@testable import OpenWeatherBussinessLogic
import OpenWeatherDataAccess
import Combine

final class OpenWeatherBussinessLogicTests: XCTestCase {
    let repository = Repository(apiService: OpenWeatherService())
    var subscriptions = Set<AnyCancellable>()
    
    func testSearch() {
        let vm = MainViewModel(repository: repository)
        
        
        let exp = expectation(description: "Load API")
        vm.$searchResults
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { value in
                print(value)
                if !value.isEmpty {
                    exp.fulfill()
                }
            })
            .store(in: &subscriptions)
        
        vm.query = "hanoi"
        waitForExpectations(timeout: 5)
    }
}
