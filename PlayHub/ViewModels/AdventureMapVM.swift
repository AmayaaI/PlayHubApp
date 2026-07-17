//
//  AdventureMapVM.swift
//  PlayHub
//
//  Created by Amaya Mahavithane on 2026-07-17.
//



import Foundation
import SwiftUI
import Combine


class AdventureMapVM: ObservableObject {


    @Published var nodes:[AdventureNode] = []

    private var sessions:[GameSession] = []


    init(){

        loadProgress()

    }



    func loadProgress(){


        sessions = GameStorage.shared.loadSessions()



        let tapScore =
        sessions
            .filter{$0.mode == .tapFrenzy}
            .map{$0.score}
            .max() ?? 0



        let lightScore =
        sessions
            .filter{$0.mode == .lightItUp}
            .map{$0.score}
            .max() ?? 0



        let quizScore =
        sessions
            .filter{$0.mode == .quizRush}
            .map{$0.score}
            .max() ?? 0




        nodes = [



            AdventureNode(

                title:"Tap Mountain",

                subtitle:"Master speed tapping",

                icon:"bolt.fill",

                color:"orange",

                unlocked:true,

                position:0

            ),



            AdventureNode(

                title:"Light Valley",

                subtitle:"Find glowing cards",

                icon:"lightbulb.fill",

                color:"yellow",

                unlocked: tapScore >= 20,

                position:1

            ),




            AdventureNode(

                title:"Quiz Island",

                subtitle:"Knowledge challenge",

                icon:"questionmark.circle.fill",

                color:"green",

                unlocked: lightScore >= 20,

                position:2

            ),





            AdventureNode(

                title:"Champion Gate",

                subtitle:"Become PlayHub Master",

                icon:"trophy.fill",

                color:"purple",

                unlocked: quizScore > 0,

                position:3

            )


        ]


    }

}
