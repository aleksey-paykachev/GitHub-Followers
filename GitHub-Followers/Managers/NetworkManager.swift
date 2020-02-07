//
//  NetworkManager.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class NetworkManager {
	// MARK: - Properties
	
	static let shared = NetworkManager()
	
	private let baseUrl = URL(string: "https://api.github.com")
	private lazy var usersUrl = baseUrl?.appendingPathComponent("users")

	
	// MARK: - Init
	
	private init() {}

	
	// MARK: - GF API
	
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
	
	func getProfileImage(for githubUser: GithubUser,
						 completionQueue: DispatchQueue = .main,
						 completion: @escaping ((Result<UIImage, NetworkError>) -> Void)) {
		
		let url = githubUser.avatarUrl
		
		getData(from: url) { result in
			completionQueue.async {

				switch result {
				case .failure(let error):
					completion(.failure(error))

				case .success(let data):
					guard let image = UIImage(data: data) else {
						completion(.failure(.wrongData))
						return
					}
					
					completion(.success(image))
				}
			}
		}
	}
	

	// MARK: - Generic API
	
	func getParsedData<T: Decodable>(from url: URL?,
									 completion: @escaping ((Result<T, NetworkError>) -> Void)) {
		
		getData(from: url) { result in
			switch result {
			case .failure(let error):
				completion(.failure(error))

			case .success(let data):
				do {
					let parsedData: T = try Parser.parse(data)
					completion(.success(parsedData))
				} catch {
					completion(.failure(.parseError(error)))
				}
			}
		}
	}
	
	func getData(from url: URL?,
				 completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
		
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
			
			guard let data = data else {
				completion(.failure(.emptyData))
				return
			}
			
			completion(.success(data))
		}.resume()
	}
	
	
	// MARK: - Errors
	
	enum NetworkError: Error {
		case wrongUrl
		case requestFailed(Error)
		case wrongResponse
		case notFound
		case wrongStatusCode(Int)
		case emptyData
		case wrongData
		case parseError(Error)
	}
}
