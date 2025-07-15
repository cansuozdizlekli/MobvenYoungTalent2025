//
//  TodoViewModel.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation

class TodoViewModel {
    // Output
    @Published private(set) var displayText: String = "Henüz Fetch edilmedi"
    
    private var todo: Todo? {
        didSet {
            if let t = todo {
                displayText = "TODO #\(t.id):\n\(t.title)"
            }
        }
    }
    
    func fetch() {
        APIService.shared.fetchTodo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todo):
                    self?.todo = todo
                case .failure(let error):
                    self?.displayText = "Hata: \(error.localizedDescription)"
                }
            }
        }
    }
}
