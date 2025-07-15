//
//  TodoPresenter.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

protocol TodoPresentationLogic: AnyObject {
    func present(response: CleanTodo.Fetch.Response)
    func present(error: Error)
}

final class TodoPresenter: TodoPresentationLogic {
    weak var viewController: TodoDisplayLogic?

    func present(response: CleanTodo.Fetch.Response) {
        let text = "Clean → #\(response.todo.id): \(response.todo.title)"
        let viewModel = CleanTodo.Fetch.ViewModel(displayText: text)
        viewController?.display(fetch: viewModel)
    }

    func present(error: Error) {
        viewController?.display(error: error.localizedDescription)
    }
}
