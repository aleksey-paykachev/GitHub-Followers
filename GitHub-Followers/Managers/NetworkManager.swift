//
//  NetworkManager.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

class NetworkManager {
	// MARK: - Properties
	
	static let shared = NetworkManager()
	
	private let baseUrl = URL(string: "https://api.github.com")
	private lazy var usersUrl = baseUrl?.appendingPathComponent("users")

	
	// MARK: - Init
	
	private init() {}

	
	// MARK: - API
	
	func getFollowers(for username: String, completion: @escaping ((Result<[GithubUser], NetworkError>) -> Void)) {

		guard let url = usersUrl?.appending([username, "followers"]) else {
			completion(.failure(.wrongUrl))
			return
		}
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(.requestFailed(error)))
				return
			}
			
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
				completion(.failure(.wrongResponse))
				return
			}

			guard statusCode == 200 else {
				switch statusCode {
				case 404:
					completion(.failure(.userNotFound))
				default:
					completion(.failure(.wrongStatusCode(statusCode)))
				}
				return
			}
			
			let users: [GithubUser]
			do {
				users = try Parser.parse(data)
			} catch {
				completion(.failure(.parseError(error)))
				return
			}
			
			completion(.success(users))
			
		}.resume()
	}
	
	
	// MARK: - Errors
	
	enum NetworkError: Error {
		case wrongUrl
		case requestFailed(Error)
		case wrongResponse
		case userNotFound
		case wrongStatusCode(Int)
		case parseError(Error)
	}
}
