//
//  HeroListModel.swift
//  Assignment4
//
//  Created by BMK on 17.03.2025.
//

import Foundation

struct HeroListModel: Identifiable {
    let id: Int
    let title: String
    let description: String
    let heroImage: URL?
    let gender: String?
    let eyeColor: String?
    let hairColor: String?
    let intelligence: Int
    let strength: Int?
    let speed: Int?
    let durability: Int?
    let power: Int?
    let combat: Int?
    let placeOfBirth: String?
    let firstAppearance: String?
}
