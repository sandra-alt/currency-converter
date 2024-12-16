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
    private var requestTask: Task<Void, Never>?
    
    private var cancellables: Set<AnyCancellable> = []
    @Published private var error: String?
    @Published private var amount: String?
    
    // Input
    let viewDidLoad = PassthroughSubject<Void, Never>()
    let onAmountTyped = PassthroughSubject<String, Never>()

    let didSelectFromCurrency = CurrentValueSubject<Currency, Never>(.USD)
    let didSelectToCurrency = CurrentValueSubject<Currency, Never>(.EUR)
    
    let timeTriggered = PassthroughSubject<Void, Never>()
    
    //Output
    var onError: AnyPublisher<String, Never> {
        $error.compactMap({ $0 }).eraseToAnyPublisher()
    }
    
    var onAmountReceived: AnyPublisher<String, Never> {
        $amount.compactMap({ $0 }).eraseToAnyPublisher()
    }
    
    let isLoading = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Services
    private let exchangeRepository: ConverterRepositoryProtocol
    
    // MARK: - Initialization
    init(repository: ConverterRepositoryProtocol) {
        self.exchangeRepository = repository
        self.bind()
        startRepeatingRequest()
    }
    
    deinit {
        stopRepeatingRequest()
    }
    
    private func bind() {
        Publishers.CombineLatest4(onAmountTyped.filter { !$0.isEmpty },
                                  didSelectFromCurrency,
                                  didSelectToCurrency,
                                  timeTriggered)
            .sink { [weak self] amount, fromCurrency, toCurrency, _ in
                let model = ConverterRequestModel(fromAmount: amount, fromCurrency: fromCurrency.rawValue, toCurrency: toCurrency.rawValue)
                self?.exchange(model: model)
                self?.isLoading.send(true)
            }.store(in: &cancellables)
        
        Publishers.Merge(onError, onAmountReceived)
            .map { _ in false }
            .subscribe(isLoading)
            .store(in: &cancellables)
    }
    
    private func exchange(model: ConverterRequestModel) {
        exchangeRepository.exchangePublisher(model: model)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Conversion completed")
                case .failure(let error):
                    guard let self = self, let error = error as? NetworkError else { return }
                    self.error = error.errorInfo
                }
            }, receiveValue: { [weak self] response in
                self?.amount = response.amount
                
                print("Converted amount: \(response.amount) \(response.currency)")
            })
            .store(in: &cancellables)
    }

    // MARK: - Timer
    private func startRepeatingRequest() {
        requestTask = Task {
            while !Task.isCancelled {
                timeTriggered.send(())
                try? await Task.sleep(nanoseconds: 10 * 1_000_000_000) // 10 seconds
            }
        }
    }

    private func stopRepeatingRequest() {
        requestTask?.cancel()
        requestTask = nil
    }
}
