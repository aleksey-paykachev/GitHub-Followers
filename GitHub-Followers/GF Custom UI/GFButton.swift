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
	
	convenience init(title: String) {
		self.init(type: .system)
		
		setTitle(title, for: .normal)
		setupView()
	}
	
	
	// MARK: - Setup
	
	private func setupView() {
		// colors
		backgroundColor = .systemGreen
		tintColor = .systemBackground
		
		// font
		titleLabel?.font = .preferredFont(forTextStyle: .title3)
		
		// corners
		layer.cornerRadius = 8
	}
}
