//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 18/06/2023.
//

import Foundation
import OpenWeatherDataAccess
import Combine

public class MainViewModel: ObservableObject {
    let repository: Repository
    
    @Published public var query: String = ""
    
    @Published public var searchResults: [SearchResultCellModel] = []
    @Published public var errorMessage: String = ""
    public var selectedCell: Callback<SearchData>?
    
    var subscriptions = Set<AnyCancellable>()
    
    public init(repository: Repository) {
        self.repository = repository
        
        $query
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .flatMap { word in
                self.repository.search(word: word)
                    .replaceError(with: SearchData.mock())
            }
            .map { data in
                SearchResultCellModel(data: data)
            }
            .sink { complete in
                if case .failure(let error) = complete {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { result in
                if result.data.location.lat == 0 && result.data.location.lon == 0 {
                    self.searchResults = []
                } else {
                    self.searchResults = [result]
                }
                
            }
            .store(in: &subscriptions)
    }
}

public extension MainViewModel {
    static func mock() -> MainViewModel {
        let repo = MockRepository()
        let mock = MainViewModel(repository: repo)
        return mock
    }
}
