//
//  CleanTodoRouter.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit

// MARK: - Router Protocol
protocol CleanTodoRoutingLogic {
    func routeToTodoDetail()
    func showAlert(title: String, message: String)
}

// MARK: - Data Passing Protocol
protocol CleanTodoDataPassing {
    var dataStore: CleanTodoDataStore? { get }
}

// MARK: - Router
final class CleanTodoRouter: NSObject, CleanTodoRoutingLogic, CleanTodoDataPassing {
    weak var viewController: CleanViewController?
    var dataStore: CleanTodoDataStore?
    
    // MARK: - Routing Logic
    func routeToTodoDetail() {
        guard let todo = dataStore?.todo else {
            showAlert(title: "Hata", message: "Önce bir todo fetch etmelisiniz!")
            return
        }
        
        let detailVC = DetailViewController(todo: todo, sourceArchitecture: "Clean")
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        viewController?.present(navigationController, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        viewController?.present(alert, animated: true)
    }
} 