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
        view.backgroundColor = .systemGray5
        setupLayout()
        bindViewModel()
        fetchButton.addTarget(self, action: #selector(fetchTodo), for: .touchUpInside)
    }

    private func setupLayout() {
        [fetchButton, titleLabel].forEach {
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

    private func bindViewModel() {
        viewModel.$displayText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.titleLabel.text = text
            }.store(in: &cancellables)
    }

    @objc private func fetchTodo() {
        viewModel.fetch()
    }
}
