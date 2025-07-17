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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
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
        router.viewController = self
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
    
    private func setupActions() {
        fetchButton.addTarget(self, action: #selector(fetchAction), for: .touchUpInside)
        detailButton.addTarget(self, action: #selector(detailAction), for: .touchUpInside)
    }

    // interactor yerine presenter bağlantısı clean'den farklı!
    @objc private func fetchAction() {
        presenter?.fetchTodoButtonTapped()
    }
    
    @objc private func detailAction() {
        presenter?.detailButtonTapped()
    }
}

// MARK: - VIPERViewProtocol
extension VIPERViewController: VIPERViewProtocol {
    func showTodo(with text: String) {
        titleLabel.text = text
    }
}

