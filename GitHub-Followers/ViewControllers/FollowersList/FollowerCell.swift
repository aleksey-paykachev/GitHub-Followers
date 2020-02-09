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
	
	var follower: GithubUser? { didSet { updateUI() } }
	
	private let profilePhotoImageView = UIImageView(image: nil)
	private let profileLoginLabel = UILabel()
	
	
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
		profilePhotoImageView.contentMode = .scaleAspectFill
		profilePhotoImageView.clipsToBounds = true
		profilePhotoImageView.layer.cornerRadius = 12
		profilePhotoImageView.widthAnchor.constraint(equalTo: profilePhotoImageView.heightAnchor).isActive = true
		
		profilePhotoImageView.layer.borderColor = UIColor.systemGray3.cgColor
		profilePhotoImageView.layer.borderWidth = 1
		
		// stack
		let stack = VerticalStackView([profilePhotoImageView, profileLoginLabel], alignment: .center)
		contentView.addSubview(stack)

		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			stack.topAnchor.constraint(equalTo: contentView.topAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	
	// MARK: - Update UI
	
	private func updateUI() {
		guard let follower = follower else { return }

		profileLoginLabel.text = follower.name

		DataManager.shared.getProfileImage(for: follower) { result in
			if case Result.success(let image) = result {
				self.profilePhotoImageView.image = image
			}
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		profilePhotoImageView.image = nil
		profileLoginLabel.text = ""
	}
}

