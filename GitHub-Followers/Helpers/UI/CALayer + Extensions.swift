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
}
