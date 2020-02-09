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
		let mainInfoStack = createMainInfoStack()
		
		let descriptionLabel = UILabel()
		descriptionLabel.numberOfLines = 0
		descriptionLabel.text = "Гаврила был примерным мужем: Гаврила женам верен был!"

		let detailsView = createDetailsView()
		
		let sinceLabel = UILabel()
		sinceLabel.textAlignment = .center
		sinceLabel.textColor = .systemGray2
		sinceLabel.text = "GitHub since xxxxx"
		
		let spacerView = UIView()

		let mainStack = VerticalStackView([mainInfoStack, descriptionLabel, detailsView, sinceLabel, spacerView], spacing: 28)
		mainStack.setCustomSpacing(14, after: detailsView)

		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		let padding: CGFloat = 20
		NSLayoutConstraint.activate([
			mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
			mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
			mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
			mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
		])
	}
	
	private func createMainInfoStack() -> UIStackView {
		let profileImageView = GFImageView(asset: .avatarPlaceholder)
		profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
		
		let nicknameLabel = UILabel()
		nicknameLabel.font = .systemFont(ofSize: 28, weight: .medium)
		nicknameLabel.text = user.name
		
		let fullNameLabel = UILabel()
		fullNameLabel.text = "Никифор Ляпис-Трубецкой"
		
		let locationLabel = UILabel()
		locationLabel.text = "􀎫 Saint-Petersburg"
		
		let secondaryInfoStack = VerticalStackView([nicknameLabel, fullNameLabel, locationLabel], spacing: 4)
		
		let mainInfoStack = UIStackView(arrangedSubviews: [profileImageView, secondaryInfoStack])
		mainInfoStack.axis = .horizontal
		mainInfoStack.spacing = 16
		mainInfoStack.alignment = .top
		
		return mainInfoStack
	}
	
	private func createDetailsView() -> UIView {
		let detailsView = UIView()
		detailsView.backgroundColor = .darkGray
		detailsView.layer.cornerRadius = 16
		
		let infoBlock1Label = UILabel()
		infoBlock1Label.textColor = .white
		infoBlock1Label.font = .systemFont(ofSize: 16, weight: .medium)
		infoBlock1Label.numberOfLines = 2
		infoBlock1Label.textAlignment = .center
		infoBlock1Label.text = "􀈕 Public Repos\n6"
		
		let infoBlock2Label = UILabel()
		infoBlock2Label.textColor = .white
		infoBlock2Label.font = .systemFont(ofSize: 16, weight: .medium)
		infoBlock2Label.numberOfLines = 2
		infoBlock2Label.textAlignment = .center
		infoBlock2Label.text = "􀈿 Public Gists\n2"
		
		let infoBlockStack = UIStackView(arrangedSubviews: [infoBlock1Label, infoBlock2Label])
		infoBlockStack.axis = .horizontal
		infoBlockStack.distribution = .fillEqually
		infoBlockStack.alignment = .leading

		let actionButton = UIButton(type: .system)
		actionButton.backgroundColor = .systemPurple
		actionButton.setTitleColor(.white, for: .normal)
		actionButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
		actionButton.layer.cornerRadius = 8
		actionButton.setTitle("GitHub Profile", for: .normal)
		actionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
		
		let detailViewStack = VerticalStackView([infoBlockStack, actionButton], spacing: 18)
		
		detailsView.addSubview(detailViewStack)
		detailViewStack.translatesAutoresizingMaskIntoConstraints = false
		let padding: CGFloat = 18
		NSLayoutConstraint.activate([
			detailViewStack.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: padding),
			detailViewStack.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: padding),
			detailViewStack.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -padding),
			detailViewStack.bottomAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: -padding)
		])
		
		return detailsView
	}
}
