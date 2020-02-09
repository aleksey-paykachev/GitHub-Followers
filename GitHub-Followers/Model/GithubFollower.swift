//
//  GithubFollower.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

struct GithubFollower: Decodable {
	
	enum CodingKeys: String, CodingKey {
		case name = "login"
		case profileImageUrl = "avatar_url"
		case profilePageUrl = "html_url"
	}
	
	let name: String
	let profileImageUrl: URL?
	let profilePageUrl: URL?
}
