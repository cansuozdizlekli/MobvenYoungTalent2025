//
//  TodoWorker.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

protocol TodoWorkerProtocol {
    func fetchTodo(completion: @escaping (Result<Todo, Error>) -> Void)
}

final class TodoWorker: TodoWorkerProtocol {
    func fetchTodo(completion: @escaping (Result<Todo, Error>) -> Void) {
        APIService.shared.fetchTodo(completion: completion)
    }
}
