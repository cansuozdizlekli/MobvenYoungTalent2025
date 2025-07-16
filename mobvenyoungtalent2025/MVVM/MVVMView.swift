//
//  MVVMView.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit
import Combine

//View
class MVVMView: UIView {
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

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Henüz Fetch edilmedi"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .label
        return lbl
    }()
    
    let fetchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Fetch Data", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return btn
    }()
    
    let detailButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Detay Göster", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        backgroundColor = .systemGroupedBackground
    }
    
    private func setupLayout() {
        addSubview(containerView)
        [fetchButton, detailButton, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
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
}

//View Controller (View katmanının parçası)
class MVVMViewController: UIViewController {
    private let viewModel = TodoViewModel() // ViewModel ile bağlantı
    private var mvvmView: MVVMView! // View ile bağlantı
    
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        mvvmView = MVVMView()
        view = mvvmView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM Pattern"
        setupActions()
        bindViewModel()
    }

    // button actions
    private func setupActions() {
        mvvmView.fetchButton.addTarget(self, action: #selector(fetchTodo), for: .touchUpInside)
        mvvmView.detailButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
    }

    // ViewModel binding
    private func bindViewModel() {
        // Text binding
        viewModel.$displayText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.mvvmView.titleLabel.text = text
            }.store(in: &cancellables)
        
        // Detail navigation binding
        viewModel.$shouldShowDetail
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] todo in
                self?.viewModel.presentDetail(todo: todo, from: self!)
            }.store(in: &cancellables)
    }

    @objc private func fetchTodo() {
        viewModel.fetch()
    }
    
    @objc private func showDetail() {
        viewModel.showDetail()
    }
}
