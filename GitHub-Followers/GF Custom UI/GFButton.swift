//
//  GFButton.swift
//  GitHub-Followers
//
//  Created by Aleksey on 05.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFButton: UIButton {
	// MARK: - Init
	
	convenience init(title: String = "",
					 color: UIColor? = .gfTextInverted,
					 backgroundColor: UIColor = .gfPrimary) {

		self.init(type: .system)
		
		// setup
		setTitle(title, for: .normal)
		self.tintColor = color
		self.backgroundColor = backgroundColor

		setupView()
	}
	
	
	// MARK: - Setup
	
	private func setupView() {
		titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
		layer.setCornerRadius(8)
	}
}
