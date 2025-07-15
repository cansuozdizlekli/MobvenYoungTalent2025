//
//  VIPERViewController.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit

class VIPERViewController: UIViewController {
    
    // MARK: - VIPER
    var presenter: VIPERPresenterProtocol?
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Henüz Fetch edilmedi"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let fetchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Fetch Data", for: .normal)
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "VIPER Architecture"
        setupVIPER()
        setupLayout()
        setupActions()
        presenter?.viewDidLoad()
    }
    
    private func setupVIPER() {
        let presenter = VIPERPresenter()
        let interactor = VIPERInteractor()
        let router = VIPERRouter()
        
        // VIPER bağlantıları
        self.presenter = presenter
        presenter.view = self
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
    }

    private func setupLayout() {
        [titleLabel, fetchButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        fetchButton.addTarget(self, action: #selector(fetchButtonTapped), for: .touchUpInside)
    }

    @objc private func fetchButtonTapped() {
        presenter?.fetchTodoButtonTapped()
    }
}

// MARK: - VIPERViewProtocol
extension VIPERViewController: VIPERViewProtocol {
    func showTodo(with text: String) {
        titleLabel.text = text
    }
    
    func showError(with message: String) {
        titleLabel.text = message
    }
}

