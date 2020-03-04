//
//  GFEmptyStateView.swift
//  GitHub-Followers
//
//  Created by Aleksey on 03.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFEmptyStateView: UIView {
	// MARK: - Properties
	
	private let text: String
	private let image: UIImage?
	
	
	// MARK: - Init
	
	init(text: String, image: UIImage? = UIImage(asset: .emptyState)) {
		self.text = text
		self.image = image
		
		super.init(frame: .zero)
		setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupSubviews() {
		// label
		let emptyStateLabel = GFLabel(text: text, fontSize: 23, color: .gfTextSecondary, alignment: .center, allowMultipleLines: true)
		
		addSubview(emptyStateLabel)
		emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			emptyStateLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -80),
			emptyStateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
		])
		
		// image
		let emptyStateImageView = GFImageView(asset: .emptyState)
		
		addSubview(emptyStateImageView)
		emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			emptyStateImageView.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor),
			emptyStateImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			emptyStateImageView.centerXAnchor.constraint(equalTo: trailingAnchor, constant: -50)
		])
	}
}
