//
//  APIService.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

class APIService {
    static let shared = APIService()
    private init() {}

    func fetchTodo(completion: @escaping (Result<Todo, Error>) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let err = error {
                completion(.failure(err)); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0))); return
            }
            do {
                let todo = try JSONDecoder().decode(Todo.self, from: data)
                completion(.success(todo))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
