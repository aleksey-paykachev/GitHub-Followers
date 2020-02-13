//
//  GithubFollower.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

struct GithubFollower: GithubProfile, Hashable {
	let username: String
	let profileImageUrl: URL?
}


// MARK: - Decodable

extension GithubFollower: Decodable {
	
	enum CodingKeys: String, CodingKey {
		case username = "login"
		case profileImageUrl = "avatar_url"
	}
}
