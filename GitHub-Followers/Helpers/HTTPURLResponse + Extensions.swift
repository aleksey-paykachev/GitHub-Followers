//
//  HTTPURLResponse + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 19.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension HTTPURLResponse {

	func getHeader(_ headerName: String) -> String? {
		allHeaderFields[headerName] as? String
	}
}
