//
//  CurrencyPickerTableViewCell.swift
//  currency-converter
//
//  Created by  Oleksandra on 16.12.2024.
//

import UIKit

class CurrencyPickerTableViewCell: UITableViewCell {
    
    // MARK: - Layout properties
    private struct Layout {
        static let spacing: CGFloat = 4.0
        static let margin: CGFloat = 8.0
        
        static let cornerRadius: CGFloat = 12.0
        static let shadowRadius: CGFloat = 4.0
        static let shadowOpacity: Float = 0.1
        static let shadowOffset = CGSize(width: 0, height: 2.0)
        static let shadowColor = UIColor.black.cgColor
        
        static let bgColor = UIColor.appColor(.airSuperiorityBlue)
        static let textColor = UIColor.appColor(.antiFlashWhite)
    }
    
    // MARK: - UI Components
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = Layout.bgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Layout.cornerRadius
        view.layer.shadowColor = Layout.shadowColor
        view.layer.shadowOpacity = Layout.shadowOpacity
        view.layer.shadowOffset = Layout.shadowOffset
        view.layer.shadowRadius = Layout.shadowRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = Layout.spacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = Layout.textColor
        return label
    }()
    
    let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = Layout.textColor
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        
        [currencyNameLabel, currencyCodeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            vStack.addArrangedSubview($0)
        }
        
        bgView.addSubview(vStack)
        vStack.bindFrameToSuperview(margin: Layout.margin)
        
        contentView.addSubview(bgView)
        bgView.bindFrameToSuperview(margin: Layout.margin)
        
        backgroundColor = .clear
    }
    
    // MARK: - Public
    func setupCell(currency: Currency) {
        currencyNameLabel.text = currency.name
        currencyCodeLabel.text = currency.rawValue
    }
}
