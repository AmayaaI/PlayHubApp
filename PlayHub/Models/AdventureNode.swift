//
//  AdventureNode.swift
//  PlayHub
//
//  Created by Amaya Mahavithane on 2026-07-17.
//

//
//  AdventureNode.swift
//  PlayHub
//

import Foundation


struct AdventureNode: Identifiable {

    let id = UUID()

    let title: String

    let subtitle: String

    let icon: String

    let color: String

    var unlocked: Bool

    var position: CGFloat

}
