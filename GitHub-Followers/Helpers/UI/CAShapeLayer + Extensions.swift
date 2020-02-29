//
//  CAShapeLayer + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 29.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension CAShapeLayer {
	convenience init(path: CGPath) {
		self.init()
		
		self.path = path
	}
}
