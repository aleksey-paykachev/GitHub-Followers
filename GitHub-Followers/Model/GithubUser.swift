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
	let fullName: String?
	let profileImageUrl: URL?
	let profilePageUrl: URL?
	let location: String?
	let description: String?
	let repositoriesCount: Int
	let gistsCount: Int
	let followingCount: Int
	let followersCount: Int
	let accountRegistrationDate: Date
}


// MARK: - Codable

extension GithubUser: Codable {

	enum CodingKeys: String, CodingKey {
		case username = "login"
		case fullName = "name"
		case profileImageUrl = "avatar_url"
		case profilePageUrl = "html_url"
		case location = "location"
		case description = "bio"
		case repositoriesCount = "public_repos"
		case gistsCount = "public_gists"
		case followingCount = "following"
		case followersCount = "followers"
		case accountRegistrationDate = "created_at"
	}
}


// MARK: - Hashable

extension GithubUser: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(username)
	}
}


// MARK: - Equatable

extension GithubUser: Equatable {
	static func == (lhs: GithubUser, rhs: GithubUser) -> Bool {
		lhs.username == rhs.username
	}
}


// MARK: - Comparable

extension GithubUser: Comparable {
	static func < (lhs: GithubUser, rhs: GithubUser) -> Bool {
		lhs.username.lowercased() < rhs.username.lowercased()
	}
}
