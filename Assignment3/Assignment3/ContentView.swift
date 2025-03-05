//
//  ContentView.swift
//  Assignment3
//
//  Created by BMK on 05.03.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack{
            AsyncImage(url: viewModel.selectedHero?.imageUrl){stage in
                switch stage{
                case .empty:
                    Color.gray
                        .frame(height: 350)
                case .success(let image):
                    image
                        .resizable()
                        .frame(height: 350)
                case .failure:
                    Color.red
                        .frame(height: 350)
                }
            }
            
            Text("""
                 Name: \(viewModel.selectedHero?.name ?? "None")\n
                 Intelegence: \(viewModel.selectedHero?.powerstats.intelligence ?? 0)\n
                 Strength: \(viewModel.selectedHero?.powerstats.strength ?? 0)\n
                 Speed: \(viewModel.selectedHero?.powerstats.speed ?? 0)\n
                 fullname: \(viewModel.selectedHero?.biography.fullName ?? "None")\n
                 """)
            .font(.callout)
            .padding(16)
            .border(Color.green, width: 1)
            
            
            
            Button {
                Task {
                    await viewModel.takeHero()
                }
                    
            }label: {
                Text("Show a hero")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.blue)
                    .cornerRadius(15)
            }
            .padding(32)
        }
    }
}

#Preview {
    let viewModel = ViewModel()
    ContentView(viewModel: viewModel)
}
