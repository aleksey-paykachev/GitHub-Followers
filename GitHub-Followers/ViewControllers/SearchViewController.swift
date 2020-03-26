//
//  SearchViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 03.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class SearchViewController: GFViewController {
	// MARK: - Properties
	
	private var mainStack: UIStackView!
	private var mainStackCenterYConstraint: NSLayoutConstraint!
	private let searchTermTextField = GFTextField(placeholder: "Enter GitHub username")

	
	// MARK: - Init
	
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
		tabBarItem.image = .sfSymbolMagnifyingglass
	}
	
	private func setupView() {
		view.backgroundColor = .gfBackground
	}
	
	private func setupSubviews() {
		// logo
		let logoImageView = GFImageView(image: .assetLogo)
		logoImageView.constrainHeightToWidth(aspectRatio: 0.8)
		
		// text field
		searchTermTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
		searchTermTextField.addTarget(self, action: #selector(findFollowers), for: .primaryActionTriggered)
		
		// button
		let searchButton = GFButton(title: "Find followers")
		searchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		searchButton.addTarget(self, action: #selector(findFollowers), for: .touchUpInside)
		
		// stack
		mainStack = VStackView([logoImageView, searchTermTextField, searchButton], spacing: 10)
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
	
	
	// MARK: - Private methods
	
	@objc private func findFollowers() {
		guard let searchTerm = searchTermTextField.text?.trimmed, searchTerm.isNotEmpty else {
			searchTermTextField.showWrongInputError()
			return
		}

		view.endEditing(true)
		showLoadingOverlay()

		DataManager.shared.getUser(by: searchTerm) { [weak self] result in
			guard let self = self else { return }
			self.hideLoadingOverlay()
			
			switch result {
			case .failure(let error):
				self.showError(error.localizedDescription)
				
			case .success(let user):
				self.searchTermTextField.text = ""
				let followersVC = FollowersViewController(for: user)
				self.navigationController?.pushViewController(followersVC, animated: true)
			}
		}
	}
	
	private func setContentYOffset(_ offsetY: CGFloat, with animationDuration: TimeInterval) {
		mainStackCenterYConstraint.constant = offsetY
		UIView.animate(withDuration: animationDuration) {
			self.view.layoutIfNeeded()
		}
	}
	
	
	// MARK: - View lifecycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// hide navigation bar
		navigationController?.setNavigationBarHidden(true, animated: animated)
		
		// add notification observers
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		// show navigation bar
		navigationController?.setNavigationBarHidden(false, animated: animated)
		
		// remove notification observers
		NotificationCenter.default.removeObserver(self)
	}
	
	
	// MARK: - Keyboard handling
	
	// Check if keyboard overlaps content, and apply y-offset if so.
	@objc private func handleKeyboardWillShow(notification: NSNotification) {
		guard let keyboardUserInfo = KeyboardNotificationUserInfo(userInfo: notification.userInfo) else { return }
		
		let keyboardContentOverlapHeight = mainStack.frame.maxY - keyboardUserInfo.frame.minY
		let paddingFromContentToKeyboard: CGFloat = 12
		
		if keyboardContentOverlapHeight > 0 {
			setContentYOffset(-keyboardContentOverlapHeight - paddingFromContentToKeyboard, with: keyboardUserInfo.animationDuration)
		}
	}
	
	@objc private func handleKeyboardWillHide(notification: NSNotification) {
		guard let keyboardUserInfo = KeyboardNotificationUserInfo(userInfo: notification.userInfo) else { return }
		
		setContentYOffset(0, with: keyboardUserInfo.animationDuration)
	}
}
