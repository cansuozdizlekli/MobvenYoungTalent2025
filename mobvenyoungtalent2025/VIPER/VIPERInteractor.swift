//
//  VIPERInteractor.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

// MARK: - Interactor Protocol
protocol VIPERInteractorInputProtocol: AnyObject {
    func fetchTodo()
}

// MARK: - Interactor Output Protocol
protocol VIPERInteractorOutputProtocol: AnyObject {
    func todoFetchedSuccessfully(_ todo: TodoEntity)
    func todoFetchFailed(with error: Error)
}

// MARK: - Interactor
class VIPERInteractor: VIPERInteractorInputProtocol {
    weak var presenter: VIPERInteractorOutputProtocol?
    
    func fetchTodo() {
        APIService.shared.fetchTodo { [weak self] result in
            switch result {
            case .success(let todo):
                let entity = TodoEntity(
                    id: todo.id,
                    title: todo.title,
                    completed: todo.completed,
                    userId: todo.userId
                )
                self?.presenter?.todoFetchedSuccessfully(entity)
            case .failure(let error):
                self?.presenter?.todoFetchFailed(with: error)
            }
        }
    }
} 