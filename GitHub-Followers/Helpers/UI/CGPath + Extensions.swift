//
//  CGPath + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 29.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import CoreGraphics

extension CGPath {

	static func circle(in rect: CGRect) -> CGPath {
		CGPath(ellipseIn: rect, transform: nil)
	}
	
	static func circle(center: CGPoint, radius: CGFloat) -> CGPath {
		circle(in: CGRect(origin: center, size: CGSize(width: radius * 2, height: radius * 2)))
	}
}
