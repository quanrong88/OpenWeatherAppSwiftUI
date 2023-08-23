//
//  MainView.swift
//  OpenWeatherMVVMC
//
//  Created by Tạ Minh Quân on 24/07/2023.
//

import SwiftUI
import Kingfisher
import OpenWeatherBussinessLogic

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        List(viewModel.searchResults, id: \.id) { item in
            if #available(macOS 13.0, *) {
                SearchResultCell(model: item, onTapped: { data in
                    viewModel.selectedCell?(data)
                })
                .listRowSeparator(.hidden)
            } else {
                SearchResultCell(model: item, onTapped: { data in
                    viewModel.selectedCell?(data)
                })
            }
        }
        .listStyle(.plain)
        .navigationTitle("Open weather")
        .searchable(
            text: $viewModel.query,
            placement: .toolbar,
            prompt: "Type something..."
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: .mock())
    }
}
