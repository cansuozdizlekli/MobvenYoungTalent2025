//
//  CleanTodoModel.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

enum CleanTodo {
    enum Fetch {
        /// ViewController → Interactor
        struct Request { }

        /// Interactor → Presenter
        // Ham veri dediğimiz response
        struct Response {
            let todo: Todo
        }

        /// Presenter → ViewController
        struct ViewModel {
            let displayText: String
        }
    }
}
