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
	
	private let networkManager = NetworkManager.shared
	
	private let baseUrl = URL(string: "https://api.github.com")
	private lazy var usersUrl = baseUrl?.appendingPathComponent("users")

	
	// MARK: - Init
	
	private init() {}

	
	// MARK: - API
	
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
	
	
	// MARK: - Favorites
	
	var allFavorites: [GithubUser] {
		guard let data = UserDefaults.standard.data(forKey: "favorites") else { return [] }
		
		do {
			return try PropertyListDecoder().decode([GithubUser].self, from: data)
		} catch {
			print("Error:", error.localizedDescription)
			return []
		}
	}
	
	func checkIfFavorite(user: GithubUser) -> Bool {
		allFavorites.contains(user)
	}
	
	func toggleFavorite(user: GithubUser) -> Bool {
		// read
		var favorites = allFavorites

		// update
		let isFavorite: Bool

		if favorites.contains(user) {
			favorites.removeAll { $0 == user }
			isFavorite = false
		} else {
			favorites.append(user)
			isFavorite = true
		}
		
		let data = try? PropertyListEncoder().encode(favorites)
		UserDefaults.standard.set(data, forKey: "favorites")
		
		return isFavorite
	}
}
