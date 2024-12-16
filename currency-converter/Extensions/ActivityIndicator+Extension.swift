//
//  ActivityIndicator+Extension.swift
//  currency-converter
//
//  Created by  Oleksandra on 16.12.2024.
//

import UIKit

extension UIActivityIndicatorView {
    func shouldAnimate(_ state: Bool) {
        state ? self.startAnimating() : self.stopAnimating()
    }
}
