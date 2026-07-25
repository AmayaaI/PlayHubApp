import SwiftUI
import Combine

struct TapFrenzyView: View {

    // MARK: Game State

    @State private var score = 0
    @State private var highScore = 0
    @State private var level = 1
    @State private var timeRemaining = 30
    @State private var gameOver = false

    // MARK: Button Position

    @State private var buttonX: CGFloat = 200
    @State private var buttonY: CGFloat = 450

    @State private var buttonScale: CGFloat = 1
    @State private var showLevelUp = false

    // MARK: Movement

    @State private var lastMove = Date()
    @ObservedObject private var playerStore = PlayerStore.shared

    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    )
    .autoconnect()

    let moveTimer = Timer.publish(
        every: 0.1,
        on: .main,
        in: .common
    )
    .autoconnect()


    var body: some View {

        GeometryReader { geo in

            ZStack {

                // MARK: Background

                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.08, blue: 0.20),
                        Color.blue,
                        Color.purple
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()


                if !gameOver {


                    VStack {

                        Text("⚡ TAP FRENZY")
                            .font(.system(size: 34,
                                          weight: .black))
                            .foregroundColor(.white)


                        HStack(spacing: 12) {


                            infoCard(
                                title: "SCORE",
                                value: "\(score)",
                                color: .orange
                            )


                            infoCard(
                                title: "TIME",
                                value: "\(timeRemaining)",
                                color: .cyan
                            )


                            infoCard(
                                title: "LEVEL",
                                value: "\(level)",
                                color: .green
                            )

                        }
                        .padding(.top,20)


                        Spacer()

                    }



                    // MARK: TAP BUTTON


                    Button {


                        score += 1


                        withAnimation(.spring()) {

                            buttonScale = 0.85

                        }


                        DispatchQueue.main.asyncAfter(
                            deadline: .now()+0.1
                        ){

                            withAnimation {

                                buttonScale = 1

                            }
                        }


                    } label: {


                        ZStack {


                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors:[
                                            .orange,
                                            .red
                                        ],
                                        startPoint:.topLeading,
                                        endPoint:.bottomTrailing
                                    )
                                )
                                .frame(
                                    width:170,
                                    height:170
                                )


                            Circle()
                                .stroke(
                                    .white,
                                    lineWidth:5
                                )
                                .frame(
                                    width:170,
                                    height:170
                                )


                            Text("TAP")
                                .font(
                                    .system(
                                        size:40,
                                        weight:.black
                                    )
                                )
                                .foregroundColor(.white)

                        }

                    }
                    .scaleEffect(buttonScale)
                    .shadow(
                        color:.orange,
                        radius:30
                    )
                    .position(
                        x:buttonX,
                        y:buttonY
                    )



                }
                else {


                    VStack(spacing:25){


                        Image(systemName:"trophy.fill")
                            .font(.system(size:80))
                            .foregroundColor(.yellow)


                        Text("GAME OVER")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)


                        Text("Score \(score)")
                            .font(.system(size:60,
                                          weight:.black))
                            .foregroundColor(.yellow)



                        Text("Best \(highScore)")
                            .foregroundColor(.white)



                        Button {


                            restartGame(
                                size:geo.size
                            )


                        }label:{


                            Text("PLAY AGAIN")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(
                                    width:230,
                                    height:55
                                )
                                .background(
                                    LinearGradient(
                                        colors:[
                                            .blue,
                                            .purple
                                        ],
                                        startPoint:.leading,
                                        endPoint:.trailing
                                    )
                                )
                                .cornerRadius(20)

                        }

                    }

                }


                if showLevelUp {


                    VStack {


                        Text("🔥 LEVEL \(level)")
                            .font(.system(
                                size:45,
                                weight:.black
                            ))
                            .foregroundColor(.yellow)



                        Text("FASTER!")
                            .font(.title.bold())
                            .foregroundColor(.white)

                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .cornerRadius(25)

                }

            }


            .onAppear {

                highScore = GameStorage.shared.bestScore(for: .tapFrenzy)
                resetButtonPosition(
                    size:geo.size
                )

            }
            .onChange(of: playerStore.selectedPlayerID) {
                highScore = GameStorage.shared.bestScore(for: .tapFrenzy)
            }


            // MARK: Countdown

            .onReceive(timer){_ in


                guard !gameOver else{
                    return
                }


                timeRemaining -= 1



                switch timeRemaining {


                case 25:
                    increaseLevel(2)


                case 20:
                    increaseLevel(3)


                case 15:
                    increaseLevel(4)


                case 10:
                    increaseLevel(5)


                default:
                    break

                }


//
//                if timeRemaining <= 0 {
//
//
//                    gameOver = true
//
//
//                    if score > highScore {
//
//                        highScore = score
//
//                    }
//
//
//                }

                if timeRemaining <= 0 {


                    gameOver = true


                    if score > highScore {

                        highScore = score

                    }



                    let session = GameSession(

                        id: UUID(),

                        mode: .tapFrenzy,

                        score: score,

                        timestamp: Date(),

                        latitude: LocationService.shared.latitude,

                        longitude: LocationService.shared.longitude

                    )


                    GameStorage.shared.saveSession(session)
                    highScore = GameStorage.shared.bestScore(for: .tapFrenzy)


                }
            }



            // MARK: Movement Check


            .onReceive(moveTimer){_ in


                guard !gameOver else{
                    return
                }


                let now = Date()


                if now.timeIntervalSince(lastMove)
                    >= movementSpeed {


                    withAnimation(.spring()){


                        resetButtonPosition(
                            size:geo.size
                        )


                    }


                    lastMove = now

                }

            }

        }

    }



    // MARK: Level Speed


    var movementSpeed:Double {


        switch level {


        case 2:
            return 1.2


        case 3:
            return 0.8


        case 4:
            return 0.5


        case 5:
            return 0.3


        default:
            return 1.8

        }

    }



    // MARK: Level Up


    func increaseLevel(_ newLevel:Int){


        level = newLevel


        withAnimation(.spring()){

            showLevelUp = true

        }


        DispatchQueue.main.asyncAfter(
            deadline:.now()+1
        ){

            withAnimation{

                showLevelUp = false

            }

        }

    }



    // MARK: Card


    func infoCard(
        title:String,
        value:String,
        color:Color
    )->some View{


        VStack{


            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))


            Text(value)
                .font(.title.bold())
                .foregroundColor(color)


        }
        .frame(
            width:105,
            height:85
        )
        .background(.ultraThinMaterial)
        .cornerRadius(20)

    }



    // MARK: Restart


    func restartGame(size:CGSize){


        highScore = GameStorage.shared.bestScore(for: .tapFrenzy)
        score = 0
        level = 1
        timeRemaining = 30
        gameOver = false
        lastMove = Date()


        resetButtonPosition(size:size)

    }



    // MARK: Random Position


    func resetButtonPosition(size:CGSize){


        buttonX = CGFloat.random(
            in:100...(size.width-100)
        )


        buttonY = CGFloat.random(
            in:250...(size.height-150)
        )

    }

}



#Preview {

    NavigationStack {

        TapFrenzyView()

    }

}
