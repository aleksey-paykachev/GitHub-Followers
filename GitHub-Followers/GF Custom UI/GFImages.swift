//
//  GFImages.swift
//  GitHub-Followers
//
//  Created by Aleksey on 04.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

// All static images will be loaded at the runtime and persistently stored in memory.
// This is a known behaviour and not an issue in this small application.

extension UIImage {
	// Assets
	static let assetAvatarPlaceholder = UIImage(named: "avatar-placeholder")
	static let assetEmptyState = UIImage(named: "empty-state-logo")
	static let assetLogo = UIImage(named: "gh-logo")
	
	// SF Symbols
	static let sfSymbolCCircle = UIImage(systemName: "c.circle")
	static let sfSymbolDocText = UIImage(systemName: "doc.text")
	static let sfSymbolFolder = UIImage(systemName: "folder")
	static let sfSymbolHeart = UIImage(systemName: "heart")
	static let sfSymbolMagnifyingglass = UIImage(systemName: "magnifyingglass")
	static let sfSymbolMappinAndEllipse = UIImage(systemName: "mappin.and.ellipse")
	static let sfSymbolPerson = UIImage(systemName: "person")
	static let sfSymbolPerson2 = UIImage(systemName: "person.2")
	static let sfSymbolStar = UIImage(systemName: "star")
	static let sfSymbolStarFill = UIImage(systemName: "star.fill")
	static let sfSymbolStarSlash = UIImage(systemName: "star.slash")
	static let sfSymbolChevronUp = UIImage(systemName: "chevron.up")
	static let sfSymbolChevronDown = UIImage(systemName: "chevron.down")
}
