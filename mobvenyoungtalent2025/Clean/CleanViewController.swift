//
//  CleanViewController.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit

protocol TodoDisplayLogic: AnyObject {
    func display(fetch viewModel: CleanTodo.Fetch.ViewModel)
    func display(error message: String)
}

protocol TodoRoutingLogic {
    // Add routing methods here if needed
}

protocol TodoDataPassing {
    var dataStore: TodoDataStore? { get }
}

final class CleanViewController: UIViewController {
    var interactor: TodoBusinessLogic?
    var router: (TodoRoutingLogic & TodoDataPassing)?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Clean Architecture"
        setupCleanArchitecture()
        setupLayout()
        fetchButton.addTarget(self, action: #selector(fetchTapped), for: .touchUpInside)
    }

    private func setupCleanArchitecture() {
        let interactor = TodoInteractor()
        let presenter = TodoPresenter()
        let router = TodoRouter()
        let worker = TodoWorker()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }

    private func setupLayout() {
        [fetchButton, titleLabel].forEach {
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

    @objc private func fetchTapped() {
        let request = CleanTodo.Fetch.Request()
        interactor?.fetch(request: request)
    }
}

// MARK: - TodoDisplayLogic

extension CleanViewController: TodoDisplayLogic {
    func display(fetch viewModel: CleanTodo.Fetch.ViewModel) {
        titleLabel.text = viewModel.displayText
    }

    func display(error message: String) {
        titleLabel.text = "Hata: \(message)"
    }
}
