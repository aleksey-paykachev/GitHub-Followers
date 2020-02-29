//
//  UIBezierPath + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 29.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIBezierPath {

	func scale(to rect: CGRect) -> UIBezierPath {
		let scaleFactor = rect.width / bounds.width
		apply(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
		
		return self
	}
}
