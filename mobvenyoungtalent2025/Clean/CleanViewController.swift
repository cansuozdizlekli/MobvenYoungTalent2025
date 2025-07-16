//
//  CleanViewController.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit

protocol CleanTodoDisplayLogic: AnyObject {
    func display(fetch viewModel: CleanTodo.Fetch.ViewModel)
}

final class CleanViewController: UIViewController {
    var interactor: CleanTodoBusinessLogic?
    var router: (CleanTodoRoutingLogic & CleanTodoDataPassing)?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        return view
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Henüz Fetch edilmedi"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .label
        return lbl
    }()

    private let fetchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Fetch Data", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return btn
    }()
    
    private let detailButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Detay Göster", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Clean Architecture"
        setupCleanArchitecture()
        setupLayout()
        setupActions()
    }

    private func setupCleanArchitecture() {
        let interactor = CleanTodoInteractor()
        let presenter = CleanTodoPresenter()
        let router = CleanTodoRouter()
        let worker = CleanTodoWorker()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }

    private func setupLayout() {
        view.addSubview(containerView)
        [fetchButton, detailButton, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 250),
            
            fetchButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            fetchButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            fetchButton.widthAnchor.constraint(equalToConstant: 100),
            fetchButton.heightAnchor.constraint(equalToConstant: 44),
            
            detailButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            detailButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            detailButton.widthAnchor.constraint(equalToConstant: 100),
            detailButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    // ViewController aksiyonlar butonlara eklenir.
    private func setupActions() {
        fetchButton.addTarget(self, action: #selector(fetchTapped), for: .touchUpInside)
        detailButton.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
    }

    // Çekme aksiyonu interactora gönderilir.
    @objc private func fetchTapped() {
        let request = CleanTodo.Fetch.Request()
        interactor?.fetch(request: request)
    }
    
    // Navigation aksiyonu routera gönderilir.
    @objc private func detailTapped() {
        router?.routeToTodoDetail()
    }
}

// MARK: - CleanTodoDisplayLogic

extension CleanViewController: CleanTodoDisplayLogic {
    func display(fetch viewModel: CleanTodo.Fetch.ViewModel) {
        titleLabel.text = viewModel.displayText
    }
}
