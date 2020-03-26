//
//  ApplicationAppearanceManager.swift
//  GitHub-Followers
//
//  Created by Aleksey on 26.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

struct ApplicationAppearanceManager {

	static func setupAppearance() {
		// tab bar
		UITabBar.appearance().tintColor = .gfPrimary
		
		// navigation bar
		UINavigationBar.appearance().tintColor = .gfPrimary
		
		// button
		UIButton.appearance().tintColor = .gfPrimary
	}
}
