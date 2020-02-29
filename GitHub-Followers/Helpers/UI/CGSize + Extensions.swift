//
//  CGSize + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 28.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import CoreGraphics

extension CGSize {

	static func square(_ sideSize: CGFloat) -> CGSize {
		CGSize(width: sideSize, height: sideSize)
	}
}
