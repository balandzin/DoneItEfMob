//
//  UIColor + Ex.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 18.02.25.
//

import UIKit

extension UIColor {
    static let lightGrayBackground = UIColor(hex: "#F4F4F4")
    static let darkPrimary = UIColor(hex: "#040404")
    static let accentYellow = UIColor(hex: "#fed702")
    static let darkSecondary = UIColor(hex: "#272729")
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
