//
//  SearchResultCell.swift
//  OpenWeatherMVVMC
//
//  Created by Tạ Minh Quân on 14/08/2023.
//

import Foundation
import SwiftUI
import OpenWeatherBussinessLogic
import OpenWeatherDataAccess
import Kingfisher

struct SearchResultCell: View {
    let model: SearchResultCellModel
    let onTapped: Callback<SearchData>?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.cityName)
                    .font(.largeTitle)
                if let url = URL(string: model.displayIcon)  {
                    KFImage(url)
                        .frame(width: 60.0, height: 60.0)
                }
                Text(model.displayTempature)
                    .padding(5)
                Text(model.displayHumidity)
                    .padding(5)
                
            }
            .padding(20)
            Spacer()
        }
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .onTapGesture {
            onTapped?(model.data)
        }
        
    }
}

struct SearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultCell(model: .mock(), onTapped: nil)
    }
}


