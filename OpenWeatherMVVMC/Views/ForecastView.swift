//
//  ForecastView.swift
//  OpenWeatherMVVMC
//
//  Created by Tạ Minh Quân on 04/06/2023.
//

import SwiftUI
import OpenWeatherBussinessLogic

struct ForecastView: View {
    @ObservedObject var viewModel: ForecastViewModel
    
    init(viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        self.viewModel.loadData()
    }
    
    var body: some View {
        List(viewModel.forecasts) { model in
            if #available(macOS 13.0, *) {
                ForecastItemView(cellModel: model, onTapped: { item in
                    viewModel.onSelect?(item)
                })
                    .listRowSeparator(.hidden)
            } else {
                ForecastItemView(cellModel: model, onTapped: { item in
                    viewModel.onSelect?(item)
                })
            }
        }
        .listStyle(.plain)
        .navigationTitle("5 days forecasts of \(viewModel.data.location.name)")
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(viewModel: .mock())
    }
}
