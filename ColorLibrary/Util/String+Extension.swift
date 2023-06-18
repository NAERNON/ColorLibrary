//
//  String+Extension.swift
//  ColorLibrary
//
//  Created by Xavier Fostier on 18/06/2023.
//

import Foundation

extension String {
    
    /// Convert sentence to one camelCased word
    var spacesToCamelCase: String {
        let array = self.components(separatedBy: " ")
        return array[0].lowercased().appending( array.dropFirst().map {
            $0.capitalized
        }.joined())
    }
}
