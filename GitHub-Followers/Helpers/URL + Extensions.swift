//
//  URL + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension URL {

	func appendingPath(_ pathComponents: String...) -> URL {
		pathComponents.reduce(into: self) { url, pathComponent in
			url.appendPathComponent(pathComponent.lowercased())
		}
	}
	
	func appendingQuery(_ queryName: String, value queryValue: String) -> URL? {

		var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
		var queryItems = urlComponents?.queryItems ?? []
		queryItems.append(URLQueryItem(name: queryName, value: queryValue))
		urlComponents?.queryItems = queryItems
		
		return urlComponents?.url
	}
	
	func appendingQuery(_ queryName: String, value queryValue: Int) -> URL? {
		appendingQuery(queryName, value: "\(queryValue)")
	}
}
