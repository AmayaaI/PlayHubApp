//
//  StatsTab.swift
//  PlayHub
//

import SwiftUI
import Charts


struct StatsTab: View {


    @Binding var selectedTab: AppTab

    @StateObject private var vm = StatsVM()
    @ObservedObject private var playerStore = PlayerStore.shared

    private var playerStatsTitle: String {
        "Stats for " + (playerStore.selectedPlayer?.name ?? "Selected Player")
    }



    var body: some View {


        NavigationStack {


            ScrollView {


                VStack(spacing:20) {

                    Label(
                        playerStatsTitle,
                        systemImage: "person.crop.circle.fill"
                    )
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))


                    HStack(spacing:12) {


                        statCard(
                            title:"Games Played",
                            value:"\(vm.sessions.count)",
                            icon:"gamecontroller.fill"
                        )


                        statCard(
                            title:"Best Score",
                            value:"\(highestScore)",
                            icon:"trophy.fill"
                        )


                    }





                    HStack(spacing:12) {


                        statCard(
                            title:"Tap Frenzy",
                            value:"\(vm.bestTapFrenzy)",
                            icon:"bolt.fill"
                        )


                        statCard(
                            title:"Light It Up",
                            value:"\(vm.bestLightItUp)",
                            icon:"lightbulb.fill"
                        )


                    }





                    statCard(
                        title:"Quiz Rush",
                        value:"\(vm.bestQuizRush)",
                        icon:"questionmark.circle.fill"
                    )

                    highScoresSection

                    gameHistoryButton

                    savedLocationsButton







                    VStack(alignment:.leading, spacing:15) {


                        Text("Game Performance")
                            .font(.title2.bold())
                            .foregroundColor(.white)



                        Chart(gameStats) { item in


                            BarMark(

                                x:
                                    .value(
                                        "Game",
                                        item.name
                                    ),


                                y:
                                    .value(
                                        "Score",
                                        item.score
                                    )

                            )

                            .foregroundStyle(
                                .cyan.gradient
                            )

                            .cornerRadius(10)


                        }


                        .frame(height:250)


                    }


                    .padding()

                    .background(
                        Color.white.opacity(0.12)
                    )

                    .cornerRadius(20)

                }

                .padding()


            }


            .background(

                LinearGradient(

                    colors: [
                        Color(red: 0.05, green: 0.06, blue: 0.16),
                        Color(red: 0.16, green: 0.08, blue: 0.34),
                        Color(red: 0.03, green: 0.28, blue: 0.38)
                    ],

                    startPoint:.top,

                    endPoint:.bottom

                )

                .ignoresSafeArea()

            )




            // WHITE TITLE HERE

            .toolbar {

                ToolbarItem(
                    placement:.principal
                ) {

                    Text("Statistics")

                        .font(
                            .largeTitle.bold()
                        )

                        .foregroundColor(.white)

                }

            }
            .tint(.white)



            .onAppear {

                vm.loadSessions(for: playerStore.selectedPlayerID)

            }

            .onChange(of: playerStore.selectedPlayerID) {
                vm.loadSessions(for: playerStore.selectedPlayerID)
            }



        }


    }

    private var highScoresSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("High Scores")
                .font(.title2.bold())
                .foregroundColor(.white)

            ForEach(GameMode.allCases, id: \.self) { mode in
                let leaders = vm.highScores(for: mode)
                VStack(alignment: .leading, spacing: 8) {
                    Label(mode.rawValue, systemImage: iconForGame(mode))
                        .font(.headline)
                        .foregroundStyle(.cyan)
                    if leaders.isEmpty {
                        Text("No scores yet")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                    } else {
                        ForEach(leaders.prefix(3)) { session in
                            HStack {
                                Text(session.playerName)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(session.score)")
                                    .fontWeight(.bold)
                                    .foregroundColor(.yellow)
                            }
                            .font(.subheadline)
                        }
                    }
                }
                if mode != GameMode.allCases.last {
                    Divider().background(.white.opacity(0.3))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.12))
        .cornerRadius(20)
    }

    private var savedLocationsButton: some View {
        let locationCount = vm.sessions.filter { $0.latitude != 0 || $0.longitude != 0 }.count
        let pluralSuffix = locationCount == 1 ? "" : "s"
        let locationText = locationCount == 0
            ? "No locations saved yet"
            : "\(locationCount) game location\(pluralSuffix) saved"

        return NavigationLink {
            MapTab()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "map.fill")
                    .font(.title2)
                    .foregroundStyle(.black)
                    .frame(width: 46, height: 46)
                    .background(.cyan, in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("View Saved Game Locations")
                        .font(.headline.bold())
                    Text(locationText)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.65))
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.cyan)
            }
            .foregroundStyle(.white)
            .padding()
            .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var gameHistoryButton: some View {
        NavigationLink {
            HistoryTab()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.title2)
                    .foregroundStyle(.black)
                    .frame(width: 46, height: 46)
                    .background(.purple, in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("Player Game History")
                        .font(.headline.bold())
                    Text("See every game played by this player")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.65))
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.purple)
            }
            .foregroundStyle(.white)
            .padding()
            .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
    }






    var highestScore:Int {


        vm.sessions
            .map{
                $0.score
            }
            .max()
            ??
            0

    }







    var gameStats:[GameStat] {


        [

            GameStat(
                name:"Tap",
                score:vm.bestTapFrenzy
            ),


            GameStat(
                name:"Light",
                score:vm.bestLightItUp
            ),


            GameStat(
                name:"Quiz",
                score:vm.bestQuizRush
            )

        ]

    }







    func statCard(
        title:String,
        value:String,
        icon:String
    ) -> some View {



        VStack(spacing:8) {


            Image(systemName:icon)

                .font(.title)

                .foregroundColor(.yellow)




            Text(value)

                .font(.title.bold())

                .foregroundColor(.white)




            Text(title)

                .font(.caption)

                .foregroundColor(
                    .white.opacity(0.7)
                )


        }

        .frame(
            maxWidth:.infinity,
            minHeight:100
        )

        .background(
            Color.white.opacity(0.1),
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.13), lineWidth: 1)
        }


    }







    func iconForGame(
        _ mode:GameMode
    ) -> String {


        switch mode {


        case .tapFrenzy:

            return "bolt.fill"



        case .lightItUp:

            return "lightbulb.fill"



        case .quizRush:

            return "questionmark.circle.fill"



        }


    }



}





struct GameStat: Identifiable {


    let id = UUID()

    let name:String

    let score:Int

}




#Preview {


    StatsTab(selectedTab: .constant(.stats))


}
