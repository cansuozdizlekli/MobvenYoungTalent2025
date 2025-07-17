//
//  VIPERRouter.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit

// MARK: - Router Protocol
protocol VIPERRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    func navigateToDetail(with todo: TodoEntity)
}

// MARK: - Router
class VIPERRouter: VIPERRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigateToDetail(with todo: TodoEntity) {
        guard let viewController = viewController else { return }
        let todoModel = Todo(
            userId: todo.userId,
            id: todo.id,
            title: todo.title,
            completed: todo.completed
        )
        let detailVC = DetailViewController(todo: todoModel, sourceArchitecture: "VIPER")
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
    }
} 
