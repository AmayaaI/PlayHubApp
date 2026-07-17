//
//  StatsTab.swift
//  PlayHub
//

import SwiftUI
import Charts


struct StatsTab: View {


    @StateObject private var vm = StatsVM()



    var body: some View {


        NavigationStack {


            ScrollView {


                VStack(spacing:20) {


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








                    VStack(alignment:.leading, spacing:15) {


                        Text("Recent Games")
                            .font(.title2.bold())
                            .foregroundColor(.white)



                        if vm.sessions.isEmpty {


                            Text("No games played yet.")
                                .foregroundColor(.gray)


                        }


                        else {


                            ForEach(
                                vm.sessions.reversed()
                            ) { session in



                                HStack {


                                    VStack(
                                        alignment:.leading,
                                        spacing:5
                                    ) {



                                        Text(
                                            session.mode.rawValue
                                        )

                                        .font(.headline)

                                        .foregroundColor(.white)




                                        Text(
                                            "Score: \(session.score)"
                                        )

                                        .foregroundColor(
                                            .white.opacity(0.8)
                                        )




                                        Text(
                                            session.timestamp.formatted()
                                        )

                                        .font(.caption)

                                        .foregroundColor(.gray)



                                    }



                                    Spacer()



                                    Image(
                                        systemName:
                                            iconForGame(
                                                session.mode
                                            )
                                    )

                                    .foregroundColor(.yellow)

                                    .font(.title2)



                                }



                                Divider()
                                    .background(.white.opacity(0.3))


                            }



                        }



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

                    colors:[
                        Color.black,
                        Color.blue.opacity(0.5)
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



            .onAppear {

                vm.loadSessions()

            }



        }


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
            .ultraThinMaterial
        )

        .cornerRadius(20)


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


    StatsTab()


}
