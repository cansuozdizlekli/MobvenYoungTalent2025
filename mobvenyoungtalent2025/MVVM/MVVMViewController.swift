//
//  TodoViewControllerMVVM.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit
import Combine

class MVVMViewController: UIViewController {
    private let viewModel = TodoViewModel()
    private var cancellables = Set<AnyCancellable>()

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
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "MVVM Pattern"
        setupLayout()
        bindViewModel()
        setupActions()
    }

    private func setupLayout() {
        view.addSubview(containerView)
        [fetchButton, detailButton, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        fetchButton.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            loadingIndicator.centerXAnchor.constraint(equalTo: fetchButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: fetchButton.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        fetchButton.addTarget(self, action: #selector(fetchTodo), for: .touchUpInside)
        detailButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
    }

    private func bindViewModel() {
        // Text binding
        viewModel.$displayText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.titleLabel.text = text
            }.store(in: &cancellables)
        
        // Loading binding
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading)
            }.store(in: &cancellables)
        
        // Detail navigation binding
        viewModel.$shouldShowDetail
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] todo in
                self?.presentDetail(todo: todo)
                self?.viewModel.detailShown()
            }.store(in: &cancellables)
        
        // Error binding
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
                self?.viewModel.errorShown()
            }.store(in: &cancellables)
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            fetchButton.setTitle("", for: .normal)
            fetchButton.isEnabled = false
            loadingIndicator.startAnimating()
        } else {
            fetchButton.setTitle("Fetch Data", for: .normal)
            fetchButton.isEnabled = true
            loadingIndicator.stopAnimating()
        }
    }
    
    private func presentDetail(todo: Todo) {
        let detailVC = DetailViewController(todo: todo, sourceArchitecture: "MVVM")
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc private func fetchTodo() {
        viewModel.fetch()
    }
    
    @objc private func showDetail() {
        viewModel.showDetail()
    }
}
