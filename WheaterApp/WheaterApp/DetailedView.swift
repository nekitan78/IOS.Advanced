import SwiftUI

struct DetailedView: View {
    let weather: WeatherData

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Detailed Info")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)

                Spacer()

                InfoCard(title: "💨 Wind kph", value: String(format: "%.2f", weather.current.wind_kph))
                InfoCard(title: "💧 Humidity", value: "\(weather.current.humidity)%")
                InfoCard(title: "🌫️ Visibility", value: "\(weather.current.vis_km) km")
                InfoCard(title: "☀️ UV Index", value: "\(weather.current.uv)")

                Spacer()
            }
            .padding()
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .font(.title2)
                .fontWeight(.medium)
        }
        .padding()
        .background(
            Material.ultraThin
        )
        .cornerRadius(20)
        .shadow(radius: 5)
        .foregroundColor(.white)
    }
}

