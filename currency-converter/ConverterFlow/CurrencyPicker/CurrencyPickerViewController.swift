//
//  CurrencyPickerViewController.swift
//  currency-converter
//
//  Created by  Oleksandra on 16.12.2024.
//

import Combine
import UIKit

class CurrencyPickerViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: CurrencyPickerViewModeling
    private lazy var adapter: CurrencyPickerTableAdapter<AnyHashable> = {
        CurrencyPickerTableAdapter(tableView: tableView)
    }()
    
    // MARK: - Initialization
    required init(viewModel: CurrencyPickerViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle and setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        fillInTable()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.bindFrameToSuperview()
        
        // Configure the background
        let color = [
            UIColor.appColor(.blue)?.cgColor,    // Start color
            UIColor.appColor(.uranianBlue)?.cgColor // End color
        ]
        
        view.backgroundColor = UIColor.appColor(.blue)
    }
    
    private func bind() {
        adapter.didSelectRow
            .sink { [weak self] currency in
                self?.viewModel.onCurrencySelected.send(currency)
            }.store(in: &cancellables)
    }
    
    private func fillInTable() {
        adapter.update(items: viewModel.list)
    }
}
