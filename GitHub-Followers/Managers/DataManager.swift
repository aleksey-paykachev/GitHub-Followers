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
	
	func getFollowers(for username: String,
					  completionQueue: DispatchQueue = .main,
					  completion: @escaping ((Result<[GithubUser], NetworkManager.NetworkError>) -> Void)) {
		
		let url = usersUrl?.appending([username, "followers"])
		
		networkManager.getParsedData(from: url) { result in
			completionQueue.async {
				completion(result)
			}
		}
	}
	
	func getProfileImage(for githubUser: GithubUser,
						 completionQueue: DispatchQueue = .main,
						 completion: @escaping ((Result<UIImage, NetworkManager.NetworkError>) -> Void)) {
		
		let url = githubUser.avatarUrl

		networkManager.getImage(from: url) { result in
			completionQueue.async {
				completion(result)
			}
		}
	}
}
