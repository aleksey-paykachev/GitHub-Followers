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
	
	private let cache = NSCache<NSURL, NetworkResponse>()
	

	// MARK: - API
	
	func getImage(from url: URL?,
				  completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
		
		getNetworkResponse(from: url) { result in
			switch result {
			case .failure(let error):
				completion(.failure(error))
				
			case .success(let response):
				guard let image = UIImage(data: response.data) else {
					completion(.failure(.wrongData))
					return
				}
				
				completion(.success(image))
			}
		}
	}
	
	func getParsedData<T: Decodable>(from url: URL?,
									 completion: @escaping (Result<T, NetworkError>) -> Void) {
		
		getNetworkResponse(from: url) { result in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let response):
				do {
					let parsedData: T = try Parser.parse(response.data)
					completion(.success(parsedData))
				} catch {
					completion(.failure(.parseError(error)))
				}
			}
		}
	}
	
	func getNetworkParsedResult<T>(from url: URL?,
								   completion: @escaping (Result<NetworkParsedResult<T>, NetworkError>) -> Void) {
		
		getNetworkResponse(from: url) { result in
			switch result {
			case .failure(let error):
				completion(.failure(error))

			case .success(let response):
				do {
					let parsedData: T = try Parser.parse(response.data)
					let networkResult = NetworkParsedResult(data: parsedData, headers: response.headers)
					completion(.success(networkResult))

				} catch {
					completion(.failure(.parseError(error)))
				}
			}
		}
	}
	
	func getNetworkResponse(from url: URL?,
							completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
		
		guard let url = url else {
			completion(.failure(.wrongUrl))
			return
		}
		
		// try to load data from cache
		if let cachedResponse = cache.object(forKey: url as NSURL) {
			completion(.success(cachedResponse))
			return
		}
		
		// if there is no cached data, load it from network
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(.requestFailed(error)))
				return
			}
			
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(.failure(.wrongResponse))
				return
			}
			
			let statusCode = httpResponse.statusCode
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
			
			let networkResponse = NetworkResponse(data: data, httpResponse: httpResponse)
			
			self.cache.setObject(networkResponse, forKey: url as NSURL)
			completion(.success(networkResponse))
			
		}.resume()
	}
}
