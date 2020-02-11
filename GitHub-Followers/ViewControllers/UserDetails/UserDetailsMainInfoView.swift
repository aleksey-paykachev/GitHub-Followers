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

	
	// MARK: - Init
	
	init(user: GithubUser) {
		self.user = user
		super.init(frame: .zero)
		
		setupSubviews()
		loadProfileImage()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	// MARK: - Setup
	
	private func setupSubviews() {
		profileImageView.layer.cornerRadius = 12
		profileImageView.clipsToBounds = true
		profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
		
		let usernameLabel = GFLabel(text: user.username,
									font: .systemFont(ofSize: 28, weight: .medium))
		let fullNameLabel = GFLabel(text: user.fullName)
		let locationLabel = GFLabel(text: user.location.map { "􀎫 \($0)" })
		
		let userInfoStack = VStackView([usernameLabel, fullNameLabel, locationLabel],spacing: 4)
		
		let mainStack = HStackView([profileImageView, userInfoStack], spacing: 16, alignment: .top)
		addSubview(mainStack)
		mainStack.constrainToSuperview()
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
}
