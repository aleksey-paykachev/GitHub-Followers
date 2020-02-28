//
//  UserDetailsMainInfoView.swift
//  GitHub-Followers
//
//  Created by Aleksey on 10.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol UserDetailsMainInfoViewDelegate: class {
	func didChangeFavoriteStatus(for user: GithubUser, to value: Bool)
}

class UserDetailsMainInfoView: UIView {
	// MARK: - Properties
	
	private let user: GithubUser
	private var isFavorite = false // { didSet { setFavoriteButtonState(to: isFavorite) } }

	private let profileImageView = GFImageView(asset: .avatarPlaceholder)
	private lazy var favoriteButton = GFFavoriteButton(sideSize: 30, isSelected: isFavorite)
	private let favoriteButtonOffset = CGPoint(x: -3, y: -5)

	weak var delegate: UserDetailsMainInfoViewDelegate?

	
	// MARK: - Init
	
	init(user: GithubUser) {
		self.user = user
		super.init(frame: .zero)
		
		setupSubviews()
		setupFavoriteButton()

		loadFavoriteState()
		loadProfileImage()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	// MARK: - Setup
	
	private func setupSubviews() {
		// profile image
		profileImageView.layer.setCornerRadius(12)
		profileImageView.layer.setBorder(color: .gfImageBorder)
		profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
		
		// labels
		let usernameLabel = GFLabel(text: user.username, font: .systemFont(ofSize: 28, weight: .medium))
		let fullNameLabel = GFLabel(text: user.fullName, image: UIImage(sfSymbol: .person))
		let locationLabel = GFLabel(text: user.location, image: UIImage(sfSymbol: .mappinAndEllipse))
		
		// stacks
		let userInfoStack = VStackView([usernameLabel, fullNameLabel, locationLabel], spacing: 4)
		
		let mainStack = HStackView([profileImageView, userInfoStack], spacing: 24, alignment: .top)
		addSubview(mainStack)
		
		// addition padding needs to be set to "fit" button touch area inside parent view
		let bottomPadding = favoriteButton.bounds.height / 2 + favoriteButtonOffset.y

		mainStack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
			mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
			mainStack.topAnchor.constraint(equalTo: topAnchor),
			mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
		])
	}
	
	private func setupFavoriteButton() {
		favoriteButton.addTarget(self, action: #selector(favoriteButtonDidPressed), for: .touchUpInside)

		addSubview(favoriteButton)
		favoriteButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			favoriteButton.centerXAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: favoriteButtonOffset.x),
			favoriteButton.centerYAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: favoriteButtonOffset.y),
			favoriteButton.widthAnchor.constraint(equalToConstant: favoriteButton.bounds.width),
			favoriteButton.heightAnchor.constraint(equalToConstant: favoriteButton.bounds.height)
		])
	}
	
	
	// MARK: - Load data
	
	private func loadFavoriteState() {
		#warning("Move data manager logic to View Controller.")
		isFavorite = DataManager.shared.checkIfFavorite(user: user)
	}
	
	private func loadProfileImage() {
		// almost 100% of the time profile image will be loaded from cache

		#warning("Move network logic to View Controller.")
		DataManager.shared.getProfileImage(for: user) { [weak self] result in
			guard let self = self else { return }

			if case .success(let image) = result {
				self.profileImageView.image = image
			}
		}
	}
	
	
	// MARK: - Private methods
	
	@objc private func favoriteButtonDidPressed() {
		print("_toggle")
		isFavorite.toggle()
		delegate?.didChangeFavoriteStatus(for: user, to: isFavorite)
	}
}
