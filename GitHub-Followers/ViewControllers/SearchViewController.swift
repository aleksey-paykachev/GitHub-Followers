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
		let searchButton = UIButton(type: .system)
		searchButton.backgroundColor = .systemGreen
		searchButton.tintColor = .systemBackground
		searchButton.titleLabel?.font = .preferredFont(forTextStyle: .title3)
		searchButton.setTitle("Find followers", for: .normal)
		searchButton.layer.cornerRadius = 8
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
	
	func setupGestures() {
		// hide keyboard on tap
		let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		view.addGestureRecognizer(tapGestureRecognizer)
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
	
	@objc private func handleKeyboardWillShow(notification: NSNotification) {
		guard let keyboardUserInfo = KeyboardNotificationUserInfo(userInfo: notification.userInfo) else { return }
		
		let keyboardContentOverlapHeight = mainStack.frame.maxY - keyboardUserInfo.frame.minY
		
		if keyboardContentOverlapHeight > 0 {
			mainStackCenterYConstraint.constant = -keyboardContentOverlapHeight
			UIView.animate(withDuration: keyboardUserInfo.animationDuration) {
				self.view.layoutIfNeeded()
			}
		}
	}
	
	@objc private func handleKeyboardWillHide(notification: NSNotification) {
		guard let keyboardUserInfo = KeyboardNotificationUserInfo(userInfo: notification.userInfo) else { return }
		
		mainStackCenterYConstraint.constant = 0
		UIView.animate(withDuration: keyboardUserInfo.animationDuration) {
			self.view.layoutIfNeeded()
		}
	}
}

struct KeyboardNotificationUserInfo {
	let animationDuration: TimeInterval
	let frame: CGRect
	let height: CGFloat
	let width: CGFloat
	
	init?(userInfo: [AnyHashable : Any]?) {
		guard
			let userInfo = userInfo,
			let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
			let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
			else {
				return nil
		}
		
		self.animationDuration = animationDuration
		self.frame = keyboardFrame
		self.height = keyboardFrame.size.height
		self.width = keyboardFrame.size.width
	}
}
