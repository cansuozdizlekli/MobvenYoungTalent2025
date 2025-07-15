//
//  TodoViewController.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit

class MVCViewController: UIViewController {
    
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
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "MVC Pattern"
        setupLayout()
        fetchButton.addTarget(self, action: #selector(fetchTodo), for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(containerView)
        [fetchButton, titleLabel].forEach {
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
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            fetchButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            fetchButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            fetchButton.widthAnchor.constraint(equalToConstant: 120),
            fetchButton.heightAnchor.constraint(equalToConstant: 44),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: fetchButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: fetchButton.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setLoading(_ isLoading: Bool) {
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

    @objc private func fetchTodo() {
        setLoading(true)
        
        APIService.shared.fetchTodo { [weak self] result in
            DispatchQueue.main.async {
                self?.setLoading(false)
                switch result {
                case .success(let todo):
                    self?.titleLabel.text = "MVC → #\(todo.id):\n\(todo.title)"
                case .failure(let err):
                    self?.titleLabel.text = "MVC Hata: \(err.localizedDescription)"
                }
            }
        }
    }
}

