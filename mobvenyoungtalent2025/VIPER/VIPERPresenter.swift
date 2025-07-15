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
    func showError(with message: String)
    func showLoading(_ isLoading: Bool)
    func navigateToDetail(with todo: TodoEntity)
}

// MARK: - Presenter
class VIPERPresenter: VIPERPresenterProtocol {
    weak var view: VIPERViewProtocol?
    var interactor: VIPERInteractorInputProtocol?
    var router: VIPERRouterProtocol?
    
    private var currentTodo: TodoEntity?
    
    func viewDidLoad() {
        // View yüklendiğinde yapılacak işlemler
    }
    
    func fetchTodoButtonTapped() {
        view?.showLoading(true)
        interactor?.fetchTodo()
    }
    
    func detailButtonTapped() {
        guard let todo = currentTodo else {
            view?.showError(with: "Önce bir todo fetch etmelisiniz!")
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
            self?.view?.showLoading(false)
            self?.view?.showTodo(with: displayText)
        }
    }
    
    func todoFetchFailed(with error: Error) {
        let errorMessage = "VIPER Hata: \(error.localizedDescription)"
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoading(false)
            self?.view?.showError(with: errorMessage)
        }
    }
} 