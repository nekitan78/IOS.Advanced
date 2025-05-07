//
//  BarCodeProduct.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 07.05.2025.
//


struct BarCodeProduct: Decodable {
    let code: String?
    let total: Int?
    let offset: Int?
    let items: [Item]
    
    struct Item: Decodable {
        let ean: String?
        let title: String
        let upc: String?
        let gtin: String?
        let asin: String?
        let description: String?
        let brand: String
        let model: String?
        let dimension: String?
        let weight: String?
        let category: String?
        let currency: String?
        let lowest_recorded_price: CustomValue?
        let highest_recorded_price: CustomValue?
        let images: [String]
        let offers: [Offer]?
    }
    
    struct Offer: Decodable {
        let merchant: String?
        let domain: String?
        let title: String?
        let currency: String?
        let list_price: CustomValue?
        let price: CustomValue?
        let shipping: String?
        let condition: String?
        let availability: String?
        let link: String?
        let updated_t: Int?
    }
}

// A custom type that can handle both string and numeric values
struct CustomValue: Decodable {
    let value: Any
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else {
            value = ""
        }
    }
    
    // Helper methods to get the value in different types
    var stringValue: String {
        if let v = value as? String {
            return v
        } else if let v = value as? Int {
            return String(v)
        } else if let v = value as? Double {
            return String(v)
        } else {
            return ""
        }
    }
    
    var doubleValue: Double {
        if let v = value as? Double {
            return v
        } else if let v = value as? Int {
            return Double(v)
        } else if let v = value as? String, let d = Double(v) {
            return d
        } else {
            return 0.0
        }
    }
    
    var intValue: Int {
        if let v = value as? Int {
            return v
        } else if let v = value as? Double {
            return Int(v)
        } else if let v = value as? String, let i = Int(v) {
            return i
        } else {
            return 0
        }
    }
}