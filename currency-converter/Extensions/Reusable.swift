//
//  Reusable.swift
//  currency-converter
//
//  Created by  Oleksandra on 16.12.2024.
//

import UIKit

// MARK: - Protocol definition
protocol Reusable: AnyObject {
    // The reuse identifier to use when registering and later dequeuing a reusable cell
    static var reuseIdentifier: String { get }
}

// MARK: - Default implementation
extension Reusable {
    // By default, use the name of the class as String for its reuseIdentifier
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable { }
