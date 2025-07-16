//
//  RootViewController.swift
//  mobvenyoungtalent2025
//
//  Created by Cansu Özdizlekli on 15.07.2025.
//

import UIKit

class RootViewController: UIViewController {
    private let segment = UISegmentedControl(items: ["MVC","MVVM","Clean","VIPER"])
    private let container = UIView()
    private lazy var vcs: [UIViewController] = [
        MVCViewController(),
        MVVMViewController(),
        CleanViewController(),
        VIPERViewController()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        segment.addTarget(self, action: #selector(switchDemo), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        switchDemo()
    }
    
    private func setupLayout() {
        [segment, container].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            container.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 20),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func switchDemo() {
        children.forEach { $0.willMove(toParent: nil); $0.view.removeFromSuperview(); $0.removeFromParent() }
        let vc = vcs[segment.selectedSegmentIndex]
        addChild(vc)
        container.addSubview(vc.view)
        vc.view.frame = container.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: self)
    }
}
