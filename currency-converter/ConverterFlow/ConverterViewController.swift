//
//  ConverterViewController.swift
//  currency-converter
//
//  Created by  Oleksandra on 12.12.2024.
//

import Combine
import UIKit

class ConverterViewController: UIViewController {
    
    // MARK: - Layout
    private struct Layout {
        static let topSpace: CGFloat = 48.0
        static let margin: CGFloat = 24.0
        static let bottomSpace: CGFloat = 16.0
    }
    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = []
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var gradientLayer: CAGradientLayer?
    
    private let tempConverterRepository = ConverterNetworkRepository(networkService: ConverterNetworkService()) // Temp - to check if network works correctly
    
    private var requestTask: Task<Void, Never>?
    
    var viewModel: ConverterViewModeling
    
    // MARK: - UI Components
    private lazy var vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = Layout.bottomSpace
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tileView: ConverterTileView = {
        let view = ConverterTileView()
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initialization
    init(title: String, viewModel: ConverterViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        // Setup a title
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup views
        setupScrollView()
        setupUI()
        bind(with: viewModel)
        
        // Temp
        //startRepeatingRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the gradient layer's frame to match the view's bounds
        gradientLayer?.frame = view.bounds
    }

    deinit {
        stopRepeatingRequest()
    }
    
    // MARK: - Scroll View Setup
    private func setupScrollView() {
        // Add scrollView to the main view
        view.addSubview(scrollView)
        
        // Enable Auto Layout for the scrollView and pin the scrollView to the edges of the view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bindFrameToSuperview()
        
        // Add a content view inside the scroll view
        scrollView.addSubview(contentView)
        
        // Enable Auto Layout for the contentView and pin the contentView to the scrollView's edges
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.bindFrameToSuperview()
        
        // Match contentView width and height for horizontal and vertical scrolling
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        // Configure the background
        let color = [
            UIColor.appColor(.blue)?.cgColor,    // Start color
            UIColor.appColor(.airSuperiorityBlue)?.cgColor, // Middle color
            UIColor.appColor(.uranianBlue)?.cgColor // End color
        ]
        setupGradientBackground(colors: color)
        
        // Add a tile view and an error label to the content view
        [tileView, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            vStack.addArrangedSubview($0)
        }
        contentView.addSubview(vStack)
        
        // Pin the tile view to the edges of the content view
        vStack.bindFrameToSuperview(top: Layout.topSpace, leading: Layout.margin, trailing: Layout.margin)
    }
    
    // MARK: - Temp timer
    private func startRepeatingRequest() {
        requestTask = Task {
            while !Task.isCancelled {
                await triggerRequest()
                try? await Task.sleep(nanoseconds: 10 * 1_000_000_000) // 10 seconds
            }
        }
    }

    private func stopRepeatingRequest() {
        requestTask?.cancel()
        requestTask = nil
    }
    
    private func triggerRequest() async {
        // Temp
//        let model = ConverterRequestModel(fromAmount: "100.00", fromCurrency: "PLN", toCurrency: "EUR")
//        do {
//            let result = try await tempConverterRepository.exchange(model: model)
//            print(result)
//        } catch {
//            print("-error-")
//        }
    }
    
    // MARK: - Binding
    
    func bind(with viewModel: ConverterViewModeling) {
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                
                self.tileView.showActivityIndicator(isLoading: isLoading)
            }.store(in: &cancellables)
        
        viewModel.onAmountReceived
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                
                self.showError(nil)
                self.tileView.amountExhcanged = value
            }.store(in: &cancellables)
        
        viewModel.onError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                
                self.tileView.amountExhcanged = "-.--"
                self.showError(error)
            }.store(in: &cancellables)
        
        tileView.fromAmount
            .sink { [weak self] value in
                guard let self = self else { return }
                
                guard !value.isEmpty else {
                    self.showError(nil)
                    self.tileView.amountExhcanged = "-.--"
                    return
                }
                self.startRepeatingRequest()
                viewModel.onAmountTyped.send(value)
            }.store(in: &cancellables)
        
        tileView.fromCurrencyTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // Present picker
                self.showCurrencyPicker(completion: { currency in
                    self.viewModel.didSelectFromCurrency.send(currency)
                    self.tileView.fromCurrencySelected = currency
                })
            }.store(in: &cancellables)

        tileView.toCurrencyTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // Present picker
                self.showCurrencyPicker(completion: { currency in
                    self.viewModel.didSelectToCurrency.send(currency)
                    self.tileView.toCurrencySelected = currency
                })
            }.store(in: &cancellables)
    }
    
    private func showCurrencyPicker(completion: @escaping (Currency) -> Void) {
        let vm = CurrencyPickerViewModel()
        let vc = CurrencyPickerViewController(viewModel: vm)
        
        vm.onCurrencySelected
            .receive(on: DispatchQueue.main)
            .sink { currency in
                completion(currency)
                vc.dismiss(animated: true)
            }.store(in: &cancellables)
        
        present(vc, animated: true)
    }
    
    private func showError(_ error: String?) {
        guard let error = error else {
            errorLabel.isHidden = true
            return
        }
        
        errorLabel.isHidden = error.isEmpty
        errorLabel.text = error
    }
}

extension ConverterViewController {
    func setupGradientBackground(colors: [CGColor?]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Top-left corner
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)   // Bottom-right corner
        gradientLayer.frame = view.bounds
        
        self.gradientLayer = gradientLayer
        
        // Add the gradient layer to the view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
