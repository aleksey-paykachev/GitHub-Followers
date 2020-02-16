//
//  DataManager.swift
//  GitHub-Followers
//
//  Created by Aleksey on 08.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class DataManager {
	// MARK: - Properties
	
	static let shared = DataManager()
	
	private let persistentManager = PersistentManager()
	private let networkManager = NetworkManager()
	
	private let baseUrl = URL(string: "https://api.github.com")
	private lazy var usersUrl = baseUrl?.appendingPathComponent("users")

	
	// MARK: - Init
	
	private init() {}

	
	// MARK: - API Users
	
	func getUser(by username: String,
				 completionQueue: DispatchQueue = .main,
				 completion: @escaping (Result<GithubUser, NetworkManager.NetworkError>) -> Void) {
		
		let url = usersUrl?.appending(username)
		
		networkManager.getParsedData(from: url) { result in
			completionQueue.async {
				completion(result)
			}
		}
	}
	
	func getFollowers(for username: String,
					  completionQueue: DispatchQueue = .main,
					  completion: @escaping (Result<[GithubFollower], NetworkManager.NetworkError>) -> Void) {
		
		let url = usersUrl?.appending(username, "followers")

		networkManager.getParsedData(from: url) { result in
			completionQueue.async {
				completion(result)
			}
		}
	}
	
	func getProfileImage(for githubProfile: GithubProfile,
						 completionQueue: DispatchQueue = .main,
						 completion: @escaping (Result<UIImage, NetworkManager.NetworkError>) -> Void) {
		
		let url = githubProfile.profileImageUrl

		networkManager.getImage(from: url) { result in
			completionQueue.async {
				completion(result)
			}
		}
	}
	
	
	// MARK: - API Favorites
	
	var allFavorites: [GithubUser] {
		persistentManager.get(type: [GithubUser].self, from: .favorites) ?? []
	}
	
	func checkIfFavorite(user: GithubUser) -> Bool {
		allFavorites.contains(user)
	}
	
	func addUserToFavorites(_ user: GithubUser) {
		var favorites = allFavorites
		
		if favorites.contains(user) {
			return
		}
		
		favorites.append(user)
		persistentManager.set(value: favorites, to: .favorites)
	}
	
	func removeUserFromFavorites(_ user: GithubUser) {
		var favorites = allFavorites
		
		favorites.removeAll { $0 == user }
		persistentManager.set(value: favorites, to: .favorites)
	}
}
