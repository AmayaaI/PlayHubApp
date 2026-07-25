//
//  LightItUpVM.swift
//  PlayHub
//

import Foundation
import SwiftUI
import Combine


class LightItUpVM: ObservableObject {


    // MARK: - Game State

    @Published var cards: [LightCard] = []

    @Published var score = 0

    @Published var timeRemaining = 60

    @Published var level: LightLevel = .level1

    @Published var gameOver = false

    @Published var isPlaying = false

    @Published var showLevelFlash = false



    // MARK: - High Score

    @Published var highScore = 0



    // MARK: - Timers

    private var gameTimer: Timer?

    private var lightTimer: Timer?



    private var currentLitIndexes: [Int] = []



    // MARK: Init

    init() {

        createCards()
        refreshHighScore()

    }





    // MARK: Create Cards

    func createCards() {


        cards.removeAll()


        for _ in 0..<level.cardCount {


            cards.append(
                LightCard()
            )


        }


    }





    // MARK: Start Game

    func startGame() {


        refreshHighScore()

        resetGame()


        isPlaying = true


        lightRandomCards()



        gameTimer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { _ in


            DispatchQueue.main.async {


                guard self.isPlaying else {
                    return
                }


                self.timeRemaining -= 1


                self.updateLevel()



                if self.timeRemaining <= 0 {


                    self.endGame()


                }


            }


        }




        restartLightTimer()


    }






    // MARK: Reset

    func resetGame() {


        stopTimers()


        score = 0


        timeRemaining = 60


        level = .level1


        gameOver = false


        isPlaying = false


        currentLitIndexes.removeAll()


        createCards()


    }







    // MARK: End Game


    func endGame() {


        stopTimers()


        gameOver = true

        isPlaying = false



        // Turn off lights

        for index in cards.indices {

            cards[index].isLit = false

        }



        let session = GameSession(

            id: UUID(),

            mode: .lightItUp,

            score: score,

            timestamp: Date(),

            latitude: LocationService.shared.latitude,

            longitude: LocationService.shared.longitude

        )


        GameStorage.shared.saveSession(session)
        refreshHighScore()


    }

    private func refreshHighScore() {
        highScore = GameStorage.shared.bestScore(for: .lightItUp)
    }








    // MARK: Level System


    func updateLevel() {


        let newLevel: LightLevel



        switch timeRemaining {


        case 46...60:

            newLevel = .level1


        case 31...45:

            newLevel = .level2


        case 16...30:

            newLevel = .level3


        default:

            newLevel = .level4


        }





        if newLevel != level {


            level = newLevel


            showLevelFlash = true



            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.5
            ){


                self.showLevelFlash = false


            }




            createCards()


            restartLightTimer()


        }


    }








    // MARK: Light Timer


    func restartLightTimer() {


        lightTimer?.invalidate()



        lightTimer = Timer.scheduledTimer(
            withTimeInterval:
                level.lightDuration,
            repeats:true
        ){ _ in



            DispatchQueue.main.async {


                if self.isPlaying {


                    self.lightRandomCards()


                }


            }



        }


    }








    // MARK: Stop Timer


    func stopTimers() {


        gameTimer?.invalidate()

        lightTimer?.invalidate()


        gameTimer = nil

        lightTimer = nil


    }








    // MARK: Random Lights


    func lightRandomCards() {


        guard isPlaying else {
            return
        }



        for index in cards.indices {


            cards[index].isLit = false


        }



        currentLitIndexes.removeAll()



        let count = min(
            level.litCardCount,
            cards.count
        )



        while currentLitIndexes.count < count {



            let randomIndex =
            Int.random(
                in:0..<cards.count
            )



            if !currentLitIndexes.contains(
                randomIndex
            ){


                currentLitIndexes.append(
                    randomIndex
                )


            }


        }



        for index in currentLitIndexes {


            cards[index].isLit = true


        }


    }









    // MARK: Tap Card


    func tapCard(at index:Int) {



        // IMPORTANT FIX

        guard isPlaying else {

            return

        }



        guard cards.indices.contains(index)
        else {

            return

        }






        if cards[index].isLit {


            score += 1


            cards[index].isLit = false



            currentLitIndexes.removeAll {

                $0 == index

            }



        }

        else {


            // minimum score 0

            score = max(
                0,
                score - 1
            )


        }


    }



}
