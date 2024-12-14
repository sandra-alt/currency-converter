//
//  UIView+Extension.swift
//  currency-converter
//
//  Created by  Oleksandra on 13.12.2024.
//

import UIKit

extension UIView {
    func bindFrameToSuperview(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        guard let superview = self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        superview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottom).isActive = true
        superview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailing).isActive = true
    }
    
    func bindFrameToSuperview(margin: CGFloat) {
        bindFrameToSuperview(top: margin, leading: margin, bottom: margin, trailing: margin)
    }
}
