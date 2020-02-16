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
	
	private let cache = NSCache<NSURL, NSData>()
	

	// MARK: - API
	
	func getImage(from url: URL?,
				  completion: @escaping ((Result<UIImage, NetworkError>) -> Void)) {
		
		getData(from: url) { result in
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
		
		// try to load data from cache
		if let cachedData = cache.object(forKey: url as NSURL) as Data? {
			completion(.success(cachedData))
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
			
			self.cache.setObject(data as NSData, forKey: url as NSURL)
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
