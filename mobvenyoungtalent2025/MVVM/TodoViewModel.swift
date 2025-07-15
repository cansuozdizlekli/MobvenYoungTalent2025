//
//  TodoViewModel.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import Foundation
import Combine

class TodoViewModel {
    // Output
    @Published private(set) var displayText: String = "Henüz Fetch edilmedi"
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var shouldShowDetail: Todo?
    @Published private(set) var errorMessage: String?
    
    private var todo: Todo? {
        didSet {
            updateDisplayText()
        }
    }
    
    private func updateDisplayText() {
        guard let todo = todo else { return }
        displayText = "MVVM → #\(todo.id): \(todo.title)"
    }
    
    func fetch() {
        isLoading = true
        
        APIService.shared.fetchTodo { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let todo):
                    self?.todo = todo
                case .failure(let error):
                    self?.displayText = "MVVM Hata: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func showDetail() {
        guard let todo = todo else {
            errorMessage = "Önce bir todo fetch etmelisiniz!"
            return
        }
        shouldShowDetail = todo
    }
    
    func detailShown() {
        shouldShowDetail = nil
    }
    
    func errorShown() {
        errorMessage = nil
    }
}
