//
//  ConverterTileView.swift
//  currency-converter
//
//  Created by  Oleksandra on 13.12.2024.
//

import Combine
import UIKit

class ConverterTileView: UIView {
    
    // MARK: - Layout properties
    private struct Layout {
        static let spacing: CGFloat = 16.0
        static let horizontalSpacing: CGFloat = 24.0
        static let cornerRadius: CGFloat = 12.0
        
        static let shadowRadius: CGFloat = 4.0
        static let shadowOpacity: Float = 0.1
        static let shadowOffset = CGSize(width: 0, height: 2.0)
        static let shadowColor = UIColor.black.cgColor
        
        static let textColor = UIColor.black
        static let buttonTextColor = UIColor.black
    }
    
    // MARK: - UI Components
    private lazy var tileView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Layout.cornerRadius
        view.layer.shadowColor = Layout.shadowColor
        view.layer.shadowOpacity = Layout.shadowOpacity
        view.layer.shadowOffset = Layout.shadowOffset
        view.layer.shadowRadius = Layout.shadowRadius
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = Layout.spacing
        return view
    }()
    
    private lazy var fromHStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = Layout.horizontalSpacing
        return view
    }()
    
    private lazy var fromAmountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter amount"
        textField.textColor = Layout.textColor
        textField.backgroundColor = .clear
        return textField
    }()
    
    private lazy var fromCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PLN", for: .normal)
        button.setTitleColor(Layout.buttonTextColor, for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var toHStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = Layout.horizontalSpacing
        return view
    }()
    
    private lazy var toAmmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.textColor = Layout.textColor
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var toCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("JPY", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    // MARK: - Variables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Setup
    private func setupView() {
        
        // Add the elements of the top row of the tile to a horizontal stack
        [fromAmountTextField, fromCurrencyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            fromHStack.addArrangedSubview($0)
        }
        
        // Add the elements of the bottom row of the tile to another horizontal stack
        [toAmmountLabel, toCurrencyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            toHStack.addArrangedSubview($0)
        }
        
        // Add constraints for a separator
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Add all rows to a vStack
        [fromHStack, separatorView, toHStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            vStack.addArrangedSubview($0)
        }
        
        // Add and pin a vStack to the tile view
        tileView.addSubview(vStack)
        vStack.bindFrameToSuperview(margin: Layout.spacing)
        
        // Add and pin the tile view to a container view
        addSubview(tileView)
        tileView.bindFrameToSuperview()
    }
}
