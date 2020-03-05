//
//  GFColors.swift
//  GitHub-Followers
//
//  Created by Aleksey on 20.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIColor {
	// Main
	static let gfPrimary = UIColor.systemGreen
	static let gfSecondary = UIColor.systemPurple
	static let gfBackground = UIColor.systemBackground

	// Text
	static let gfText = UIColor.label
	static let gfTextAccented = UIColor.white
	static let gfTextSecondary = UIColor.secondaryLabel

	// Text field
	static let gfTextFieldBorder = UIColor.tertiarySystemFill
	static let gfTextFieldBackground = UIColor.tertiarySystemBackground

	// Image
	static let gfImageBorder = UIColor.systemGray3
	
	// Cell
	static let gfFavoriteCell = UIColor.tertiarySystemBackground
	static let gfFavoriteCellSelected = UIColor.secondarySystemBackground

	// Favorite button
	static let gfFavoriteButtonBorder = UIColor.systemOrange.withAlphaComponent(0.8)
	static let gfFavoriteButtonFill = UIColor.systemOrange.withAlphaComponent(0.55)
	static let gfFavoriteButtonBackground = UIColor.white
	
	// Other
	static let gfShadow = UIColor.black
	static let gfError = UIColor.systemRed
	
	static let gfDetailsInfoBlockBackground = UIColor.secondarySystemBackground
}
