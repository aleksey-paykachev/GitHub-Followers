//
//  SearchViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 03.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		setupTabBar()
		setupView()
		setupSubviews()
		setupGestures()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	// MARK: - Setup
	
	private func setupTabBar() {
		tabBarItem.title = "Search"
		tabBarItem.image = UIImage(systemName: "magnifyingglass")
	}
	
	private func setupView() {
		view.backgroundColor = .systemBackground
	}

	private func setupSubviews() {
		// logo
		let logoImageView = UIImageView(image: UIImage(named: "gh-logo"))
		logoImageView.contentMode = .scaleAspectFit
		logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.8).isActive = true

		// text field
		let searchTermTextField = GFTextField(placeholder: "Enter github username")
		searchTermTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
		
		// button
		let searchButton = UIButton(type: .system)
		searchButton.backgroundColor = .systemGreen
		searchButton.tintColor = .systemBackground
		searchButton.titleLabel?.font = .preferredFont(forTextStyle: .title3)
		searchButton.setTitle("Find followers", for: .normal)
		searchButton.layer.cornerRadius = 8
		searchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		
		// stack
		let stack = UIStackView(arrangedSubviews: [logoImageView, searchTermTextField, searchButton])
		stack.axis = .vertical
		stack.spacing = 10
		stack.setCustomSpacing(40, after: logoImageView)

		view.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
		stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
	
	func setupGestures() {
		// hide keyboard on tap
		let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		view.addGestureRecognizer(tapGestureRecognizer)
	}
}
