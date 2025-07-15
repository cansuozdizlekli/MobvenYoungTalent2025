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
}

// MARK: - View Protocol
protocol VIPERViewProtocol: AnyObject {
    func showTodo(with text: String)
    func showError(with message: String)
}

// MARK: - Presenter
class VIPERPresenter: VIPERPresenterProtocol {
    weak var view: VIPERViewProtocol?
    var interactor: VIPERInteractorInputProtocol?
    var router: VIPERRouterProtocol?
    
    func viewDidLoad() {
        // View yüklendiğinde yapılacak işlemler
    }
    
    func fetchTodoButtonTapped() {
        interactor?.fetchTodo()
    }
}

// MARK: - Interactor Output
extension VIPERPresenter: VIPERInteractorOutputProtocol {
    func todoFetchedSuccessfully(_ todo: TodoEntity) {
        let displayText = "VIPER → #\(todo.id): \(todo.title)"
        DispatchQueue.main.async { [weak self] in
            self?.view?.showTodo(with: displayText)
        }
    }
    
    func todoFetchFailed(with error: Error) {
        let errorMessage = "VIPER Hata: \(error.localizedDescription)"
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(with: errorMessage)
        }
    }
} 