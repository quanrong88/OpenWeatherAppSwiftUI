//
//  ForecastDetail.swift
//  OpenWeatherMVVMC
//
//  Created by Tạ Minh Quân on 04/06/2023.
//

import SwiftUI
import OpenWeatherDataAccess
import Kingfisher

struct ForecastDetail: View {
    @Environment(\.presentationMode) var presentationMode
    let item: OpenWeatherDataAccess.List
    
    
    var body: some View {
        VStack {
            Text(item.weather.first?.description.capitalized ?? "")
                .font(.title)
            Text("Time: \(item.dtTxt)")
                .font(.subheadline)
            if let url = URL(string: "https://openweathermap.org/img/wn/\(item.weather.first?.icon ?? "")@2x.png") {
                KFImage(url)
                    .frame(width: 100.0, height: 100.0)
                    .padding([.leading, .trailing], 20)
            }
            VStack(alignment: .leading) {
                Text("Tempature max: \(item.main.tempMax)")
                    .padding(10)
                Text("Tempature min: \(item.main.tempMin)")
                    .padding(10)
                Text("Tempature feel like: \(item.main.feelsLike)")
                    .padding(10)
            }
            
            
            
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Dismiss")
            }
            
        }
        .frame(width: 600, height: 500)
        .padding()
        
    }
}

struct ForecastDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        ForecastDetail(item: .mock())
    }
}
