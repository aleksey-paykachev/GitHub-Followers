//
//  SceneDelegate.swift
//  GitHub-Followers
//
//  Created by Aleksey on 03.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

		guard let scene = scene as? UIWindowScene else { return }

		window = UIWindow(windowScene: scene)
		window?.rootViewController = UserDetailsViewController(user: GithubUser(name: "Gavrila", profileImageUrl: nil, profilePageUrl: nil)) // MainTabBarController()
		window?.makeKeyAndVisible()
	}
}
