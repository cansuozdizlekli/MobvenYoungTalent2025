//
//  CleanTodoPresenter.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

protocol CleanTodoPresentationLogic: AnyObject {
    func present(response: CleanTodo.Fetch.Response)
    func present(error: Error)
    func presentLoading(_ isLoading: Bool)
}

final class CleanTodoPresenter: CleanTodoPresentationLogic {
    weak var viewController: CleanTodoDisplayLogic?

    func present(response: CleanTodo.Fetch.Response) {
        let text = "Clean → #\(response.todo.id): \(response.todo.title)"
        let viewModel = CleanTodo.Fetch.ViewModel(displayText: text)
        viewController?.display(fetch: viewModel)
    }

    func present(error: Error) {
        viewController?.display(error: error.localizedDescription)
    }
    
    func presentLoading(_ isLoading: Bool) {
        viewController?.display(loading: isLoading)
    }
} 