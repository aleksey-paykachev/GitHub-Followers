//
//  UserDetailsViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 09.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class UserDetailsViewController: GFViewController {
	// MARK: - Init
	
	init(username: String) {
		super.init(nibName: nil, bundle: nil)
		
		setupView()
		loadUserData(for: username)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupView() {
		view.backgroundColor = .systemBackground
	}
	
	
	// MARK: - Load data
	
	private func loadUserData(for username: String) {
		isLoading = true

		DataManager.shared.getUser(by: username) { [weak self] result in
			guard let self = self else { return }
			self.isLoading = false

			switch result {
			case .success(let user):
				self.createUI(for: user)

			case .failure(let error):
				print("Error:", error)
				self.dismiss(animated: true)
			}
		}
	}
	
	
	// MARK: - Create UI
	
	private func createUI(for user: GithubUser) {
		let closeButton = UIButton(type: .close)
		closeButton.addTarget(self, action: #selector(closeButtonDidPressed), for: .touchUpInside)
		let actionButtonsStack = HStackView([SpacerView(), closeButton])

		let mainInfoView = UserDetailsMainInfoView(user: user)
		mainInfoView.delegate = self
		
		let descriptionLabel = GFLabel(text: user.description, allowMultipleLines: true)

		let userWorkActivityDetailsView = UserDetailsInfoBlocksView(
			infoBlocks: [.repos(count: user.repositoriesCount), .gists(count: user.gistsCount)],
			action: .primary(title: "GitHub Profile", completion: githubProfileButtonDidPressed))
		
		let userSocialActivityDetailsView = UserDetailsInfoBlocksView(
			infoBlocks: [.following(count: user.followingCount), .followers(count: user.followersCount)],
			action: .secondary(title: "View Followers", completion: viewFollowersButtonDidPressed))

		let registeredText = "Registered \(user.accountRegistrationDate.relativeToNowText)"
		let sinceLabel = GFLabel(text: registeredText, color: .systemGray2, alignment: .center)

		let mainStack = VStackView([actionButtonsStack, mainInfoView, descriptionLabel, userWorkActivityDetailsView, userSocialActivityDetailsView, sinceLabel, SpacerView()], spacing: 24)
		mainStack.setCustomSpacing(0, after: actionButtonsStack)
		mainStack.setCustomSpacing(14, after: userSocialActivityDetailsView)

		view.insertSubview(mainStack, at: 0)
		mainStack.constrainToSuperview(padding: 20, respectSafeArea: true)
	}
	
	
	// MARK: - Actions

	@objc private func closeButtonDidPressed() {
		dismiss(animated: true)
	}

	private func githubProfileButtonDidPressed() {
		print(#function)
	}
	
	private func viewFollowersButtonDidPressed() {
		print(#function)
	}
}


// MARK: - UserDetailsMainInfoViewDelegate

extension UserDetailsViewController: UserDetailsMainInfoViewDelegate {

	func didChangeFavoriteStatus(for user: GithubUser, to isFavorite: Bool) {
		if isFavorite {
			DataManager.shared.addUserToFavorites(user)
		} else {
			DataManager.shared.removeUserFromFavorites(user)
		}
	}
}
