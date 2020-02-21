//
//  NetworkError.swift
//  GitHub-Followers
//
//  Created by Aleksey on 21.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
	case wrongUrl
	case requestFailed(Error)
	case wrongResponse
	case notFound
	case wrongStatusCode(Int)
	case emptyData
	case wrongData
	case parseError(Error)
	
	var errorDescription: String? {
		switch self {
			
		case .wrongUrl:
			return "Wrong URL."
		case .requestFailed:
			return "Request to sever did failed."
		case .wrongResponse:
			return "Wrong response from server."
		case .notFound:
			return "Requested data not found on server."
		case .wrongStatusCode(let statusCode):
			return "Wrong network response status code: \(statusCode)"
		case .emptyData:
			return "Server response with empty data."
		case .wrongData:
			return "Server response with wrong data."
		case .parseError(let parserError):
			return "Parser error: \(parserError.localizedDescription)"
		}
	}
}
