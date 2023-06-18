//
//  ColorInfo.swift
//  ColorLibrary
//
//  Created by Vivien BERNARD on 20/04/2023.
//

import Foundation

final class ColorInfo: Identifiable, Hashable, Codable, ObservableObject {
    @Published var title: String
    
    let id: UUID
    
    @Published var red: CGFloat
    @Published var green: CGFloat
    @Published var blue: CGFloat
    
    init(title: String, red: CGFloat, green: CGFloat, blue: CGFloat, id: UUID = UUID()) {
        self.title = title
        self.red = red
        self.green = green
        self.blue = blue
        self.id = id
    }
    
    static func == (lhs: ColorInfo, rhs: ColorInfo) -> Bool {
        // lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.red == rhs.red &&
        lhs.green == rhs.green &&
        lhs.blue == rhs.blue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(id)
        hasher.combine(red)
        hasher.combine(green)
        hasher.combine(blue)
    }
    
    func distance(to other: ColorInfo) -> CGFloat {
        let red = self.red - other.red
        let green = self.green - other.green
        let blue = self.blue - other.blue
        return (red*red + green*green + blue*blue).squareRoot()
    }
    
    func red(_ value: CGFloat) -> ColorInfo {
        .init(title: title, red: value, green: green, blue: blue)
    }
    
    func green(_ value: CGFloat) -> ColorInfo {
        .init(title: title, red: red, green: value, blue: blue)
    }
    
    func blue(_ value: CGFloat) -> ColorInfo {
        .init(title: title, red: red, green: green, blue: value)
    }
    
    enum CodingKeys: String, CodingKey {
            case id
            case title
            case red
            case green
            case blue
        }
    
    // MARK: - Codable
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(id, forKey: .id)
            try container.encode(title, forKey: .title)
            try container.encode(red, forKey: .red)
            try container.encode(green, forKey: .green)
            try container.encode(blue, forKey: .blue)
        }
    
    init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)

            id = try values.decode(UUID.self, forKey: .id)
            title = try values.decode(String.self, forKey: .title)
            red = try values.decode(CGFloat.self, forKey: .red)
            green = try values.decode(CGFloat.self, forKey: .green)
            blue = try values.decode(CGFloat.self, forKey: .blue)
        }
}

// MARK: - Formatted code

extension ColorInfo {
    
    var swiftUI: String {
        return "static let \(title.spacesToCamelCase) = Color(red: \(red.simplified), green: \(green.simplified), blue: \(blue.simplified))"
    }
    
    var uiKit: String {
        return "static let \(title.spacesToCamelCase) = UIColor(red: \(red.simplified), green: \(green.simplified), blue: \(blue.simplified), alpha: 1)"
    }
}

// MARK: - Colors

extension ColorInfo {
    static var red: ColorInfo {
        .init(title: "Red", red: 255/255, green: 0/255, blue: 0/255)
    }
    
    static var green: ColorInfo {
        .init(title: "Green", red: 0/255, green: 255/255, blue: 0/255)
    }
    
    static var blue: ColorInfo {
        .init(title: "Blue", red: 0/255, green: 0/255, blue: 255/255)
    }
    
    static var salmon: ColorInfo {
        .init(title: "Salmon", red: 255/255, green: 126/255, blue: 121/255)
    }
    
    static var carnation: ColorInfo {
        .init(title: "Carnation", red: 255/255, green: 138/255, blue: 216/255)
    }
    
    static var seaFoam: ColorInfo {
        .init(title: "Sea Foam", red: 0/255, green: 255/255, blue: 146/255)
    }
    
    static var eggPlant: ColorInfo {
        .init(title: "Egg Plant", red: 83/255, green: 27/255, blue: 147/255)
    }
    
    static var lemon: ColorInfo {
        .init(title: "Lemon", red: 255/255, green: 251/255, blue: 0/255)
    }
    
    static var orchid: ColorInfo {
        .init(title: "Orchid", red: 122/255, green: 129/255, blue: 255/255)
    }
    
    static var cantaloupe: ColorInfo {
        .init(title: "Cantaloupe", red: 255/255, green: 212/255, blue: 121/255)
    }
}
