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
	
	private let user: GithubUser
	
	
	// MARK: - Init
	
	init(user: GithubUser) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
		
		setupView()
		setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupView() {
		view.backgroundColor = .systemBackground
	}
	
	private func setupSubviews() {
		let mainInfoView = createMainInfoView()
		
		let descriptionLabel = GFLabel(text: "Гаврила был примерным мужем: Гаврила женам верен был!", allowMultipleLines: true)
		
		let detailsView = createDetailsView()
		
		let sinceLabel = GFLabel(text: "GitHub since xxxxx", color: .systemGray2, alignment: .center)
		let spacerView = UIView()

		let mainStack = VerticalStackView([mainInfoView, descriptionLabel, detailsView, sinceLabel, spacerView], spacing: 28)
		mainStack.setCustomSpacing(14, after: detailsView)

		view.addSubview(mainStack)
		mainStack.constrainToSuperview(padding: 20, respectSafeArea: true)
	}
	
	private func createMainInfoView() -> UIView {
		let profileImageView = GFImageView(asset: .avatarPlaceholder)
		profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
		
		let nicknameLabel = GFLabel(text: user.name, font: .systemFont(ofSize: 28, weight: .medium))
		let fullNameLabel = GFLabel(text: "Никифор Ляпис-Трубецкой")
		let locationLabel = GFLabel(text: "􀎫 Saint-Petersburg")
		
		let userInfoStack = VerticalStackView([nicknameLabel, fullNameLabel, locationLabel], spacing: 4)
		
		return HorizontalStackView([profileImageView, userInfoStack], spacing: 16, alignment: .top)
	}
	
	private func createDetailsView() -> UIView {
		let detailsView = UIView()
		detailsView.backgroundColor = .darkGray
		detailsView.layer.cornerRadius = 16
		
		let infoBlocksText = ["􀈕 Public Repos\n6", "􀈿 Public Gists\n2"]
		let infoBlockLabels = infoBlocksText.map { labelText in
			GFLabel(text: labelText,
					font: .systemFont(ofSize: 16, weight: .medium),
					color: .white,
					alignment: .center,
					allowMultipleLines: true)
		}
		
		let infoBlockStack = HorizontalStackView(infoBlockLabels, alignment: .leading, distribution: .fillEqually)

		let actionButton = UIButton(type: .system)
		actionButton.backgroundColor = .systemPurple
		actionButton.setTitleColor(.white, for: .normal)
		actionButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
		actionButton.layer.cornerRadius = 8
		actionButton.setTitle("GitHub Profile", for: .normal)
		actionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
		
		let detailViewStack = VerticalStackView([infoBlockStack, actionButton], spacing: 18)
		
		detailsView.addSubview(detailViewStack)
		detailViewStack.constrainToSuperview(padding: 18)
		
		return detailsView
	}
}
