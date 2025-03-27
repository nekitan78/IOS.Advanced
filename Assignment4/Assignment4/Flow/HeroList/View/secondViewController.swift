//
//  SecondViewController.swift
//  Assignment4
//
//  Created by BMK on 17.03.2025.
//

import SwiftUI

struct HeroDetailView: View {
    let hero: HeroListModel

    var body: some View {
        ScrollView{
            VStack {
                AsyncImage(url: hero.heroImage) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    default:
                        Color.gray
                            .frame(height: 200)
                    }
                }
                
                Text(hero.title)
                    .font(.largeTitle)
                    .padding(.top, 16)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    HStack{
                        Text("Race: \(hero.description)")
                            .font(.body)
                            .padding()
                        
                        Spacer()
                        
                        
                        Text("Gender: \(hero.gender!)")
                            .font(.body)
                            .padding()
                    }
                    HStack{
                        Text("Eye Color: \(hero.eyeColor!)")
                            .font(.body)
                            .padding()
                        
                        Spacer()
                        
                        Text("Hair Color: \(hero.hairColor!)")
                            .font(.body)
                            .padding()
                    }
                    
                    HStack{
                        Text("Intelligence: \(hero.intelligence)")
                            .font(.body)
                            .padding()
                        Spacer()
                        Text("Strength: \(hero.strength ?? 0)")
                            .font(.body)
                            .padding()
                    }
                    
                    HStack{
                        Text("Speed: \(hero.speed ?? 0)")
                            .font(.body)
                            .padding()
                        Spacer()
                        Text("Durability: \(hero.durability ?? 0)")
                            .font(.body)
                            .padding()
                    }
                    
                    HStack{
                        Text("Power: \(hero.power ?? 0)")
                            .font(.body)
                            .padding()
                        Spacer()
                        Text("Combat: \(hero.combat ?? 0)")
                            .font(.body)
                            .padding()
                    }
                    
                    HStack{
                        Text("Place of Birth: \(hero.placeOfBirth!)")
                            .font(.body)
                            .padding()
                        Spacer()
                        Text("First Appearance: \(hero.firstAppearance!)")
                            .font(.body)
                            .padding()
                    }
                }
            
                
                Spacer()
            }
            .navigationTitle("Hero Details")
        }
        
    }
}
