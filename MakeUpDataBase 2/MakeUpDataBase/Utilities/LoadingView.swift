//
//  LoadingView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 26.04.2025.
//

import Foundation
import SwiftUI


struct ActivityIndicator: UIViewRepresentable{
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
    
    func  makeUIView(context: Context) -> UIActivityIndicatorView{
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
}

struct LoadingView: View{
    
    var body: some View{
        ZStack{
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            ActivityIndicator()
        }
    }
}
