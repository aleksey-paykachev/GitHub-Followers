//
//  SearchViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 03.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
	
	private var mainStack: UIStackView!
	private var mainStackCenterYConstraint: NSLayoutConstraint!
	
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
		let searchButton = GFButton(title: "Find followers")
		searchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		
		// stack
		mainStack = UIStackView(arrangedSubviews: [logoImageView, searchTermTextField, searchButton])
		mainStack.axis = .vertical
		mainStack.spacing = 10
		mainStack.setCustomSpacing(40, after: logoImageView)
		
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
		mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		mainStackCenterYConstraint = mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
		mainStackCenterYConstraint.isActive = true
	}
	
	private func setupGestures() {
		// hide keyboard on tap
		let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		view.addGestureRecognizer(tapGestureRecognizer)
	}
	
	
	// MARK: - Methods
	
	private func setContentYOffset(_ offsetY: CGFloat, with animationDuration: TimeInterval) {
		mainStackCenterYConstraint.constant = offsetY
		UIView.animate(withDuration: animationDuration) {
			self.view.layoutIfNeeded()
		}
	}
	
	
	// MARK: - View lifecycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		NotificationCenter.default.removeObserver(self)
	}
	
	
	// MARK: - Keyboard handling
	
	// Check if keyboard overlaps content, and apply y-offset if so.
	@objc private func handleKeyboardWillShow(notification: NSNotification) {
		guard let keyboardUserInfo = KeyboardNotificationUserInfo(userInfo: notification.userInfo) else { return }
		
		let keyboardContentOverlapHeight = mainStack.frame.maxY - keyboardUserInfo.frame.minY
		
		if keyboardContentOverlapHeight > 0 {
			setContentYOffset(-keyboardContentOverlapHeight, with: keyboardUserInfo.animationDuration)
		}
	}
	
	@objc private func handleKeyboardWillHide(notification: NSNotification) {
		guard let keyboardUserInfo = KeyboardNotificationUserInfo(userInfo: notification.userInfo) else { return }
		
		setContentYOffset(0, with: keyboardUserInfo.animationDuration)
	}
}
