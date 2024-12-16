//
//  SceneDelegate.swift
//  currency-converter
//
//  Created by  Oleksandra on 12.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setupWindow(with: windowScene)
    }
    
    // Configure the main application window
    private func setupWindow(with windowScene: UIWindowScene) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createRootViewController()
        window?.makeKeyAndVisible()
    }
    
    // Create the root view controller with its dependencies
    private func createRootViewController() -> UINavigationController {
        
        // Set up the dependency chain for the converter view
        let networkService = ConverterNetworkService()
        let networkRepository = ConverterNetworkRepository(networkService: networkService)
        let viewModel = ConverterViewModel(repository: networkRepository)
        let rootViewController = ConverterViewController(title: "Converter", viewModel: viewModel)
        
        return UINavigationController(rootViewController: rootViewController)
    }
}
