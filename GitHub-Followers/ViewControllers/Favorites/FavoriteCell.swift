//
//  FavoriteCell.swift
//  GitHub-Followers
//
//  Created by Aleksey on 15.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit
import Combine

class FavoriteCell: UITableViewCell {
	// MARK: - Properties
	
	private let containerView = UIView()
	private let photoImageView = GFImageView(image: .assetAvatarPlaceholder)
	private let usernameLabel = GFLabel(fontSize: 22)
	private let followersCountLabel = GFLabel(fontSize: 16, color: .gfTextSecondary)
	
	private var imageDownloaderSubscriber: AnyCancellable?

	
	// MARK: - Init
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupView()
		setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupView() {
		selectionStyle = .none
	}
	
	private func setupSubviews() {
		// photo image
		photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor, multiplier: 1).isActive = true
		photoImageView.layer.setCornerRadius(10)
		
		// container
		containerView.layer.setShadow(radius: 3, opacity: 0.1, offsetX: 2, offsetY: 2)
		contentView.addSubview(containerView)
		containerView.constrainToSuperview(padding: 9)

		// user info stacks
		let followersImageLabel = GFLabel(text: "Followers:", image: .sfSymbolPerson2, fontSize: followersCountLabel.font.pointSize, color: followersCountLabel.textColor)
		
		let followersInfoStack = HStackView([followersImageLabel, followersCountLabel], spacing: 4)
		let userInfoStack = VStackView([usernameLabel, followersInfoStack], spacing: 6, alignment: .leading)
		
		// main stack
		let stack = HStackView([photoImageView, userInfoStack], spacing: 16, alignment: .leading)
		containerView.addSubview(stack)
		stack.constrainToSuperview(padding: 9)
	}
	
	
	// MARK: - API
	
	func set(user: GithubUser) {
		usernameLabel.text = user.username
		followersCountLabel.text = String(user.followersCount)
		
		imageDownloaderSubscriber = DataManager.shared
										.profileImagePublisher(for: user)
										.assign(to: \.image, on: photoImageView)
	}
	
	
	// MARK: - Internal methods
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		containerView.backgroundColor = isSelected ? .gfFavoriteCellSelected : .gfFavoriteCell
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		imageDownloaderSubscriber?.cancel()

		usernameLabel.text = ""
		followersCountLabel.text = ""
		photoImageView.image = .assetAvatarPlaceholder
	}
}
