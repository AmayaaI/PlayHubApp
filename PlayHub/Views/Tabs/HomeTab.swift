////
////  HomeTab.swift
////  PlayHub
////
////  Created by Amaya Mahavithane on 2026-07-06.
////
//
           
import SwiftUI

struct HomeTab: View {

    var body: some View {

        NavigationStack {

            ZStack {

                LinearGradient(
                    colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()


                VStack(spacing: 25) {

                    Spacer()
                        .frame(height: 30)


                    // Logo
                    VStack(spacing: 8) {

                        Text("🎯")
                            .font(.system(size: 90))

                        Text("PlayHub")
                            .font(.system(size: 42, weight: .black))
                            .foregroundColor(.white)

                        Text("Choose your challenge")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))

                    }


                    Spacer()
                        .frame(height: 20)


                    // Games

                    gameButton(
                        title: "Tap Frenzy",
                        subtitle: "Tap as fast as you can!",
                        icon: "hand.tap.fill",
                        color: .blue
                    ) {

                        TapFrenzyView()

                    }


                    gameButton(
                        title: "Light It Up",
                        subtitle: "Catch the glowing lights!",
                        icon: "lightbulb.fill",
                        color: .orange
                    ) {

                        LightItUpView()

                    }


                    gameButton(
                        title: "Quiz Rush",
                        subtitle: "Test your knowledge!",
                        icon: "questionmark.circle.fill",
                        color: .green
                    ) {

                        QuizRushView()

                    }


                    Spacer()

                }
                .padding(.horizontal, 25)

            }
            .navigationTitle("")
        }
    }



    @ViewBuilder
    func gameButton<Destination: View>(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        destination: () -> Destination
    ) -> some View {


        NavigationLink {

            destination()

        } label: {

            HStack(spacing: 18) {


                Image(systemName: icon)
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .frame(width: 60)



                VStack(alignment: .leading, spacing: 5) {

                    Text(title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)


                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))

                }


                Spacer()


                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))

            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(20)
            .shadow(
                color: color.opacity(0.5),
                radius: 10,
                y: 6
            )

        }

    }
}


#Preview {

    HomeTab()

}
