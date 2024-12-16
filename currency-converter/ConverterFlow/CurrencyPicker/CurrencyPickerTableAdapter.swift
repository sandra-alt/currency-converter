//
//  CurrencyPickerTableAdapter.swift
//  currency-converter
//
//  Created by  Oleksandra on 16.12.2024.
//

import Combine
import CombineCocoa
import UIKit

final class CurrencyPickerTableAdapter<Item: Hashable> {
    
    private enum Section: CaseIterable {
        case main
    }

    // MARK: - Private properties
    private let tableView: UITableView
    private var items: [Item] = []
    
    // Publishers
    var didSelectRow: AnyPublisher<Currency, Never> {
        tableView.didSelectRowPublisher
            .compactMap { [weak self] indexPath in
                self?.items[indexPath.row] as? Currency
            }.eraseToAnyPublisher()
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = {
        let dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { [weak self] tableView, indexPath, item -> UITableViewCell? in
            let cellId = self?.getCellIdentifier() ?? "Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            self?.renderCell(item, cell)
            return cell
        }
        return dataSource

    }()
    
    // MARK: - Initialization
    init(tableView: UITableView) {
        self.tableView = tableView
        self.registerCells(tableView)
    }
    
    // MARK: - Public methods
    func update(items: [Item], animated: Bool = true) {
        guard items != self.items else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.defaultRowAnimation = .fade
        dataSource.apply(snapshot, animatingDifferences: animated)
        self.items = items
    }
}

extension CurrencyPickerTableAdapter {
    func registerCells(_ tableView: UITableView) {
        tableView.register(
            CurrencyPickerTableViewCell.self,
            forCellReuseIdentifier: CurrencyPickerTableViewCell.reuseIdentifier
        )
    }
    
    private func getCellIdentifier() -> String {
        CurrencyPickerTableViewCell.reuseIdentifier
    }
    
    private func renderCell(_ item: Item, _ cell: UITableViewCell) {
        switch (item, cell) {
        case (let item as Currency, let cell as CurrencyPickerTableViewCell):
            cell.setupCell(currency: item)
        default:
            break
        }
    }
}
