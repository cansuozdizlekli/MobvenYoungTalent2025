//
//  TodoViewModel.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation
import Combine
import UIKit

//ViewModel
class TodoViewModel {
    // Output
    @Published private(set) var displayText: String = "Henüz Fetch edilmedi"
    @Published private(set) var shouldShowDetail: Todo?
    
    private var todo: Todo? {
        didSet {
            updateDisplayText()
        }
    }
    
    private func updateDisplayText() {
        guard let todo = todo else { return }
        displayText = "MVVM → #\(todo.id): \(todo.title)"
    }
    
    func fetch() {
        APIService.shared.fetchTodo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todo):
                    self?.todo = todo
                case .failure:
                    break
                }
            }
        }
    }
    
    func showDetail() {
        guard let todo = todo else {
            return
        }
        shouldShowDetail = todo
    }
    
    // Navigation işlemi ViewModel'da
    func presentDetail(todo: Todo, from viewController: UIViewController) {
        let detailVC = DetailViewController(todo: todo, sourceArchitecture: "MVVM")
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
        
        shouldShowDetail = nil // Reset after presenting
    }
}
