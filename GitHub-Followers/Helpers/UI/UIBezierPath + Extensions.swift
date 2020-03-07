//
//  UIBezierPath + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 29.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIBezierPath {

	func scaled(to rect: CGRect) -> UIBezierPath {
		let scaledPath = copy() as! UIBezierPath
		
		// scale to fit
		let scaleFactor = min(rect.width / bounds.width, rect.height / bounds.height)
		scaledPath.apply(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
		
		return scaledPath
	}
}
