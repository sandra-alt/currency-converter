//
//  CurrencyPickerViewModel.swift
//  currency-converter
//
//  Created by  Oleksandra on 16.12.2024.
//

import Combine
import Foundation

protocol CurrencyPickerViewModeling {
    var list: [Currency] { get }
    var onCurrencySelected: PassthroughSubject<Currency, Never> { get }
}

class CurrencyPickerViewModel: CurrencyPickerViewModeling {
    let list = Currency.allCases
    let onCurrencySelected = PassthroughSubject<Currency, Never>()
}
