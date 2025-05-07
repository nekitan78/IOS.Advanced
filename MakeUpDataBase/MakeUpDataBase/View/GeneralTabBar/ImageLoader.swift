//
//  ImageLoader.swift
//  MakeUpDataBase
//
//  Created to fix image loading issues
//

import SwiftUI
import Combine
import Firebase
import FirebaseStorage

class ImageLoaderService: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    private var cache = ImageCache.shared
    private var url: URL?
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            return
        }
        
        self.url = url
        
        // Check cache first
        if let cachedImage = cache.get(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        // Handle Firebase Storage URLs properly
        if urlString.contains("firebasestorage.googleapis.com") {
            print("📸 Loading Firebase Storage image from: \(urlString)")
            
            // Create a reference to the file
            let storageRef = Storage.storage().reference(forURL: urlString)
            
            // Download in memory with a maximum allowed size of 5MB
            storageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Firebase Storage error: \(error.localizedDescription)")
                    } else if let data = data, let image = UIImage(data: data) {
                        print("✅ Firebase image loaded successfully")
                        self.image = image
                        self.cache.set(image, forKey: urlString)
                    }
                }
            }
        } else {
            // Standard URL loading for non-Firebase URLs
            print("📸 Loading standard image from: \(urlString)")
            
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] loadedImage in
                    guard let self = self else { return }
                    
                    if let loadedImage = loadedImage {
                        self.image = loadedImage
                        self.cache.set(loadedImage, forKey: urlString)
                    }
                }
        }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

// Simple image cache
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

struct ImageLoader: View {
    let imageURL: String
    let width: CGFloat
    let height: CGFloat
    @Binding var isLoading: Bool
    @Binding var alertItem: AlertItem?
    @StateObject private var loader = ImageLoaderService()
    
    var body: some View {
        ZStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
            } else {
                Image(.empty)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
            }
        }
        .onAppear {
            isLoading = true
            loader.loadImage(from: imageURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoading = false
            }
        }
        .onDisappear {
            loader.cancel()
        }
    }
}
