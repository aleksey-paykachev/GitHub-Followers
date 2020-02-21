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
		let errorHeader = "Couldn't load data from server. Please try again later."
		let error: String

		switch self {
			
		case .wrongUrl:
			error = "Wrong URL."
		case .requestFailed:
			error = "Request to sever did failed."
		case .wrongResponse:
			error = "Wrong response from server."
		case .notFound:
			error = "Requested data not found on server."
		case .wrongStatusCode(let statusCode):
			error = "Wrong network response status code: \(statusCode)"
		case .emptyData:
			error = "Server response with empty data."
		case .wrongData:
			error = "Server response with wrong data."
		case .parseError(let parserError):
			error = "Parser error: \(parserError.localizedDescription)"
		}

		return errorHeader + "\n\n" + error
	}
}
