//
//  GithubUser.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

struct GithubUser: Decodable {
	
	enum CodingKeys: String, CodingKey {
		case login = "login"
		case avatarUrl = "avatar_url"
		case profileUrl = "html_url"
	}
	
	let login: String
	let avatarUrl: URL?
	let profileUrl: URL?
}
