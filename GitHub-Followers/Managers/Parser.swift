//
//  Parser.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

class Parser {
	// MARK: - API

	static func parse<T: Decodable>(_ data: Data?) throws -> T {
		guard let data = data else {
			throw ParseError.noDataToParse
		}
		
		do {
			return try JSONDecoder().decode(T.self, from: data)
		} catch {
			throw ParseError.couldNotParse(error)
		}
	}
	
	
	// MARK: - Errors
	
	enum ParseError: Error {
		case noDataToParse
		case couldNotParse(Error)
	}
}
