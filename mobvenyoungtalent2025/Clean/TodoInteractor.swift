//
//  TodoInteractor.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

protocol TodoBusinessLogic: AnyObject {
    func fetch(request: CleanTodo.Fetch.Request)
}

protocol TodoDataStore: AnyObject {
    var todo: Todo? { get set }
}

final class TodoInteractor: TodoBusinessLogic, TodoDataStore {
    var presenter: TodoPresentationLogic?
    var worker: TodoWorkerProtocol?
    
    // MARK: - Data Store
    var todo: Todo?
    
    // MARK: - Business Logic
    func fetch(request: CleanTodo.Fetch.Request) {
        presenter?.presentLoading(true)
        
        worker?.fetchTodo { [weak self] result in
            DispatchQueue.main.async {
                self?.presenter?.presentLoading(false)
                switch result {
                case .success(let todoItem):
                    self?.todo = todoItem
                    let response = CleanTodo.Fetch.Response(todo: todoItem)
                    self?.presenter?.present(response: response)
                case .failure(let error):
                    self?.presenter?.present(error: error)
                }
            }
        }
    }
}
