//
//  CleanTodoWorker.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

protocol CleanTodoWorkerProtocol {
    func fetchTodo(completion: @escaping (Result<Todo, Error>) -> Void)
}

final class CleanTodoWorker: CleanTodoWorkerProtocol {
    func fetchTodo(completion: @escaping (Result<Todo, Error>) -> Void) {
        APIService.shared.fetchTodo(completion: completion)
    }
} 