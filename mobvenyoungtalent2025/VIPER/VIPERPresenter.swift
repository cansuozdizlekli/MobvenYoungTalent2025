//
//  VIPERPresenter.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

// MARK: - Presenter Protocol
protocol VIPERPresenterProtocol: AnyObject {
    func viewDidLoad()
    func fetchTodoButtonTapped()
    func detailButtonTapped()
}

// MARK: - View Protocol
protocol VIPERViewProtocol: AnyObject {
    func showTodo(with text: String)
    func navigateToDetail(with todo: TodoEntity)
}

// MARK: - Presenter
class VIPERPresenter: VIPERPresenterProtocol {
    weak var view: VIPERViewProtocol?
    var interactor: VIPERInteractorInputProtocol?
    var router: VIPERRouterProtocol?
    
    private var currentTodo: TodoEntity?
    
    func viewDidLoad() {
    }
    
    func fetchTodoButtonTapped() {
        interactor?.fetchTodo()
    }
    
    func detailButtonTapped() {
        guard let todo = currentTodo else {
            return
        }
        view?.navigateToDetail(with: todo)
    }
}

// MARK: - Interactor Output
extension VIPERPresenter: VIPERInteractorOutputProtocol {
    func todoFetchedSuccessfully(_ todo: TodoEntity) {
        currentTodo = todo
        let displayText = "VIPER → #\(todo.id): \(todo.title)"
        DispatchQueue.main.async { [weak self] in
            self?.view?.showTodo(with: displayText)
        }
    }
} 
