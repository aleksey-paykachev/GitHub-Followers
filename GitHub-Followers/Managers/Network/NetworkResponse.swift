//
//  NetworkResponse.swift
//  GitHub-Followers
//
//  Created by Aleksey on 19.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

// Declared as a class to be able to cache network response using NSCache.
class NetworkResponse {
	// MARK: - Properties
	
	let data: Data
	private(set) var headers: Headers = .empty
	
	
	// MARK: - Init
	
	init(data: Data, httpResponse: HTTPURLResponse) {
		self.data = data

		parseHeaders(httpResponse: httpResponse)
	}
	
	
	// MARK: - Methods
	
	private func parseHeaders(httpResponse: HTTPURLResponse) {
		/* Response from server may contain following "Link" field header:

		<https://api.github.com/user/48685/followers?page=1>; rel="prev", <https://api.github.com/user/48685/followers?page=3>; rel="next", <https://api.github.com/user/48685/followers?page=29>; rel="last", <https://api.github.com/user/48685/followers?page=1>; rel="first"

		We only interested in "next" url, and will parse it using regular expression */

		let pattern = #"(?<=<)(\S+)(?=>;\s*rel="next")"#
		
		headers.nextUrl = httpResponse.getHeader("Link")?
							.firstRegExpMatch(of: pattern)
							.flatMap { URL(string: $0) }
	}

	
	// MARK: - Headers
	
	struct Headers {
		static let empty = Headers()

		// Multiple pages response URLs
		var firstUrl: URL?
		var previousUrl: URL?
		var nextUrl: URL?
		var lastUrl: URL?
	}
}
