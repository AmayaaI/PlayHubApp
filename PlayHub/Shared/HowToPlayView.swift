import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) private var dismiss

    private let guides: [GameGuide] = [
        GameGuide(
            title: "Tap Frenzy",
            subtitle: "Fast hands win.",
            icon: "hand.tap.fill",
            accent: [.pink, .purple],
            steps: [
                "Tap the moving TAP button as quickly as you can.",
                "Every successful tap adds one point to your score.",
                "Keep going until the 30-second timer reaches zero."
            ]
        ),
        GameGuide(
            title: "Light It Up",
            subtitle: "Stay sharp and catch every glow.",
            icon: "lightbulb.fill",
            accent: [.orange, .yellow],
            steps: [
                "Press Start and wait for the countdown to finish.",
                "Tap each glowing light before it fades away.",
                "Clear the grid to move through increasingly challenging levels."
            ]
        ),
        GameGuide(
            title: "Quiz Rush",
            subtitle: "Trust your instincts.",
            icon: "questionmark.circle.fill",
            accent: [.mint, .cyan],
            steps: [
                "Read the question and choose the answer you think is right.",
                "Correct answers increase your score and streak.",
                "Complete all questions to see your final score and best result."
            ]
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                background

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("GAME GUIDE")
                                .font(.caption.weight(.black))
                                .tracking(2)
                                .foregroundStyle(.cyan)
                            Text("How to play")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            Text("A quick guide to every PlayHub challenge.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.62))
                        }

                        ForEach(guides) { guide in
                            guideCard(guide)
                        }
                    }
                    .padding(20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.bold)
                        .tint(.white)
                }
            }
        }
    }

    private func guideCard(_ guide: GameGuide) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 13) {
                Image(systemName: guide.icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(LinearGradient(colors: guide.accent, startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                VStack(alignment: .leading, spacing: 3) {
                    Text(guide.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Text(guide.subtitle)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(guide.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.black.opacity(0.76))
                            .frame(width: 22, height: 22)
                            .background(.white.opacity(0.88), in: Circle())
                        Text(step)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.82))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(16)
        .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        }
    }

    private var background: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.05, green: 0.06, blue: 0.16), Color(red: 0.16, green: 0.08, blue: 0.34), Color(red: 0.03, green: 0.28, blue: 0.38)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle().fill(.purple.opacity(0.36)).frame(width: 290).blur(radius: 60).offset(x: 145, y: -300)
            Circle().fill(.cyan.opacity(0.22)).frame(width: 260).blur(radius: 65).offset(x: -150, y: 310)
        }
        .ignoresSafeArea()
    }
}

private struct GameGuide: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let accent: [Color]
    let steps: [String]
}

#Preview {
    HowToPlayView()
}
