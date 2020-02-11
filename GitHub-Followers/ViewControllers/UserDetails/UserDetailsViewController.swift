//
//  UserDetailsViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 09.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
	// MARK: - Properties
		
	private let loadingOverlayView = GFLoadingOverlayView()

	
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
		loadingOverlayView.show(inside: view)

		DataManager.shared.getUser(by: username) { [weak self] result in
			guard let self = self else { return }
			self.loadingOverlayView.hide()

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
		let mainInfoView = UserDetailsMainInfoView(user: user)
		
		let descriptionLabel = GFLabel(text: user.description, allowMultipleLines: true)

		let userWorkActivityDetailsView = UserDetailsInfoBlocksView(
			infoBlocks: [.repos(count: user.repositoriesCount), .gists(count: user.gistsCount)],
			action: .primary(title: "GitHub Profile", completion: githubProfileButtonDidPressed))
		
		let userSocialActivityDetailsView = UserDetailsInfoBlocksView(
			infoBlocks: [.repos(count: 3)],
			action: .secondary(title: "View Followers", completion: viewFollowersButtonDidPressed))

		let registeredText = "Registered \(user.accountRegistrationDate.relativeToNowText)"
		let sinceLabel = GFLabel(text: registeredText, color: .systemGray2, alignment: .center)

		let mainStack = VerticalStackView([mainInfoView, descriptionLabel, userWorkActivityDetailsView, userSocialActivityDetailsView, sinceLabel, SpacerView()], spacing: 24)
		mainStack.setCustomSpacing(14, after: userSocialActivityDetailsView)

		view.addSubview(mainStack)
		mainStack.constrainToSuperview(padding: 20, respectSafeArea: true)
	}
	
	
	// MARK: - Actions
	
	private func githubProfileButtonDidPressed() {
		print(#function)
	}
	
	private func viewFollowersButtonDidPressed() {
		print(#function)
	}
}
