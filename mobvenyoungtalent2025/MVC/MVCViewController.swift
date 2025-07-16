//
//  TodoViewController.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit

//Controller
class MVCViewController: UIViewController {
    
    private var todo: Todo? // Model ile bağlantısı
    private var mvcView: MVCView! // View ile bağlantısı

    override func loadView() {
        mvcView = MVCView()
        view = mvcView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVC Pattern"
        setupActions()
    }

    // button actions
    private func setupActions() {
        mvcView.fetchButton.addTarget(self, action: #selector(fetchTodo), for: .touchUpInside)
        mvcView.detailButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
    }

    // fetch todo servis isteği
    @objc private func fetchTodo() {
        mvcView.setLoading(true)
        
        APIService.shared.fetchTodo { [weak self] result in
            DispatchQueue.main.async {
                self?.mvcView.setLoading(false)
                switch result {
                case .success(let todo):
                    self?.todo = todo
                    self?.updateUI(with: todo)
                case .failure:
                    break
                }
            }
        }
    }
    
    // UI güncelleme
    private func updateUI(with todo: Todo) {
        mvcView.titleLabel.text = "MVC → #\(todo.id):\n\(todo.title)"
    }
    
    // navigation
    @objc private func showDetail() {
        guard let todo = todo else {
            return // Todo yoksa hiçbir şey yapma
        }
        
        let detailVC = DetailViewController(todo: todo, sourceArchitecture: "MVC")
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
