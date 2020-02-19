//
//  String + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 05.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension String {

	var trimmed: String {
		trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	func regExpFirstMatch(of pattern: String) -> String? {
		guard let matchedRange = range(of: pattern, options: .regularExpression) else {
			return nil
		}

		let match = self[matchedRange]
		return String(match)
	}
}
