//
//  CGRect + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 28.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import CoreGraphics

extension CGRect {

	var center: CGPoint {
		CGPoint(x: midX, y: midY)
	}
	
	// excircle bounds square of given rect
	var excircleSquare: CGRect {
		let outerDiameter = (width * width + height * height).squareRoot() // hypotenuse

		let offsetX = (outerDiameter - width) / 2
		let offsetY = (outerDiameter - height) / 2
		return CGRect(origin: CGPoint(x: -offsetX, y: -offsetY), size: CGSize.square(outerDiameter))
	}
}
