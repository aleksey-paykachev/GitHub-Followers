//
//  FavoriteCell.swift
//  GitHub-Followers
//
//  Created by Aleksey on 15.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
	// MARK: - Properties
	
	private let containerView = UIView()
	private let photoImageView = GFImageView(asset: .avatarPlaceholder)
	private let usernameLabel = GFLabel(font: .systemFont(ofSize: 24))

	
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
		photoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
		photoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
		photoImageView.layer.setCornerRadius(10)
		
		containerView.layer.setShadow(radius: 3, opacity: 0.1, offsetX: 2, offsetY: 2)
		contentView.addSubview(containerView)
		containerView.constrainToSuperview(padding: 9)

		let stack = HStackView([photoImageView, usernameLabel, SpacerView()], spacing: 16, alignment: .leading)
		
		containerView.addSubview(stack)
		stack.constrainToSuperview(padding: 8)
	}
	
	
	// MARK: - Methods
	
	func set(user: GithubUser) {
		usernameLabel.text = user.username
		
		#warning("Move network logic to View Controller.")
		DataManager.shared.getProfileImage(for: user) { [weak self] result in
			guard let self = self else { return }
			
			if case .success(let image) = result {
				self.photoImageView.image = image
			}
		}
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		containerView.backgroundColor = isSelected ? .gfFavoriteCellSelected : .gfFavoriteCell
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		photoImageView.image = UIImage(asset: .avatarPlaceholder)
		usernameLabel.text = ""
	}
}
