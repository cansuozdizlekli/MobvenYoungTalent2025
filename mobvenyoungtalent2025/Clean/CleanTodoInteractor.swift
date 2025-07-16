//
//  CleanTodoInteractor.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

protocol CleanTodoBusinessLogic: AnyObject {
    func fetch(request: CleanTodo.Fetch.Request)
}

protocol CleanTodoDataStore: AnyObject {
    var todo: Todo? { get set }
}

final class CleanTodoInteractor: CleanTodoBusinessLogic, CleanTodoDataStore {
    var presenter: CleanTodoPresentationLogic?
    var worker: CleanTodoWorkerProtocol?
    
    // MARK: - Data Store
    var todo: Todo?
    
    // MARK: - Business Logic
    func fetch(request: CleanTodo.Fetch.Request) {
        worker?.fetchTodo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todoItem):
                    self?.todo = todoItem
                    let response = CleanTodo.Fetch.Response(todo: todoItem)
                    self?.presenter?.present(response: response)
                case .failure:
                    break
                }
            }
        }
    }
} 