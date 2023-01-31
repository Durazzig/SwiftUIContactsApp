//
//  WeatherSubview.swift
//  calendar
//
//  Created by Tadeo Durazo on 30/01/23.
//

import SwiftUI

struct WeatherSubview: View {
    
    @StateObject var viewModel: WeatherViewModel
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
        } else {
            HStack {
                VStack {
                    HStack {
                        Spacer()
                        Image(uiImage: viewModel.weatherIconUrl.loadImage())
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipShape(Circle())
                        Spacer()
                    }
                    CustomLabel(title: "Weather", description: viewModel.weatherType)
                    CustomLabel(title: "City", description: viewModel.city)
                    CustomLabel(title: "Actual Temperature", description: "\(viewModel.temp)°")
                    CustomLabel(title: "Minimum Temperature", description: "\(viewModel.minTemp)°")
                    CustomLabel(title: "Maximum Temperature", description: "\(viewModel.maxTemp)°")
                    CustomLabel(title: "Feels Like", description: "\(viewModel.feelingTemp)°")
                }
            }
            .foregroundColor(Color.white)
            .background(Color.pink)
            .cornerRadius(15)
            .padding()
        }
    }
}
