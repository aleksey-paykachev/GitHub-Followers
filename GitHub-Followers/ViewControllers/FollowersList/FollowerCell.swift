//
//  FollowerCell.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit
import Combine

class FollowerCell: UICollectionViewCell {
	// MARK: - Properties
	
	var follower: GithubFollower? { didSet { updateUI() } }
	
	private let photoImageView = GFImageView(asset: .avatarPlaceholder)
	private let usernameLabel = GFLabel()
	
	private var imageDownloaderSubscriber: AnyCancellable?
	
	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup

	private func setupSubviews() {
		// image view
		photoImageView.layer.setCornerRadius(12)
		photoImageView.layer.setBorder(color: .gfImageBorder)
		photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor).isActive = true

		// username
		usernameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

		// stack
		let stack = VStackView([photoImageView, usernameLabel], alignment: .center)
		contentView.addSubview(stack)
		stack.constrainToSuperview()
	}
	
	
	// MARK: - Update UI
	
	private func updateUI() {
		guard let follower = follower else { return }

		usernameLabel.text = follower.username

		imageDownloaderSubscriber = DataManager.shared
										.profileImagePublisher(for: follower)
										.assign(to: \.image, on: photoImageView)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		photoImageView.image = UIImage(asset: .avatarPlaceholder)
		imageDownloaderSubscriber?.cancel()

		usernameLabel.text = ""
	}
}

