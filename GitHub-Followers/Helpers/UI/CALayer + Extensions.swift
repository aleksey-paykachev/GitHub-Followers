//
//  CALayer + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 12.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension CALayer {

	func setBorder(color: UIColor, width: CGFloat = 1) {
		borderColor = color.cgColor
		borderWidth = width
	}
	
	func setCornerRadius(_ radius: CGFloat) {
		cornerRadius = radius
		masksToBounds = true
	}
	
	func setShadow(radius: CGFloat, color: UIColor = .black, opacity: CGFloat = 1, offsetX: CGFloat = 0, offsetY: CGFloat = 0) {

		shadowRadius = radius
		shadowColor = color.cgColor
		shadowOpacity = Float(opacity)
		shadowOffset = CGSize(width: offsetX, height: offsetY)
	}
}
