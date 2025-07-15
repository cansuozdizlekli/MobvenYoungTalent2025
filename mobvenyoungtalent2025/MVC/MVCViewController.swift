//
//  TodoViewController.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit

class MVCViewController: UIViewController {
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
        view.backgroundColor = .systemGray6
        setupLayout()
        fetchButton.addTarget(self, action: #selector(fetchTodo), for: .touchUpInside)
    }

    private func setupLayout() {
        [titleLabel, fetchButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            titleLabel.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func fetchTodo() {
        APIService.shared.fetchTodo { [weak self] result in
            DispatchQueue.main.async {
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

