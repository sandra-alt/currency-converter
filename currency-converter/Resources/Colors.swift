//
//  Colors.swift
//  currency-converter
//
//  Created by  Oleksandra on 16.12.2024.
//

import UIKit

enum AssetsColor {
   case airSuperiorityBlue
   case antiFlashWhite
   case battleshipGray
   case blue
   case uranianBlue
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .airSuperiorityBlue:
            return UIColor(named: "airSuperiorityBlue")
        case .antiFlashWhite:
            return UIColor(named: "antiFlashWhite")
        case .battleshipGray:
            return UIColor(named: "battleshipGray")
        case .blue:
            return UIColor(named: "blue")
        case .uranianBlue:
            return UIColor(named: "uranianBlue")
        }
    }
}
