//
//  NumericTextField.swift
//  currency-converter
//
//  Created by  Oleksandra on 14.12.2024.
//

import UIKit
import Combine
import CombineCocoa

class NumericTextField: UITextField {
    // Published property to track valid numeric input
    @Published private(set) var validNumericText: String = ""
    
    // Combine cancellables
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNumericValidation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNumericValidation()
    }
    
    private func setupNumericValidation() {
        // Observe text changes
        textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .map { [weak self] text -> String in
                guard let self = self else { return "" }
                return self.sanitizeNumericInput(text)
            }
            .assign(to: \.text, on: self)
            .store(in: &cancellables)

    }
    
    private func sanitizeNumericInput(_ input: String) -> String {
        // Replace commas with dots for consistency
        let normalizedInput = input.replacingOccurrences(of: ",", with: ".")
        
        // Filter valid characters
        var hasDecimalPoint = false

        return normalizedInput.reduce(into: "") { result, character in
            if character.isNumber || (!hasDecimalPoint && character == ".") {
                result.append(character)
                if character == "." { hasDecimalPoint = true }
            }
        }
    }
}
