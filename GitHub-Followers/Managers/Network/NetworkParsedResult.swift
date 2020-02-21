//
//  NetworkParsedResult.swift
//  GitHub-Followers
//
//  Created by Aleksey on 21.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

struct NetworkParsedResult<T: Decodable> {
	let data: T
	let headers: NetworkResponse.Headers
}
