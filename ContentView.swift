//
//  ContentView.swift
//  MyAnimatedButton
//
//  ISYS 556 - Prof. Jin
//  Theme: Outdoor Adventures (Weather-Dependent Activities)
//  Enhanced by Carlo - Discord Extra Credit Edition
//

import SwiftUI

// MARK: - Activity Data Model
struct ActivityState {
    let image: String
    let name: String
    let message: String
    let temp: Int
    let windSpeed: Int
    let difficulty: String
    let condition: String
    let gradient: [Color]
    let particleType: ParticleType
}

enum ParticleType {
    case sunRays, bubbles, waves, snow, stars, fog
}

// MARK: - Content View
struct ContentView: View {
    // State variables — track current activity (rubric: @State)
    @State private var activityImage = "figure.hiking"
    @State private var activityMessage = "Perfect day for a hike!"
    @State private var activityIndex: Int = 0
    @State private var isAnimating = false

    // Activity data for enhanced visuals
    let activities: [ActivityState] = [
        ActivityState(
            image: "figure.hiking", name: "Hiking",
            message: "Perfect day for a hike!",
            temp: 72, windSpeed: 5, difficulty: "Moderate",
            condition: "Sunny",
            gradient: [Color(red: 0.95, green: 0.55, blue: 0.15), Color(red: 0.35, green: 0.65, blue: 0.25)],
            particleType: .sunRays
        ),
        ActivityState(
            image: "figure.fishing", name: "Fishing",
            message: "Calm waters — great catch ahead!",
            temp: 65, windSpeed: 8, difficulty: "Easy",
            condition: "Calm",
            gradient: [Color(red: 0.05, green: 0.45, blue: 0.55), Color(red: 0.2, green: 0.65, blue: 0.75)],
            particleType: .bubbles
        ),
        ActivityState(
            image: "figure.surfing", name: "Surfing",
            message: "Waves are calling — hang ten!",
            temp: 78, windSpeed: 20, difficulty: "Hard",
            condition: "Windy",
            gradient: [Color(red: 0.0, green: 0.3, blue: 0.6), Color(red: 0.05, green: 0.55, blue: 0.7)],
            particleType: .waves
        ),
        ActivityState(
            image: "figure.skiing.downhill", name: "Skiing",
            message: "Fresh powder on the slopes!",
            temp: 28, windSpeed: 15, difficulty: "Hard",
            condition: "Snowy",
            gradient: [Color(red: 0.68, green: 0.76, blue: 0.88), Color(red: 0.42, green: 0.52, blue: 0.72)],
            particleType: .snow
        ),
        ActivityState(
            image: "tent.fill", name: "Camping",
            message: "Stars are out tonight!",
            temp: 58, windSpeed: 3, difficulty: "Easy",
            condition: "Clear Night",
            gradient: [Color(red: 0.06, green: 0.06, blue: 0.22), Color(red: 0.12, green: 0.08, blue: 0.32)],
            particleType: .stars
        ),
        ActivityState(
            image: "figure.climbing", name: "Climbing",
            message: "Misty mountain adventure!",
            temp: 55, windSpeed: 12, difficulty: "Expert",
            condition: "Misty",
            gradient: [Color(red: 0.42, green: 0.45, blue: 0.5), Color(red: 0.6, green: 0.62, blue: 0.66)],
            particleType: .fog
        )
    ]

    var current: ActivityState { activities[activityIndex] }

    var body: some View {
        ZStack {
            // Dynamic gradient background
            LinearGradient(
                colors: current.gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1.0), value: activityIndex)

            // Particle effects overlay
            ParticleOverlay(type: current.particleType)
                .ignoresSafeArea()

            // Main content
            VStack(spacing: 0) {
                // App header
                headerSection
                    .padding(.top, 60)

                Spacer()

                // Activity icon with glow (rubric: Image + symbolEffect)
                activityIcon

                // Activity name
                Text(current.name)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.top, 10)

                // Temperature & weather condition
                HStack(spacing: 8) {
                    Text("\(current.temp)°F")
                        .contentTransition(.numericText())
                    Text("•")
                    Text(current.condition)
                }
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.85))
                .padding(.top, 4)
                .animation(.spring(response: 0.5), value: activityIndex)

                // Activity message (rubric: Text)
                Text(activityMessage)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
                    .padding(.horizontal, 20)

                // Stats row: Temp, Wind, Difficulty
                statsRow
                    .padding(.top, 28)

                Spacer()

                // Up next section
                upNextSection
                    .padding(.horizontal, 24)

                // Page indicator dots
                pageDots
                    .padding(.top, 20)

                Spacer()

                // Navigation controls (rubric: Button)
                navigationControls
                    .padding(.bottom, 50)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 40)
                .onEnded { gesture in
                    if gesture.translation.width < -50 {
                        cycleToNextActivity()
                    } else if gesture.translation.width > 50 {
                        cycleToPreviousActivity()
                    }
                }
        )
    }

    // MARK: - Subviews

    private var headerSection: some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: "mountain.2.fill")
                    .font(.caption)
                Text("Outdoor Adventures")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)

            Text("Weather-Dependent Activities")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    private var activityIcon: some View {
        ZStack {
            // Glow behind icon
            Image(systemName: activityImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)
                .foregroundStyle(.white.opacity(0.25))
                .blur(radius: 35)

            // Main icon with bounce animation (rubric: symbolEffect)
            Image(systemName: activityImage)
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
            StatView(icon: "thermometer.medium", label: "Temp", value: "\(current.temp)°F")
            Divider().frame(height: 30).overlay(Color.white.opacity(0.3))
            StatView(icon: "wind", label: "Wind", value: "\(current.windSpeed) mph")
            Divider().frame(height: 30).overlay(Color.white.opacity(0.3))
            StatView(icon: "figure.walk", label: "Difficulty", value: current.difficulty)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal, 30)
    }

    private var upNextSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Up Next")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.leading, 4)

            HStack(spacing: 10) {
                ForEach(1..<4, id: \.self) { offset in
                    let nextIndex = (activityIndex + offset) % activities.count
                    UpcomingCard(
                        name: activities[nextIndex].name,
                        icon: activities[nextIndex].image,
                        condition: activities[nextIndex].condition,
                        temp: activities[nextIndex].temp
                    )
                }
            }
        }
    }

    private var pageDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<activities.count, id: \.self) { index in
                Circle()
                    .fill(index == activityIndex ? Color.white : Color.white.opacity(0.35))
                    .frame(
                        width: index == activityIndex ? 10 : 7,
                        height: index == activityIndex ? 10 : 7
                    )
                    .animation(.spring(response: 0.3), value: activityIndex)
            }
        }
    }

    private var navigationControls: some View {
        HStack(spacing: 16) {
            Button(action: cycleToPreviousActivity) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(.ultraThinMaterial))
            }

            // Main button — tapping cycles the activity (rubric: Button)
            Button(action: cycleToNextActivity) {
                HStack(spacing: 8) {
                    Text("Next Adventure")
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

            Button(action: cycleToNextActivity) {
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

    /// Cycle to the next outdoor activity using if-else if (rubric requirement)
    private func cycleToNextActivity() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            // if-else if statement to decide the next activity (rubric: if-else if)
            if activityIndex == 0 {
                activityImage = "figure.fishing"
                activityMessage = "Calm waters — great catch ahead!"
                activityIndex = 1
            } else if activityIndex == 1 {
                activityImage = "figure.surfing"
                activityMessage = "Waves are calling — hang ten!"
                activityIndex = 2
            } else if activityIndex == 2 {
                activityImage = "figure.skiing.downhill"
                activityMessage = "Fresh powder on the slopes!"
                activityIndex = 3
            } else if activityIndex == 3 {
                activityImage = "tent.fill"
                activityMessage = "Stars are out tonight!"
                activityIndex = 4
            } else if activityIndex == 4 {
                activityImage = "figure.climbing"
                activityMessage = "Misty mountain adventure!"
                activityIndex = 5
            } else {
                activityImage = "figure.hiking"
                activityMessage = "Perfect day for a hike!"
                activityIndex = 0
            }
            isAnimating.toggle()
        }
    }

    /// Cycle to the previous activity
    private func cycleToPreviousActivity() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            activityIndex = (activityIndex - 1 + activities.count) % activities.count
            activityImage = activities[activityIndex].image
            activityMessage = activities[activityIndex].message
            isAnimating.toggle()
        }
    }
}

// MARK: - Stat View Component
struct StatView: View {
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

// MARK: - Upcoming Activity Card
struct UpcomingCard: View {
    let name: String
    let icon: String
    let condition: String
    let temp: Int

    var body: some View {
        VStack(spacing: 8) {
            Text(name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.8))

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .symbolEffect(.pulse)
                .frame(height: 30)

            Text("\(temp)° • \(condition)")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.6))
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
        case .sunRays:
            SunRayEffect()
        case .bubbles:
            BubbleEffect()
        case .waves:
            WaveEffect()
        case .snow:
            SnowEffect()
        case .stars:
            StarfieldEffect()
        case .fog:
            FogEffect()
        }
    }
}

// MARK: - Sun Ray Effect (Hiking)
struct SunRayEffect: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let centerX = size.width * 0.75
                let centerY = size.height * 0.12

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

// MARK: - Bubble Effect (Fishing)
struct BubbleEffect: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for i in 0..<30 {
                    let baseX = Double(i) / 30.0 * size.width
                    let drift = sin(time * 0.6 + Double(i) * 2.0) * 15
                    let x = baseX + drift
                    let speed = 30.0 + Double(i % 4) * 15.0
                    // Bubbles rise upward
                    let totalHeight = size.height + 40
                    let y = size.height - ((time * speed + Double(i) * 53)
                        .truncatingRemainder(dividingBy: totalHeight))
                    let radius: CGFloat = 3 + CGFloat(i % 5) * 2

                    // Bubble circle
                    let rect = CGRect(
                        x: x - radius, y: y - radius,
                        width: radius * 2, height: radius * 2
                    )
                    context.stroke(
                        Path(ellipseIn: rect),
                        with: .color(.white.opacity(0.2 + Double(i % 3) * 0.08)),
                        lineWidth: 1
                    )
                    // Small highlight inside bubble
                    let highlightRect = CGRect(
                        x: x - radius * 0.3, y: y - radius * 0.4,
                        width: radius * 0.4, height: radius * 0.4
                    )
                    context.fill(
                        Path(ellipseIn: highlightRect),
                        with: .color(.white.opacity(0.15))
                    )
                }
            }
        }
    }
}

// MARK: - Wave Effect (Surfing)
struct WaveEffect: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                // Draw multiple wave layers
                for layer in 0..<4 {
                    let layerOffset = Double(layer) * 0.7
                    let baseY = size.height * (0.65 + Double(layer) * 0.08)
                    let amplitude = 12.0 + Double(layer) * 4.0
                    let frequency = 0.015 - Double(layer) * 0.002
                    let speed = 1.5 + Double(layer) * 0.3

                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: size.height))

                    for x in stride(from: 0, through: size.width, by: 2) {
                        let y = baseY + sin(Double(x) * frequency + time * speed + layerOffset) * amplitude
                        if x == 0 {
                            path.move(to: CGPoint(x: 0, y: y))
                        }
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    path.addLine(to: CGPoint(x: size.width, y: size.height))
                    path.addLine(to: CGPoint(x: 0, y: size.height))
                    path.closeSubpath()

                    context.fill(
                        path,
                        with: .color(.white.opacity(0.04 + Double(layer) * 0.02))
                    )
                }

                // Spray particles at top of waves
                for i in 0..<20 {
                    let x = Double(i) / 20.0 * size.width
                    let waveY = size.height * 0.65 + sin(Double(x) * 0.015 + time * 1.5) * 12
                    let sprayY = waveY - abs(sin(time * 3 + Double(i) * 1.7)) * 25
                    let radius: CGFloat = 1.5
                    let rect = CGRect(
                        x: x - radius + sin(time + Double(i)) * 5,
                        y: sprayY - radius,
                        width: radius * 2, height: radius * 2
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(.white.opacity(0.15 * abs(sin(time * 2 + Double(i)))))
                    )
                }
            }
        }
    }
}

// MARK: - Snow Particle Effect (Skiing)
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

// MARK: - Starfield Effect (Camping)
struct StarfieldEffect: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                // Static twinkling stars
                for i in 0..<60 {
                    // Deterministic pseudo-random positions using the index
                    let px = sin(Double(i) * 127.1 + 311.7).truncatingRemainder(dividingBy: 1.0)
                    let py = sin(Double(i) * 269.5 + 183.3).truncatingRemainder(dividingBy: 1.0)
                    let x = abs(px) * size.width
                    let y = abs(py) * size.height * 0.7 // Keep stars in upper portion

                    // Twinkle using sin with different phase per star
                    let twinkle = 0.3 + 0.7 * abs(sin(time * (1.0 + Double(i % 5) * 0.4) + Double(i) * 0.8))
                    let radius: CGFloat = CGFloat(1 + i % 3)

                    let rect = CGRect(
                        x: x - radius, y: y - radius,
                        width: radius * 2, height: radius * 2
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(.white.opacity(twinkle * 0.8))
                    )

                    // Add a subtle cross sparkle on brighter stars
                    if i % 4 == 0 && twinkle > 0.7 {
                        let sparkleLen: CGFloat = radius * 3
                        var hLine = Path()
                        hLine.move(to: CGPoint(x: x - sparkleLen, y: y))
                        hLine.addLine(to: CGPoint(x: x + sparkleLen, y: y))
                        var vLine = Path()
                        vLine.move(to: CGPoint(x: x, y: y - sparkleLen))
                        vLine.addLine(to: CGPoint(x: x, y: y + sparkleLen))

                        context.stroke(hLine, with: .color(.white.opacity(twinkle * 0.3)), lineWidth: 0.5)
                        context.stroke(vLine, with: .color(.white.opacity(twinkle * 0.3)), lineWidth: 0.5)
                    }
                }

                // Shooting star — cycles every ~6 seconds
                let shootCycle = time.truncatingRemainder(dividingBy: 6.0)
                if shootCycle < 0.8 {
                    let progress = shootCycle / 0.8
                    let startX = size.width * 0.2
                    let startY = size.height * 0.05
                    let endX = size.width * 0.7
                    let endY = size.height * 0.25
                    let currentX = startX + (endX - startX) * progress
                    let currentY = startY + (endY - startY) * progress
                    let tailLength: CGFloat = 40

                    let dx = endX - startX
                    let dy = endY - startY
                    let dist = sqrt(dx * dx + dy * dy)
                    let nx = dx / dist
                    let ny = dy / dist

                    var streak = Path()
                    streak.move(to: CGPoint(x: currentX, y: currentY))
                    streak.addLine(to: CGPoint(
                        x: currentX - nx * tailLength,
                        y: currentY - ny * tailLength
                    ))
                    context.stroke(
                        streak,
                        with: .color(.white.opacity(0.6 * (1.0 - progress))),
                        lineWidth: 1.5
                    )
                }
            }
        }
    }
}

// MARK: - Fog Effect (Climbing)
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

#Preview {
    ContentView()
}
