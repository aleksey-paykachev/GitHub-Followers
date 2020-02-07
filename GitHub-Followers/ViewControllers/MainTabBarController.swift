//
//  MainTabBarController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 03.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
	// MARK: - Init
	
	init() {
		super.init(nibName: nil, bundle: nil)

		setupTabBar()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupTabBar() {
		let searchViewController = SearchViewController()
		let favoritesViewController = FavoritesViewController()
		
		let searchNavigationController = UINavigationController(rootViewController: searchViewController)
		
		viewControllers = [searchNavigationController, favoritesViewController]
	}
}
