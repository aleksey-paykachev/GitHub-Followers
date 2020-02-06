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
	
	func getFollowers(for username: String,
					  completionQueue: DispatchQueue = .main,
					  completion: @escaping ((Result<[GithubUser], NetworkError>) -> Void)) {
		
		let url = usersUrl?.appending([username, "followers"])
		
		getParsedData(from: url) { result in
			completionQueue.async {
				completion(result)
			}
		}
	}
	
	func getParsedData<T: Decodable>(from url: URL?,
									 completion: @escaping ((Result<T, NetworkError>) -> Void)) {
		
		guard let url = url else {
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
					completion(.failure(.notFound))
				default:
					completion(.failure(.wrongStatusCode(statusCode)))
				}
				return
			}
			
			let parsedData: T
			do {
				parsedData = try Parser.parse(data)
			} catch {
				completion(.failure(.parseError(error)))
				return
			}
			
			completion(.success(parsedData))
			
		}.resume()
	}
	
	
	// MARK: - Errors
	
	enum NetworkError: Error {
		case wrongUrl
		case requestFailed(Error)
		case wrongResponse
		case notFound
		case wrongStatusCode(Int)
		case parseError(Error)
	}
}
