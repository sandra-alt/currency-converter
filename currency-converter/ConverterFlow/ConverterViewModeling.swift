//
//  ConverterViewModeling.swift
//  currency-converter
//
//  Created by  Oleksandra on 16.12.2024.
//

import Combine
import Foundation

protocol ConverterViewModeling: ConverterViewModelInput, ConverterViewModelOutput { }

protocol ConverterViewModelInput {
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
    var onAmountTyped: PassthroughSubject<String, Never> { get }

    var didSelectFromCurrency: CurrentValueSubject<Currency, Never> { get }
    var didSelectToCurrency: CurrentValueSubject<Currency, Never> { get }
}

protocol ConverterViewModelOutput {
    var onError: AnyPublisher<String, Never> { get }
    var onAmountReceived: AnyPublisher<String, Never> { get }
}
