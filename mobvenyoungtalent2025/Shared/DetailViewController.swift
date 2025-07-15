//
//  DetailViewController.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let todo: Todo
    private let sourceArchitecture: String
    
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
    
    private let architectureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    init(todo: Todo, sourceArchitecture: String) {
        self.todo = todo
        self.sourceArchitecture = sourceArchitecture
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Todo Detayı"
        
        setupNavigationBar()
        setupLayout()
        configureData()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        [architectureLabel, idLabel, titleLabel, statusLabel, userLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            architectureLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            architectureLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            architectureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            idLabel.topAnchor.constraint(equalTo: architectureLabel.bottomAnchor, constant: 16),
            idLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            userLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            userLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            userLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            userLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureData() {
        architectureLabel.text = "🏗️ \(sourceArchitecture) Architecture"
        idLabel.text = "ID: \(todo.id)"
        titleLabel.text = todo.title
        statusLabel.text = "Durum: \(todo.completed ? "✅ Tamamlandı" : "⏳ Beklemede")"
        statusLabel.textColor = todo.completed ? .systemGreen : .systemOrange
        userLabel.text = "Kullanıcı ID: \(todo.userId)"
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
} 