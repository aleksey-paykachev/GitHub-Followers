//
//  GithubUser.swift
//  GitHub-Followers
//
//  Created by Aleksey on 10.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

struct GithubUser: GithubProfile {
	let username: String
	let profileImageUrl: URL?
	let profilePageUrl: URL?
}


// MARK: - Decodable

extension GithubUser: Decodable {

	enum CodingKeys: String, CodingKey {
		case username = "login"
		case profileImageUrl = "avatar_url"
		case profilePageUrl = "html_url"
	}
}
