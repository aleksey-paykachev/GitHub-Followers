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
	
	private let photoImageView = GFImageView()
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
		photoImageView.constrainWidthToHeight()

		// username
		usernameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

		// stack
		let stack = VStackView([photoImageView, usernameLabel], alignment: .center)
		contentView.addSubview(stack)
		stack.constrainToSuperview()
	}
	
	
	// MARK: - API
	
	func set(follower: GithubFollower) {
		usernameLabel.text = follower.username

		imageDownloaderSubscriber = DataManager.shared
										.profileImagePublisher(for: follower)
										.assign(to: \.image, on: photoImageView)
	}
	
	
	// MARK: - Internal methods
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		imageDownloaderSubscriber?.cancel()

		photoImageView.image = nil
		usernameLabel.text = ""
	}
}
