//
//  UIImage + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 12.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIImage {
	// MARK: - Init
	
	convenience init?(asset: GFImageAsset) {
		self.init(named: asset.imageName)
	}
	

	// MARK: - Image Assets

	enum GFImageAsset: String {
		case avatarPlaceholder = "avatar-placeholder"
		case emptyState = "empty-state-logo"
		case logo = "gh-logo"
		
		var imageName: String {
			rawValue
		}
	}
}
