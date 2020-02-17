//
//  NetworkManager.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class NetworkResponse {
	let data: Data
	let headers: [Header]?
	
	init(data: Data, headers: [Header]?) {
		self.data = data
		self.headers = headers
	}
}

enum Header {
	case nextLink(URL)
}

struct NetworkParsedResult<T: Decodable> {
	let data: T
	let headers: [Header]?
}

class NetworkManager {
	// MARK: - Properties
	
	private let cache = NSCache<NSURL, NetworkResponse>()
	

	// MARK: - API
	
	func getImage(from url: URL?,
				  completion: @escaping ((Result<UIImage, NetworkError>) -> Void)) {
		
		getData(from: url) { result in
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
									 completion: @escaping ((Result<T, NetworkError>) -> Void)) {
		
		getData(from: url) { result in
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
	
	func getParsedDataWithNetworkHeaders<T>(from url: URL?,
											completion: @escaping ((Result<NetworkParsedResult<T>, NetworkError>) -> Void)) {
		
		getData(from: url) { result in
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
	
	func getData(from url: URL?,
				 completion: @escaping ((Result<NetworkResponse, NetworkError>) -> Void)) {
		
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
			
			#warning("Parse and add headers to response")
			let networkResponse = NetworkResponse(data: data, headers: nil)
			
			self.cache.setObject(networkResponse, forKey: url as NSURL)
			completion(.success(networkResponse))
			
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
