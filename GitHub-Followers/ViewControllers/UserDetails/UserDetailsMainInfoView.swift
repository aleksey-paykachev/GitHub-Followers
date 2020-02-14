//
//  UserDetailsMainInfoView.swift
//  GitHub-Followers
//
//  Created by Aleksey on 10.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class UserDetailsMainInfoView: UIView {
	// MARK: - Properties
	
	private let user: GithubUser
	private let profileImageView = GFImageView(asset: .avatarPlaceholder)
	private let favoriteButton = UIButton(type: .custom)

	
	// MARK: - Init
	
	init(user: GithubUser) {
		self.user = user
		super.init(frame: .zero)
		
		setupSubviews()
		setupFavoriteButton()
		loadProfileImage()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	// MARK: - Setup
	
	private func setupSubviews() {
		profileImageView.layer.setCornerRadius(12)
		profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
		
		let usernameLabel = GFLabel(text: user.username,
									font: .systemFont(ofSize: 28, weight: .medium))
		let fullNameLabel = GFLabel(text: user.fullName)
		let locationLabel = GFLabel(text: user.location.map { "􀎫 \($0)" })
		
		let userInfoStack = VStackView([usernameLabel, fullNameLabel, locationLabel],spacing: 4)
		
		let mainStack = HStackView([profileImageView, userInfoStack], spacing: 24, alignment: .top)
		addSubview(mainStack)
		mainStack.constrainToSuperview()
	}
	
	private func setupFavoriteButton() {
		let isFavorite = DataManager.shared.checkIfFavorite(user: user)
		setFavoriteButtonState(isFavorite: isFavorite)

		favoriteButton.addTarget(self, action: #selector(favoriteButtonDidPressed), for: .touchUpInside)

		addSubview(favoriteButton)
		favoriteButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			favoriteButton.centerXAnchor.constraint(equalTo: profileImageView.trailingAnchor),
			favoriteButton.centerYAnchor.constraint(equalTo: profileImageView.topAnchor),
			favoriteButton.widthAnchor.constraint(equalToConstant: 30),
			favoriteButton.heightAnchor.constraint(equalToConstant: 30)
		])
	}
	
	
	// MARK: - Load data
	
	private func loadProfileImage() {
		// almost 100% of the time profile image will be loaded from cache

		DataManager.shared.getProfileImage(for: user) { [weak self] result in
			guard let self = self else { return }

			if case .success(let image) = result {
				self.profileImageView.image = image
			}
		}
	}
	
	
	// MARK: - Actions
	
	private func setFavoriteButtonState(isFavorite: Bool) {
		let buttonImage = UIImage(systemName: isFavorite ? "star.fill" : "star")
		favoriteButton.setBackgroundImage(buttonImage, for: .normal)
	}
	
	@objc private func favoriteButtonDidPressed() {
		#warning("Delegate to parent VC")

		let isFavorite = DataManager.shared.toggleFavorite(user: user)
		setFavoriteButtonState(isFavorite: isFavorite)
	}
}
