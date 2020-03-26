//
//  GFCircleButton.swift
//  GitHub-Followers
//
//  Created by Aleksey on 27.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFCircleButton: UIButton {
	// Init
	
	convenience init(radius: CGFloat, image: UIImage? = nil) {
		self.init(type: .system)
		
		// setup
		setImage(image, for: .normal)

		layer.setBorder(color: .gfPrimary, width: 2)
		layer.setCornerRadius(radius)
		
		constrainSize(width: radius * 2, height: radius * 2)
	}
}
