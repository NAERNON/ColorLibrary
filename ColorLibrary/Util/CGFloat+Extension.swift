//
//  CGFloat+Extension.swift
//  ColorLibrary
//
//  Created by Xavier Fostier on 18/06/2023.
//

import Foundation

extension CGFloat {
    var simplified: String {
        return String(format: "%.2f", Double(self))
    }
}
