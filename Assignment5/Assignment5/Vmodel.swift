import Foundation
import SwiftUI

final class Vmodel: ObservableObject {
    
    @Published var resImage: [ImageModel] = []
    @Published var rightImage: [ImageModel] = []
    
    func getImage(urlString: String, completion: @escaping (ImageModel) -> Void) {
        guard let url = URL(string: urlString) else {
            retryImageLoad(completion: completion)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                self.retryImageLoad(completion: completion)
                return
            }
            
            if let safeData = data, let uiImage = UIImage(data: safeData) {
                let convImage = Image(uiImage: uiImage)
                let imageModel = ImageModel(image: convImage)
                completion(imageModel)
            } else {
                self.retryImageLoad(completion: completion)
            }
        }.resume()
    }
    
    private func retryImageLoad(completion: @escaping (ImageModel) -> Void) {
        let randomId = Int.random(in: 0...1000)
        let newUrl = "https://picsum.photos/id/\(randomId)/500"
        getImage(urlString: newUrl, completion: completion)
    }
    
    func GetAllImage() {
        DispatchQueue.main.async {
            self.resImage.removeAll()
            self.rightImage.removeAll()
        }
        
        let group = DispatchGroup()
        var tempArray: [ImageModel] = []
        var tempArray2: [ImageModel] = []
        
        for _ in 0..<3 {
            let randomId = Int.random(in: 0...1000)
            let url = "https://picsum.photos/id/\(randomId)/500"
            
            group.enter()
            getImage(urlString: url) { imageModel in
                tempArray.append(imageModel)
                group.leave()
            }
        }
        
        for _ in 0..<2 {
            let randomId2 = Int.random(in: 0...1000)
            let url2 = "https://picsum.photos/id/\(randomId2)/500"
            
            group.enter()
            getImage(urlString: url2) { imageModel in
                tempArray2.append(imageModel)
                group.leave()
            }
        }
        
        
        
        group.notify(queue: .main) {
            self.resImage = tempArray
            self.rightImage = tempArray2
        }
    }
}

struct ImageModel: Identifiable {
    let image: Image
    let id = UUID()
}
