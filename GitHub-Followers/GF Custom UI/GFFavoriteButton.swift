//
//  GFFavoriteButton.swift
//  GitHub-Followers
//
//  Created by Aleksey on 07.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFFavoriteButton: GFCustomPathButton {
	// MARK: - Init

	init(sideSize: CGFloat, animationDuration: TimeInterval) {
		super.init(path: .starSymbol,
				   sideSize: sideSize,
				   borderWidth: 2,
				   animationDuration: animationDuration,
				   borderColor: .gfFavoriteButtonBorder,
				   fillColor: .gfFavoriteButtonFill,
				   backgroundFillColor: .gfFavoriteButtonBackground)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
