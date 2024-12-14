//
//  ConverterViewController.swift
//  currency-converter
//
//  Created by  Oleksandra on 12.12.2024.
//

import UIKit

class ConverterViewController: UIViewController {
    
    // MARK: - Layout
    private struct Layout {
        static let topSpace: CGFloat = 48.0
        static let margin: CGFloat = 24.0
    }
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - UI Components
    private lazy var tileView: ConverterTileView = {
        let view = ConverterTileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    init(title: String) {
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
        view.backgroundColor = .systemGray4
        
        // Add a tile view inside the content view
        contentView.addSubview(tileView)
        
        // Pin the tile view to the edges of the content view
        tileView.bindFrameToSuperview(top: Layout.topSpace, leading: Layout.margin, trailing: Layout.margin)
    }
}
