//
//  UserDetailsViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 09.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit
import SafariServices

protocol UserDetailsViewControllerDelegate: class {
	func viewFollowersButtonDidPressed(for user: GithubUser)
	func didFailToLoadData(with error: NetworkError)
}

class UserDetailsViewController: GFViewController {
	// MARK: - Properties
	
	private var user: GithubUser?
	weak var delegate: UserDetailsViewControllerDelegate?
	
	
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
		view.backgroundColor = .gfBackground
	}
	
	
	// MARK: - Load data
	
	private func loadUserData(for username: String) {
		showLoadingOverlay()

		DataManager.shared.getUser(by: username) { [weak self] result in
			guard let self = self else { return }
			self.hideLoadingOverlay()

			switch result {
			case .success(let user):
				self.user = user
				self.createUI(for: user)

			case .failure(let error):
				self.dismiss(animated: true) {
					self.delegate?.didFailToLoadData(with: error)
				}
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
		let sinceLabel = GFLabel(text: registeredText, color: .gfTextSecondary, alignment: .center)

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
		guard let userProfileUrl = user?.profilePageUrl else {
			showError("Could not show user profile page. Please try again later.")
			return
		}

		let safariViewController = SFSafariViewController(url: userProfileUrl)
		present(safariViewController, animated: true)
	}
	
	private func viewFollowersButtonDidPressed() {
		guard let user = user else { return }

		delegate?.viewFollowersButtonDidPressed(for: user)
		dismiss(animated: true)
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
