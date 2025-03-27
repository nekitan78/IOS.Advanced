//
//  HeroListViewModel.swift
//  Assignment4
//
//  Created by BMK on 17.03.2025.
//

import SwiftUI

final class HeroListViewModel: ObservableObject {
    @Published private(set) var heroes: [HeroListModel] = []
    @Published private(set) var hero: HeroListModel?

    private let service: HeroService
    private let router: HeroRouter

    init(service: HeroService, router: HeroRouter) {
        self.service = service
        self.router = router
    }

    func fetchHeroes() async {
        do {
            let heroesResponse = try await service.fetchHeroes()

            await MainActor.run {
                heroes = heroesResponse.map {
                    HeroListModel(
                        id: $0.id,
                        title: $0.name,
                        description: $0.appearance.race ?? "No Race",
                        heroImage: $0.heroImageUrl,
                        gender: $0.appearance.gender ?? "No Gender",
                        eyeColor: $0.appearance.eyeColor ?? "No Eye Color",
                        hairColor: $0.appearance.hairColor ?? "No Hair Color",
                        intelligence: $0.powerstats?.intelligence ?? 0,
                        strength: $0.powerstats?.strength ?? 0,
                        speed: $0.powerstats?.speed ?? 0,
                        durability: $0.powerstats?.durability ?? 0,
                        power: $0.powerstats?.power ?? 0,
                        combat: $0.powerstats?.combat ?? 0,
                        placeOfBirth: $0.biography?.placeOfBirth ?? "No Place Of Birth",
                        firstAppearance: $0.biography?.firstAppearance ?? "No First Appearance"
                    )
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func routeToDetail(by id: Int) {
        router.showDetails(for: id)
    }
}
