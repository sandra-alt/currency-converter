//
//  ConverterViewModel.swift
//  currency-converter
//
//  Created by  Oleksandra on 16.12.2024.
//

import Combine
import Foundation

class ConverterViewModel: ConverterViewModeling {
    
    // MARK: - Properties
    var cancellables: Set<AnyCancellable> = []
    @Published private var error: String?
    @Published private var amount: String?
    
    // Input
    let viewDidLoad = PassthroughSubject<Void, Never>()
    let onAmountTyped = PassthroughSubject<String, Never>()

    let didSelectFromCurrency = CurrentValueSubject<Currency, Never>(.USD)
    let didSelectToCurrency = CurrentValueSubject<Currency, Never>(.EUR)
    
    //Output
    var onError: AnyPublisher<String, Never> {
        $error.compactMap({ $0 }).eraseToAnyPublisher()
    }
    
    var onAmountReceived: AnyPublisher<String, Never> {
        $amount.compactMap({ $0 }).eraseToAnyPublisher()
    }
    
    // MARK: - Services
    private let exchangeRepository: ConverterRepositoryProtocol
    
    // MARK: - Init
    init(repository: ConverterRepositoryProtocol) {
        self.exchangeRepository = repository
        self.bind()
    }
    
    private func bind() {
        Publishers.CombineLatest3(onAmountTyped, didSelectFromCurrency, didSelectToCurrency)
            .sink { [weak self] amount, fromCurrency, toCurrency in
                let model = ConverterRequestModel(fromAmount: amount, fromCurrency: fromCurrency.rawValue, toCurrency: toCurrency.rawValue)
                self?.exchange(model: model)
            }.store(in: &cancellables)
    }
    
    private func exchange(model: ConverterRequestModel) {
        exchangeRepository.exchangePublisher(model: model)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Conversion completed")
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { [weak self] response in
                self?.amount = response.amount
                
                print("Converted amount: \(response.amount) \(response.currency)")
            })
            .store(in: &cancellables)
    }
}
