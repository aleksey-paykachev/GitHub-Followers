//
//  UserDetailsViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 09.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit
import SafariServices
import Combine

protocol UserDetailsViewControllerDelegate: class {
	func viewFollowersButtonDidPressed(for user: GithubUser)
	func didFailToLoadData(with error: NetworkError)
}

class UserDetailsViewController: GFViewController {
	// MARK: - Properties
	
	private var user: GithubUser?
	private var subscribers: Set<AnyCancellable> = []
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
	
	
	// MARK: - Private methods
	// Create UI
	
	private func createUI(for user: GithubUser) {
		// close button
		let closeButton = UIButton(type: .close)
		closeButton.addTarget(self, action: #selector(closeButtonDidPressed), for: .touchUpInside)
		let actionButtonsStack = HStackView([SpacerView(), closeButton])

		// main info
		let isUserFavorite = DataManager.shared.checkIfFavorite(user: user)
		let mainInfoView = UserDetailsMainInfoView(user: user, isFavorite: isUserFavorite)
		mainInfoView.delegate = self
		DataManager.shared.profileImagePublisher(for: user)
							.assign(to: \.profileImageView.image, on: mainInfoView)
							.store(in: &subscribers)
		
		// description
		let descriptionLabel = GFLabel(text: user.description, allowMultipleLines: true)

		// details views
		let userWorkActivityDetailsView = UserDetailsInfoBlocksView(
			infoBlocks: [.repos(count: user.repositoriesCount),
						 .gists(count: user.gistsCount)],
			buttonData: .init(title: "GitHub Profile", type: .primary, action: { [weak self] in
				self?.githubProfileButtonDidPressed()
			})
		)
		
		let userSocialActivityDetailsView = UserDetailsInfoBlocksView(
			infoBlocks: [.followers(count: user.followersCount),
						 .following(count: user.followingCount)],
			buttonData: .init(title: "View Followers", type: .secondary, action: { [weak self] in
				self?.viewFollowersButtonDidPressed()
			})
		)

		// registered
		let registeredText = "Registered \(user.accountRegistrationDate.relativeToNowText)"
		let sinceLabel = GFLabel(text: registeredText, color: .gfTextSecondary, alignment: .center)

		// main stack
		let mainStack = VStackView([actionButtonsStack, mainInfoView, descriptionLabel, userWorkActivityDetailsView, userSocialActivityDetailsView, sinceLabel], spacing: 22)
		mainStack.setCustomSpacing(4, after: actionButtonsStack)
		mainStack.setCustomSpacing(14, after: userSocialActivityDetailsView)
		
		// scroll view (main container)
		let scrollView = UIScrollView()
		view.insertSubview(scrollView, at: 0) // add behind loading overlay view
		scrollView.constrainToSuperview()
		scrollView.verticalScrollIndicatorInsets.top = 10

		let contentPaddingToParentWidthRatio: CGFloat = 0.04
		let contentPadding = view.bounds.width * contentPaddingToParentWidthRatio

		scrollView.addSubview(mainStack)
		mainStack.constrainToSuperview(padding: contentPadding)
		mainStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -contentPadding * 2).isActive = true
	}
	
	
	// Actions

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
