import Foundation
import SwiftUI

@MainActor
final class BarcodeViewModel: ObservableObject {
    @Published var product: Product?
    @Published var scannedBarcode: String = ""
    @Published var isLoadingImage: Bool = false
    @Published var alertMessage: AlertItem?
    let router: BarcodeRouter
    
    init(router: BarcodeRouter) {
        self.router = router
    }
    
    func getProductInfo() async {
        isLoadingImage = true
        guard !scannedBarcode.isEmpty else { return }
        
        let urlString = "https://api.upcitemdb.com/prod/trial/lookup?upc=\(scannedBarcode)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                
                // If we get an error status code, print the response body for debugging
                if httpResponse.statusCode != 200 {
                    if let errorString = String(data: data, encoding: .utf8) {
                        print("Error response: \(errorString)")
                    }
                    alertMessage = ErrorContext.productError
                    return
                }
            }
            
            let decodedData = try JSONDecoder().decode(BarCodeProduct.self, from: data)
            
            if !decodedData.items.isEmpty {
                let item = decodedData.items[0] // Get the first item
                guard let id = Int(scannedBarcode) else { return }
                
                // Find the first valid image URL
                let imageUrl = await findValidImageUrl(from: item.images)
                
                // Create a Product object from the API data
                product = Product(
                    id: id,
                    brand: item.brand,
                    name: item.title,
                    image_url: imageUrl,
                    url: item.offers?.first?.link ?? "no link",
                    price: "$\(item.lowest_recorded_price?.doubleValue ?? 0.0)",
                    rating: "",
                    description: item.description ?? "",
                    how_to_use: "",
                    benefits: "",
                    full_ingredient_list: "",
                    sustainability: [""]
                )
            }else{
                alertMessage = ErrorContext.productError
            }
            isLoadingImage = false
            
        } catch {
            print("Error fetching or decoding product info: \(error)")
            alertMessage = ErrorContext.decodingFailed
        }
    }
    
    // Function to find a valid image URL from an array of URLs
    private func findValidImageUrl(from urls: [String]) async -> String {
        // If the array is empty, return empty string
        guard !urls.isEmpty else { return "" }
        
        // Try each URL until a valid one is found
        for urlString in urls {
            // Check if the URL is valid
            guard let url = URL(string: urlString), !urlString.isEmpty else {
                continue // Skip invalid URLs
            }
            
            // Attempt to load the image data
            do {
                let (_, response) = try await URLSession.shared.data(from: url)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // If we get a successful response, this URL is valid
                    return urlString
                }
            } catch {
                print("Failed to load image from URL: \(urlString), error: \(error)")
                continue
            }
        }
        return "" 
    }

}
