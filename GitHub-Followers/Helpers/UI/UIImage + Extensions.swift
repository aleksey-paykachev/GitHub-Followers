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
	
	convenience init?(sfSymbol: SFSymbol) {
		self.init(systemName: sfSymbol.imageName)
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
	
	
	// MARK: - SF Symbols
	
	enum SFSymbol: String {
		case docText = "doc.text"
		case folder = "folder"
		case magnifyingglass = "magnifyingglass"
		case mappinAndEllipse = "mappin.and.ellipse"
		case person = "person"
		case person2 = "person.2"
		case person3 = "person.3"
		case star = "star"
		case starFill = "star.fill"
		case chevronUp = "chevron.up"
		case chevronDown = "chevron.down"
		
		var imageName: String {
			rawValue
		}
	}
}
