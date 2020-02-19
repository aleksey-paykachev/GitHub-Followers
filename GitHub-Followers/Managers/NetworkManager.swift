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
	
	
	// MARK: - NetworkResponse
	
	// Declared as a class to be able to cache network response using NSCache.
	class NetworkResponse {
		let data: Data
		private(set) var headers: Headers = .empty
		
		init(data: Data, httpResponse: HTTPURLResponse) {
			self.data = data

			parseHeaders(httpResponse: httpResponse)
		}
		
		private func parseHeaders(httpResponse: HTTPURLResponse) {
			/* Response from server may contain following "Link" field header:

			<baseUrl/user/48685/followers?page=1>; rel="prev", <baseUrl/user/48685/followers?page=3>; rel="next", <baseUrl/user/48685/followers?page=29>; rel="last", <baseUrl/user/48685/followers?page=1>; rel="first"

			We only interested in "next" url, and will parse it using regular expression */

			let pattern = #"(?<=<)(\S+)(?=>;\s*rel="next")"#
			
			headers.nextUrl = httpResponse.getHeader("Link")?
								.firstRegExpMatch(of: pattern)
								.flatMap { URL(string: $0) }
		}
		
		struct Headers {
			static let empty = Headers()

			// Multiple pages response URLs
			var firstUrl: URL?
			var previousUrl: URL?
			var nextUrl: URL?
			var lastUrl: URL?
		}
	}

	
	// MARK: - NetworkParsedResult
	
	struct NetworkParsedResult<T: Decodable> {
		let data: T
		let headers: NetworkResponse.Headers
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
