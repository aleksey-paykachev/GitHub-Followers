//
//  FollowerCell.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FollowerCell: UICollectionViewCell {
	// MARK: - Properties
	
	var follower: GithubFollower? { didSet { updateUI() } }
	
	private let photoImageView = UIImageView(image: nil)
	private let usernameLabel = UILabel()
	
	
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
		photoImageView.contentMode = .scaleAspectFill
		photoImageView.layer.setCornerRadius(12)
		photoImageView.layer.setBorder(color: .systemGray3)
		photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor).isActive = true
				
		// stack
		let stack = VStackView([photoImageView, usernameLabel], alignment: .center)
		contentView.addSubview(stack)
		stack.constrainToSuperview()
	}
	
	
	// MARK: - Update UI
	
	private func updateUI() {
		guard let follower = follower else { return }

		usernameLabel.text = follower.username

		DataManager.shared.getProfileImage(for: follower) { result in
			if case Result.success(let image) = result {
				self.photoImageView.image = image
			}
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		photoImageView.image = nil
		usernameLabel.text = ""
	}
}

