//
//  SwiftUIView.swift
//  WheaterApp
//
//  Created by BMK on 03.04.2025.
//
import SwiftUI

struct SwiftUIView: View {
    @StateObject var viewModel = ViewModel()
    @State var isNightMode: Bool = false
    @State private var selectedCity: String = "Almaty"
    let cities = ["Almaty", "Astana", "Shymkent", "Karaganda", "Aktobe"]
    var body: some View {
        
        let finalWeather = viewModel.weather
        let ourForecast = viewModel.weather?.forecast.forecastday
        
        NavigationStack{
            ZStack {
                LinearGradient(gradient: Gradient(colors: [isNightMode ? Color(red: 15/255, green: 15/255, blue: 30/255) :.blue, isNightMode ? Color.blue.opacity(0.5) :.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomLeading)
                    .ignoresSafeArea(.all)
                
                VStack {
                    HStack{
                        Menu {
                            ForEach(cities, id: \.self) { city in
                                Button(action: {
                                    selectedCity = city
                                    Task {
                                        try await viewModel.getData(for: city)
                                        isNightMode = (viewModel.weather?.current.is_day == 0)
                                    }
                                }) {
                                    Text(city)
                                }
                            }
                        } label: {
                            Text(selectedCity)
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: "chevron.down")
                    }
                    
                        
                    Spacer()
                    
                    VStack {
                        
                        Image(systemName: viewModel.dictionary[ finalWeather?.current.condition.code ?? 0]?[(finalWeather?.current.is_day) == 1 ? 0 : 1] ?? "cloud.fill")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                        
                        Text("\(String(format: "%.1f", finalWeather?.current.temp_c ?? 0))°C")
                            .padding(10)
                            .font(.system(size: 36, weight: .medium, design: .default))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            dayWheatherModel(day: viewModel.getDayOfWeek(from: ourForecast?[1].date ?? ""), image: viewModel.dictionary[ourForecast?[1].day.condition.code ?? 0]?.first ?? "cloud.fill", temperature: "\(ourForecast?[1].day.avgtemp_c ?? 0)°C")
                            dayWheatherModel(day: viewModel.getDayOfWeek(from: ourForecast?[2].date ?? ""), image: viewModel.dictionary[ourForecast?[2].day.condition.code ?? 0]?.first ?? "cloud.fill", temperature: "\(ourForecast?[2].day.avgtemp_c ?? 0)°C")
                            dayWheatherModel(day: viewModel.getDayOfWeek(from: ourForecast?[3].date ?? ""), image: viewModel.dictionary[ourForecast?[3].day.condition.code ?? 0]?.first ?? "cloud.fill", temperature: "\(ourForecast?[3].day.avgtemp_c ?? 0)°C")
                            dayWheatherModel(day: viewModel.getDayOfWeek(from: ourForecast?[4].date ?? ""), image: viewModel.dictionary[ourForecast?[4].day.condition.code ?? 0]?.first ?? "cloud.fill", temperature: "\(ourForecast?[4].day.avgtemp_c ?? 0)°C")
                            dayWheatherModel(day: viewModel.getDayOfWeek(from: ourForecast?[5].date ?? ""), image: viewModel.dictionary[ourForecast?[5].day.condition.code ?? 0]?.first ?? "cloud.fill", temperature: "\(ourForecast?[5].day.avgtemp_c ?? 0)°C")
                            dayWheatherModel(day: viewModel.getDayOfWeek(from: ourForecast?[6].date ?? ""), image: viewModel.dictionary[ourForecast?[6].day.condition.code ?? 0]?.first ?? "cloud.fill", temperature: "\(ourForecast?[6].day.avgtemp_c ?? 0)°C")
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    if let weather = viewModel.weather {
                        NavigationLink(destination: DetailedView(weather: weather)) {
                            Text("Detailed Info")
                                .frame(width : 220, height: 40)
                                .foregroundStyle(Color(.white))
                                .background(.green)
                                .cornerRadius(10)
                        }
                    }

                    
                    Spacer()
                    
                   
                }
            }.onAppear {
                Task {
                    try await viewModel.getData(for: selectedCity)
                    isNightMode = (viewModel.weather?.current.is_day == 0)
                }
            }
        }

        }
        
}

struct dayWheatherModel: View {
    let day: String
    let image: String
    let temperature: String
    
    var body: some View {
        VStack {
            Text(day)
                .padding(3)
                .font(.system(size: 20, weight: .light, design: .default))
                .foregroundStyle(.white)
            
            Image(systemName: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                
            Text(temperature)
                .padding(3)
                .font(.system(size: 18, weight: .medium, design: .default))
                .foregroundStyle(.white)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    SwiftUIView()
}
