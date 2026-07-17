//
//  LightItUpView.swift
//  PlayHub
//

import SwiftUI


struct LightItUpView: View {


    @StateObject private var vm = LightItUpVM()


    @State private var showGameOverPopup = false

    @State private var showCountdown = false

    @State private var countdownText = ""

    @State private var pulse = false

    @State private var animateBackground = false



    var body: some View {


        ZStack {


            backgroundView


            floatingLights



            VStack(spacing:18) {



                Text("💡 Light It Up")

                    .font(.largeTitle.bold())

                    .foregroundColor(.white)





                scorePanel





                Text(vm.level.title)

                    .font(.title2.bold())

                    .foregroundColor(levelColor())






                gameGrid

                    .disabled(!vm.isPlaying)






                Spacer()






                if !vm.isPlaying && !vm.gameOver {


                    startButton


                }



            }

            .padding()






            // Countdown Animation


            if showCountdown {


                Text(countdownText)

                    .font(
                        .system(
                            size:90,
                            weight:.black
                        )
                    )

                    .foregroundColor(.cyan)


                    .scaleEffect(
                        pulse ? 1.4 : 0.5
                    )


                    .transition(.scale)


            }





            // Level Flash


            if vm.showLevelFlash {


                VStack(spacing:15){


                    Text("⚡ LEVEL UP")

                        .font(
                            .system(
                                size:38,
                                weight:.black
                            )
                        )

                        .foregroundColor(.yellow)




                    Text(vm.level.title)

                        .font(.title.bold())

                        .foregroundColor(.white)



                }

                .padding(40)

                .background(
                    .ultraThinMaterial
                )

                .cornerRadius(30)

                .scaleEffect(
                    pulse ? 1 : 0.5
                )


            }






            // Game Over


            if showGameOverPopup {


                gameOverPopup


            }


        }






        .onAppear {


            withAnimation(
                .linear(duration:8)
                .repeatForever()
            ){

                animateBackground = true

            }


        }






        .onChange(of: vm.gameOver) { value in


            if value {


                withAnimation(.spring()){


                    showGameOverPopup = true


                }


            }


        }




        .navigationTitle("")


    }






    // MARK: Background


    var backgroundView: some View {


        LinearGradient(

            colors:[


                Color(
                    red:0.01,
                    green:0.02,
                    blue:0.08
                ),


                Color(
                    red:0.02,
                    green:0.12,
                    blue:0.28
                ),


                Color(
                    red:0.00,
                    green:0.35,
                    blue:0.45
                )



            ],


            startPoint:.topLeading,


            endPoint:

                animateBackground

                ?

                .bottomTrailing

                :

                .topLeading


        )

        .ignoresSafeArea()


    }






    // MARK: Floating Glow


    var floatingLights: some View {


        ForEach(
            0..<18,
            id:\.self
        ){ _ in



            Circle()

                .fill(
                    Color.cyan.opacity(0.12)
                )

                .frame(
                    width:20,
                    height:20
                )

                .blur(radius:12)


                .position(

                    x:CGFloat.random(
                        in:0...420
                    ),


                    y:CGFloat.random(
                        in:0...850
                    )

                )



        }


    }






    // MARK: Score Panel


    var scorePanel: some View {


        HStack(spacing:12){


            scoreBox(
                title:"Score",
                value:"\(vm.score)",
                icon:"star.fill"
            )



            scoreBox(
                title:"Best",
                value:"\(vm.highScore)",
                icon:"trophy.fill"
            )



            scoreBox(
                title:"Time",
                value:"\(vm.timeRemaining)",
                icon:"timer"
            )



        }


    }     // MARK: Game Grid
    
    var gameGrid: some View {

        LazyVGrid(
            columns: gridColumns,
            spacing: 12
        ) {

            ForEach(vm.cards) { card in


                RoundedRectangle(
                    cornerRadius: 18
                )

                .fill(

                    card.isLit
                    ?
                    LinearGradient(
                        colors:[
                            .yellow,
                            .orange
                        ],
                        startPoint:.top,
                        endPoint:.bottom
                    )
                    :
                    LinearGradient(
                        colors:[
                            Color.white.opacity(0.12),
                            Color.white.opacity(0.05)
                        ],
                        startPoint:.top,
                        endPoint:.bottom
                    )

                )


                .frame(height:85)



                .overlay {


                    Image(systemName:"lightbulb.fill")

                        .font(.title)

                        .foregroundColor(

                            card.isLit
                            ?
                            .white
                            :
                            .gray.opacity(0.7)

                        )


                }



                .scaleEffect(
                    card.isLit ? 1.15 : 1
                )


                .shadow(

                    color:

                        card.isLit
                        ?
                        .yellow
                        :
                        .clear,

                    radius:

                        card.isLit
                        ?
                        25
                        :
                        0

                )


                .animation(
                    .easeInOut(duration:0.25),
                    value:card.isLit
                )



                .onTapGesture {


                    if let index =
                        vm.cards.firstIndex(
                            where:{
                                $0.id == card.id
                            }
                        ) {


                        vm.tapCard(
                            at:index
                        )


                    }


                }


            }


        }


    }






    var gridColumns:[GridItem] {


        Array(

            repeating:

                GridItem(
                    .flexible(),
                    spacing:12
                ),

            count:
                vm.level.columns

        )


    }






    // MARK: Start Button


    var startButton: some View {


        Button {


            startCountdown()


        } label: {


            Text("⚡ START GAME")

                .font(.headline.bold())

                .foregroundColor(.white)

                .frame(
                    maxWidth:.infinity
                )

                .padding()

                .background(
                    buttonGradient
                )

                .cornerRadius(20)

                .shadow(
                    color:.cyan.opacity(0.5),
                    radius:15
                )


        }


    }






    // MARK: Countdown


    func startCountdown(){


        showCountdown = true


        let numbers = [
            "3",
            "2",
            "1",
            "GO!"
        ]



        for (index,text) in numbers.enumerated(){


            DispatchQueue.main.asyncAfter(
                deadline:
                    .now()
                    +
                    Double(index)
            ){


                countdownText = text



                withAnimation(.spring()){


                    pulse.toggle()


                }


            }


        }



        DispatchQueue.main.asyncAfter(
            deadline:.now()+4
        ){


            showCountdown = false

            vm.startGame()


        }


    }






    // MARK: Game Over Popup


    var gameOverPopup: some View {


        ZStack {


            Color.black.opacity(0.75)

                .ignoresSafeArea()



            VStack(spacing:22){



                Image(systemName:
                        "trophy.fill")

                    .font(
                        .system(
                            size:80
                        )
                    )

                    .foregroundColor(.yellow)




                Text("GAME OVER")

                    .font(
                        .system(
                            size:40,
                            weight:.black
                        )
                    )

                    .foregroundColor(.white)





                Text("FINAL SCORE")

                    .foregroundColor(
                        .white.opacity(0.7)
                    )





                Text("\(vm.score)")

                    .font(
                        .system(
                            size:60,
                            weight:.black
                        )
                    )

                    .foregroundColor(.yellow)






                Text(
                    "Best: \(vm.highScore)"
                )

                .foregroundColor(.white)






                Button {


                    showGameOverPopup = false

                    vm.startGame()



                } label:{



                    Text("PLAY AGAIN")

                        .bold()

                        .foregroundColor(.white)

                        .frame(
                            width:220,
                            height:55
                        )

                        .background(
                            buttonGradient
                        )

                        .cornerRadius(18)



                }



            }

            .padding(40)

            .background(
                .ultraThinMaterial
            )

            .cornerRadius(30)

            .shadow(
                color:.cyan,
                radius:30
            )


        }


    }







    // MARK: Score Card


    func scoreBox(
        title:String,
        value:String,
        icon:String
    ) -> some View {


        VStack(spacing:5){


            Image(systemName:icon)

                .foregroundColor(.yellow)



            Text(value)

                .font(
                    .title3.bold()
                )

                .foregroundColor(.white)




            Text(title)

                .font(.caption)

                .foregroundColor(
                    .white.opacity(0.7)
                )


        }

        .frame(
            width:90,
            height:75
        )

        .background(
            Color.white.opacity(0.12)
        )

        .cornerRadius(15)

        .overlay(

            RoundedRectangle(
                cornerRadius:15
            )
            .stroke(
                Color.cyan.opacity(0.3),
                lineWidth:1
            )

        )


    }







    // MARK: Button Gradient


    var buttonGradient:LinearGradient {


        LinearGradient(

            colors:[

                Color.blue,

                Color.cyan

            ],

            startPoint:.leading,

            endPoint:.trailing

        )


    }







    // MARK: Level Color


    func levelColor()->Color {


        switch vm.level {


        case .level1:

            return .yellow



        case .level2:

            return .green



        case .level3:

            return .orange



        case .level4:

            return .red



        }


    }


}





#Preview {


    NavigationStack {


        LightItUpView()


    }


}
