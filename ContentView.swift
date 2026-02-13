//
//  ContentView.swift
//  2026_12_02_ButtonsWithAnimationSymbols-Spampinato
//
//  Enhanced by Carlo - Discord Extra Credit Edition
//

import SwiftUI

// MARK: - Weather Data Model
struct WeatherState {
    let image: String
    let message: String
    let temp: Int
    let gradient: [Color]
    let windSpeed: Int
    let humidity: Int
    let uvIndex: Int
    let particleType: ParticleType
}

enum ParticleType {
    case none, rain, snow, lightning, fog, sunRays
}

// MARK: - Content View
struct ContentView: View {
    @State private var weatherIndex: Int = 0
    @State private var isAnimating = false

    let weatherStates: [WeatherState] = [
        WeatherState(
            image: "sun.max.fill", message: "Perfect sunny day ahead!", temp: 75,
            gradient: [Color(red: 1.0, green: 0.6, blue: 0.2), Color(red: 1.0, green: 0.85, blue: 0.35)],
            windSpeed: 5, humidity: 30, uvIndex: 8, particleType: .sunRays
        ),
        WeatherState(
            image: "cloud.sun.fill", message: "Partly cloudy skies", temp: 68,
            gradient: [Color(red: 0.35, green: 0.55, blue: 0.85), Color(red: 0.45, green: 0.8, blue: 0.95)],
            windSpeed: 12, humidity: 45, uvIndex: 5, particleType: .none
        ),
        WeatherState(
            image: "cloud.rain.fill", message: "Rainy day — grab an umbrella!", temp: 58,
            gradient: [Color(red: 0.3, green: 0.35, blue: 0.5), Color(red: 0.25, green: 0.4, blue: 0.65)],
            windSpeed: 18, humidity: 82, uvIndex: 1, particleType: .rain
        ),
        WeatherState(
            image: "cloud.bolt.rain.fill", message: "Thunderstorms expected!", temp: 62,
            gradient: [Color(red: 0.2, green: 0.15, blue: 0.35), Color(red: 0.35, green: 0.3, blue: 0.5)],
            windSpeed: 25, humidity: 90, uvIndex: 0, particleType: .lightning
        ),
        WeatherState(
            image: "cloud.snow.fill", message: "Snow is falling!", temp: 28,
            gradient: [Color(red: 0.7, green: 0.78, blue: 0.88), Color(red: 0.5, green: 0.6, blue: 0.75)],
            windSpeed: 15, humidity: 70, uvIndex: 2, particleType: .snow
        ),
        WeatherState(
            image: "cloud.fog.fill", message: "Foggy conditions ahead", temp: 52,
            gradient: [Color(red: 0.55, green: 0.58, blue: 0.62), Color(red: 0.72, green: 0.75, blue: 0.78)],
            windSpeed: 3, humidity: 95, uvIndex: 1, particleType: .fog
        )
    ]

    var current: WeatherState { weatherStates[weatherIndex] }

    var body: some View {
        ZStack {
            // Dynamic gradient background
            LinearGradient(
                colors: current.gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1.0), value: weatherIndex)

            // Particle effects overlay
            ParticleOverlay(type: current.particleType)
                .ignoresSafeArea()

            // Main content
            VStack(spacing: 0) {
                // Location header
                locationHeader
                    .padding(.top, 60)

                Spacer()

                // Weather icon with glow
                weatherIcon

                // Temperature
                Text("\(current.temp)°F")
                    .font(.system(size: 80, weight: .ultraLight, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.5), value: current.temp)
                    .padding(.top, 5)

                // Weather message
                Text(current.message)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
                    .padding(.horizontal, 20)

                // Stats row
                statsRow
                    .padding(.top, 28)

                Spacer()

                // 3-day forecast
                forecastSection
                    .padding(.horizontal, 24)

                // Page indicator dots
                pageDots
                    .padding(.top, 20)

                Spacer()

                // Navigation controls
                navigationControls
                    .padding(.bottom, 50)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 40)
                .onEnded { gesture in
                    if gesture.translation.width < -50 {
                        nextWeather()
                    } else if gesture.translation.width > 50 {
                        previousWeather()
                    }
                }
        )
    }

    // MARK: - Subviews

    private var locationHeader: some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: "location.fill")
                    .font(.caption)
                Text("San Francisco, CA")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)

            Text("Current Weather")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    private var weatherIcon: some View {
        ZStack {
            // Glow behind icon
            Image(systemName: current.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)
                .foregroundStyle(.white.opacity(0.25))
                .blur(radius: 35)

            // Main icon
            Image(systemName: current.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .symbolEffect(.bounce, value: isAnimating)
                .frame(width: 150, height: 150)
                .foregroundStyle(.white)
                .shadow(color: .white.opacity(0.25), radius: 15)
        }
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            WeatherStat(icon: "wind", label: "Wind", value: "\(current.windSpeed) mph")
            Divider()
                .frame(height: 30)
                .overlay(Color.white.opacity(0.3))
            WeatherStat(icon: "humidity.fill", label: "Humidity", value: "\(current.humidity)%")
            Divider()
                .frame(height: 30)
                .overlay(Color.white.opacity(0.3))
            WeatherStat(icon: "sun.max.fill", label: "UV Index", value: "\(current.uvIndex)")
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal, 30)
    }

    private var forecastSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("3-Day Forecast")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.leading, 4)

            HStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { offset in
                    ForecastCard(
                        day: forecastDayLabel(offset: offset),
                        icon: weatherStates[(weatherIndex + offset) % weatherStates.count].image,
                        highTemp: current.temp + [-1, 3, -4][offset],
                        lowTemp: current.temp + [-7, -3, -10][offset]
                    )
                }
            }
        }
    }

    private var pageDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<weatherStates.count, id: \.self) { index in
                Circle()
                    .fill(index == weatherIndex ? Color.white : Color.white.opacity(0.35))
                    .frame(
                        width: index == weatherIndex ? 10 : 7,
                        height: index == weatherIndex ? 10 : 7
                    )
                    .animation(.spring(response: 0.3), value: weatherIndex)
            }
        }
    }

    private var navigationControls: some View {
        HStack(spacing: 16) {
            Button(action: previousWeather) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(.ultraThinMaterial))
            }

            Button(action: nextWeather) {
                HStack(spacing: 8) {
                    Text("Next Weather")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .font(.body)
                .foregroundStyle(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                )
            }

            Button(action: nextWeather) {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(.ultraThinMaterial))
            }
        }
    }

    // MARK: - Actions

    private func nextWeather() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            weatherIndex = (weatherIndex + 1) % weatherStates.count
            isAnimating.toggle()
        }
    }

    private func previousWeather() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            weatherIndex = (weatherIndex - 1 + weatherStates.count) % weatherStates.count
            isAnimating.toggle()
        }
    }

    private func forecastDayLabel(offset: Int) -> String {
        if offset == 0 { return "Today" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let date = Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date()
        return formatter.string(from: date)
    }
}

// MARK: - Weather Stat Component
struct WeatherStat: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.8))
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Forecast Card Component
struct ForecastCard: View {
    let day: String
    let icon: String
    let highTemp: Int
    let lowTemp: Int

    var body: some View {
        VStack(spacing: 8) {
            Text(day)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.8))

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .symbolEffect(.pulse)
                .frame(height: 30)

            HStack(spacing: 4) {
                Text("\(highTemp)°")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Text("\(lowTemp)°")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Particle Effects System
struct ParticleOverlay: View {
    let type: ParticleType

    var body: some View {
        switch type {
        case .rain:
            RainEffect()
        case .snow:
            SnowEffect()
        case .lightning:
            LightningEffect()
        case .fog:
            FogEffect()
        case .sunRays:
            SunRayEffect()
        case .none:
            EmptyView()
        }
    }
}

// MARK: - Rain Particle Effect
struct RainEffect: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for i in 0..<80 {
                    let x = Double(i) / 80.0 * size.width + sin(Double(i)) * 20
                    let speed = 200.0 + Double(i % 5) * 60.0
                    let y = (time * speed + Double(i) * 37)
                        .truncatingRemainder(dividingBy: size.height + 40) - 20
                    let length: CGFloat = 12 + CGFloat(i % 4) * 4

                    var path = Path()
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x - 2, y: y + length))
                    context.stroke(
                        path,
                        with: .color(.white.opacity(0.3 + Double(i % 3) * 0.1)),
                        lineWidth: 1.5
                    )
                }
            }
        }
    }
}

// MARK: - Snow Particle Effect
struct SnowEffect: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for i in 0..<50 {
                    let baseX = Double(i) / 50.0 * size.width
                    let drift = sin(time * 0.8 + Double(i)) * 30
                    let x = baseX + drift
                    let speed = 40.0 + Double(i % 5) * 20.0
                    let y = (time * speed + Double(i) * 47)
                        .truncatingRemainder(dividingBy: size.height + 20) - 10
                    let radius: CGFloat = 2 + CGFloat(i % 4) * 1.5

                    let rect = CGRect(
                        x: x - radius, y: y - radius,
                        width: radius * 2, height: radius * 2
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(.white.opacity(0.5 + Double(i % 3) * 0.15))
                    )
                }
            }
        }
    }
}

// MARK: - Lightning Flash Effect
struct LightningEffect: View {
    @State private var flash = false
    @State private var opacity: Double = 0

    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(opacity))
            .ignoresSafeArea()
            .onAppear { startFlashing() }
            .onChange(of: flash) { startFlashing() }
    }

    private func startFlashing() {
        let delay = Double.random(in: 2...5)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeIn(duration: 0.05)) { opacity = 0.4 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.15)) { opacity = 0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeIn(duration: 0.03)) { opacity = 0.2 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        withAnimation(.easeOut(duration: 0.2)) { opacity = 0 }
                        flash.toggle()
                    }
                }
            }
        }
    }
}

// MARK: - Fog Effect
struct FogEffect: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for i in 0..<6 {
                    let y = size.height * (0.3 + Double(i) * 0.1)
                    let drift = sin(time * 0.3 + Double(i) * 1.5) * 40
                    let rect = CGRect(
                        x: drift - 50, y: y,
                        width: size.width + 100, height: 40
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(.white.opacity(0.08 + sin(time * 0.5 + Double(i)) * 0.03))
                    )
                }
            }
        }
    }
}

// MARK: - Sun Ray Effect
struct SunRayEffect: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let centerX = size.width * 0.75
                let centerY = size.height * 0.15

                for i in 0..<12 {
                    let angle = (Double(i) / 12.0) * .pi * 2 + time * 0.3
                    let rayLength = 60.0 + sin(time * 2 + Double(i)) * 20
                    let startR = 40.0

                    var path = Path()
                    path.move(to: CGPoint(
                        x: centerX + cos(angle) * startR,
                        y: centerY + sin(angle) * startR
                    ))
                    path.addLine(to: CGPoint(
                        x: centerX + cos(angle) * (startR + rayLength),
                        y: centerY + sin(angle) * (startR + rayLength)
                    ))
                    context.stroke(
                        path,
                        with: .color(.white.opacity(0.15)),
                        lineWidth: 2
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
