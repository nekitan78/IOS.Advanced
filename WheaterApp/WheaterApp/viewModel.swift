//
//  viewModel.swift
//  WheaterApp
//
//  Created by BMK on 03.04.2025.
import Foundation

struct WeatherData: Decodable {
    var location: Request
    var current: CurrentWeather
    var forecast: Forecast
    
    
    
    struct Forecast: Decodable {
        let forecastday: [Forecastday]
        
        
        struct Forecastday: Decodable {
            let date: String
            let day: Day
            
            struct Day: Decodable {
                let avgtemp_c: Double
                let condition: Cond
            }
            
            
        }
    }
    
    

    struct Request: Decodable {
        var name: String
    }
    
    struct CurrentWeather: Decodable {
        let condition:Cond
        let temp_c: Double
        let is_day: Int
    }
    
    struct Cond:Decodable{
        let icon: String
        let code: Int
    }
}



final class ViewModel: ObservableObject {
    
    @Published var weather: WeatherData?
    
    @Published var dictionary: [Int: [String]] = [
        1000: ["sun.max.fill", "moon.stars.fill"],
        1003: ["cloud.sun.fill", "cloud.moon.fill"],
        1006: ["cloud.fill", "cloud.moon.fill"],
        1009: ["cloud.fill", "cloud.moon.fill"],
        1030: ["cloud.fog.fill", "cloud.fog.fill"],
        1063: ["cloud.drizzle.fill", "cloud.drizzle.fill"],
        1066: ["cloud.snow.fill", "cloud.snow.fill"],
        1069: ["cloud.sleet.fill", "cloud.sleet.fill"],
        1072: ["cloud.sleet.fill", "cloud.sleet.fill"],
        1087: ["cloud.sun.bolt.fill", "cloud.moon.bolt.fill"],
        1114: ["wind.snow.fill", "wind.snow.fill"],
        1117: ["cloud.bolt.snow.fill", "cloud.bolt.snow.fill"],
        1135: ["cloud.fog.fill", "cloud.fog.fill"],
        1147: ["cloud.fog.fill", "cloud.fog.fill"],
        1150: ["cloud.sun.drizzle.fill", "cloud.moon.drizzle.fill"],
        1153: ["cloud.sun.drizzle.fill", "cloud.moon.drizzle.fill"],
        1168: ["thermometer.snowflake.fill", "thermometer.snowflake.fill"],
        1171: ["thermometer.snowflake.fill", "thermometer.snowflake.fill"],
        1180: ["cloud.sun.rain.fill", "cloud.moon.rain.fill"],
        1183: ["cloud.rain.fill.fill", "cloud.rain.fill"],
        1186: ["cloud.rain.fill", "cloud.rain.fill"],
        1189: ["cloud.rain.fill", "cloud.rain.fill"],
        1192: ["cloud.heavyrain.fill", "cloud.heavyrain.fill"],
        1195: ["cloud.heavyrain.fill", "cloud.heavyrain.fill"],
        1198: ["cloud.drizzle.fill", "cloud.drizzle.fill"],
        1201: ["cloud.sleet.fill", "cloud.sleet.fill"],
        1204: ["cloud.sleet.fill", "cloud.sleet.fill"],
        1207: ["cloud.sleet.fill", "cloud.sleet.fill"],
        1210: ["cloud.snow.fill", "cloud.snow.fill"],
        1213: ["cloud.snow.fill", "cloud.snow.fill"],
        1216: ["cloud.snow.fill", "cloud.snow.fill"],
        1219: ["cloud.snow.fill", "cloud.snow.fill"],
        1222: ["cloud.snow.fill", "cloud.snow.fill"],
        1225: ["cloud.snow.fill", "cloud.snow.fill"],
        1237: ["cloud.sleet.fill", "cloud.sleet.fill"],
        1240: ["cloud.sun.rain.fill", "cloud.moon.rain.fill"],
        1243: ["cloud.rain.fill", "cloud.rain.fill"],
        1246: ["cloud.heavyrain.fill", "cloud.heavyrain.fill"],
        1249: ["cloud.sleet.fill", "cloud.sleet.fill"],
        1252: ["cloud.sleet.fill", "cloud.sleet.fill"],
        1255: ["cloud.snow.fill", "cloud.snow.fill"],
        1258: ["cloud.snow.fill", "cloud.snow.fill"],
        1261: ["cloud.sleet.fill", "cloud.sleet.fill"],
        1264: ["cloud.sleet.fill", "cloud.sleet.fill"],
        1273: ["cloud.sun.bolt.fill", "cloud.moon.bolt.fill"],
        1276: ["cloud.rain.fill", "cloud.rain.fill"],
        1279: ["cloud.snow.fill", "cloud.snow.fill"],
        1282: ["cloud.snow.fill", "cloud.snow.fill"]
    ]
    
    
    func getData(for city: String) async throws {
        let urlString = "http://api.weatherapi.com/v1/forecast.json?key=bd9c0f098d904002a08112450251004&q=\(city)&days=7&aqi=no&alerts=no"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            
            await MainActor.run {
                self.weather = weatherData
            }
            
        }catch WeatherError.networkFailure{
            print("NetworkFailur")
        }
        
        
        
        
    }
    
    
    func getDayOfWeek(from dateString: String) -> String {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEE"
        
        
       
        if let date = dateFormatter.date(from: dateString) {
            return weekdayFormatter.string(from: date).uppercased()
        }
        
        return "???" // s
    }
}
enum WeatherError: Error {
    case invalidURL
    case networkFailure
}

