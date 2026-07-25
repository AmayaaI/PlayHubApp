import SwiftUI

struct HomeTab: View {
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    premiumBackground

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            Spacer(minLength: max(20, proxy.size.height * 0.12))

                            header

                            Spacer(minLength: max(38, proxy.size.height * 0.09))

                            VStack(spacing: 14) {
                                gameButton(
                                    title: "Tap Frenzy",
                                    subtitle: "Beat the clock with lightning-fast taps.",
                                    icon: "hand.tap.fill",
                                    accent: [.pink, .purple],
                                    destination: TapFrenzyView()
                                )

                                gameButton(
                                    title: "Light It Up",
                                    subtitle: "Catch every glowing light before it fades.",
                                    icon: "lightbulb.fill",
                                    accent: [.orange, .yellow],
                                    destination: LightItUpView()
                                )

                                gameButton(
                                    title: "Quiz Rush",
                                    subtitle: "Quick questions. Big-brain bragging rights.",
                                    icon: "questionmark.circle.fill",
                                    accent: [.mint, .cyan],
                                    destination: QuizRushView()
                                )
                            }

                            Spacer(minLength: 26)
                        }
                        .frame(minHeight: proxy.size.height, alignment: .top)
                        .padding(.horizontal, 20)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("PLAYHUB")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .tracking(0.5)
                    .foregroundStyle(.white)
                Text("Quick games. Big fun.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            Image(systemName: "gamecontroller.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .padding(13)
                .background(.white.opacity(0.14), in: Circle())
        }
    }

    private var premiumBackground: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.05, green: 0.06, blue: 0.16), Color(red: 0.16, green: 0.08, blue: 0.34), Color(red: 0.03, green: 0.28, blue: 0.38)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle().fill(.purple.opacity(0.38)).frame(width: 300).blur(radius: 55).offset(x: 150, y: -330)
            Circle().fill(.cyan.opacity(0.24)).frame(width: 260).blur(radius: 60).offset(x: -160, y: 300)
        }
        .ignoresSafeArea()
    }

    private func gameButton<Destination: View>(title: String, subtitle: String, icon: String, accent: [Color], destination: Destination) -> some View {
        NavigationLink { destination } label: {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 27, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(LinearGradient(colors: accent, startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 17, style: .continuous))

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.64))
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)
                Image(systemName: "arrow.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(10)
                    .background(.white.opacity(0.1), in: Circle())
            }
            .padding(14)
            .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(.white.opacity(0.13), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeTab()
}
