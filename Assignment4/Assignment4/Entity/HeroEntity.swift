//
//  HeroEntity.swift
//  Assignment4
//
//  Created by BMK on 17.03.2025.
//

import Foundation

struct HeroEntity: Decodable {
    let id: Int
    let name: String
    let appearance: Appearance
    let images: HeroImage
    let powerstats: Powerstats?
    let biography: Biography?
    
    struct Biography: Decodable {
        let fullName: String?
        let alterEgos: String?
        let aliases: [String]?
        let placeOfBirth: String?
        let firstAppearance: String?
    }

    
    struct Powerstats: Decodable {
        let intelligence: Int?
        let strength: Int?
        let speed: Int?
        let durability: Int?
        let power: Int?
        let combat: Int?
    }
    
    var heroImageUrl: URL? {
        URL(string: images.sm)
    }

    struct Appearance: Decodable {
        let race: String?
        let gender: String?
        let eyeColor: String?
        let hairColor: String?
    }

    struct HeroImage: Decodable {
        let sm: String
        let md: String
    }
}
