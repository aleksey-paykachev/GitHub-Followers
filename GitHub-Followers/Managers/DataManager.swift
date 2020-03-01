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
	private lazy var usersUrl = baseUrl?.appendingPath("users")
	private let usersPerRequest = 100

	
	// MARK: - Init
	
	private init() {}

	
	// MARK: - API Users
	
	func getUser(by username: String,
				 completionQueue: DispatchQueue = .main,
				 completion: @escaping (Result<GithubUser, NetworkError>) -> Void) {
		
		let url = usersUrl?.appendingPath(username)
		
		networkManager.getParsedData(from: url) { result in
			completionQueue.async {
				completion(result)
			}
		}
	}
	
	func getFollowers(for username: String,
					  url: URL? = nil,
					  completionQueue: DispatchQueue = .main,
					  completion: @escaping (Result<NetworkParsedResult<[GithubFollower]>, NetworkError>) -> Void) {
		
		// if no url were provided, construct request url from username in following format:
		// baseUsersUrl/%username%/followers?per_page=n
		let url = url ?? usersUrl?.appendingPath(username, "followers").appendingQuery("per_page", value: usersPerRequest)
			
		networkManager.getNetworkParsedResult(from: url) { result in
			completionQueue.async {
				completion(result)
			}
		}
	}
	
	func getProfileImage(for githubProfile: GithubProfile,
						 completionQueue: DispatchQueue = .main,
						 completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
		
		let url = githubProfile.profileImageUrl

		networkManager.getImage(from: url) { result in
			completionQueue.async {
				completion(result)
			}
		}
	}
	
	
	// MARK: - API Favorites
	
	private func save(_ favorites: [GithubUser]) {
		persistentManager.set(value: favorites, to: .favorites)
	}
	
	var allFavorites: [GithubUser] {
		persistentManager.get(type: [GithubUser].self, from: .favorites) ?? []
	}
	
	func checkIfFavorite(user: GithubUser) -> Bool {
		allFavorites.contains(user)
	}
	
	func addUserToFavorites(_ user: GithubUser) {
		var favorites = allFavorites
		
		guard !favorites.contains(user) else { return }
		
		favorites.append(user)
		save(favorites)
	}
	
	func removeUserFromFavorites(_ user: GithubUser) {
		var favorites = allFavorites
		
		favorites.removeAll { $0 == user }
		save(favorites)
	}
	
	func sortFavorites(by sortingPredicate: (GithubUser, GithubUser) -> Bool) {
		let sortedFavorites = allFavorites.sorted(by: sortingPredicate)
		save(sortedFavorites)
	}
	
	func moveFavorite(from sourceIndex: Int, to destinationIndex: Int) {
		var favorites = allFavorites
		
		let movedUser = favorites.remove(at: sourceIndex)
		favorites.insert(movedUser, at: destinationIndex)
		
		save(favorites)
	}
}
