import Foundation

struct Product: Decodable, Identifiable {
    let id: Int
    let brand: String?
    let name: String?
    let image_url: String?
    let url: String?
    let price: String?
    let rating: String?
    let description: String?
    let how_to_use: String?
    let benefits: String?
    let full_ingredient_list: String?
    let sustainability: [String]
}

extension Product {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "brand": brand as Any,
            "name": name as Any,
            "image_url": image_url as Any,
            "url": url as Any,
            "price": price as Any,
            "rating": rating as Any,
            "description": description as Any,
            "how_to_use": how_to_use as Any,
            "benefits": benefits as Any,
            "full_ingredient_list": full_ingredient_list as Any,
            "sustainability": sustainability
        ]
    }

    init(from dict: [String: Any]) {
        self.id = dict["id"] as? Int ?? -1
        self.brand = dict["brand"] as? String
        self.name = dict["name"] as? String
        self.image_url = dict["image_url"] as? String
        self.url = dict["url"] as? String
        self.price = dict["price"] as? String
        self.rating = dict["rating"] as? String
        self.description = dict["description"] as? String
        self.how_to_use = dict["how_to_use"] as? String
        self.benefits = dict["benefits"] as? String
        self.full_ingredient_list = dict["full_ingredient_list"] as? String
        self.sustainability = dict["sustainability"] as? [String] ?? []
    }
}
