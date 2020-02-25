//
//  GithubProfile.swift
//  GitHub-Followers
//
//  Created by Aleksey on 10.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

protocol GithubProfile {
	var username: String { get }
	var profileImageUrl: URL? { get }
}


extension GithubProfile {
	func usernameContains(_ term: String) -> Bool {
		username.localizedCaseInsensitiveContains(term)
	}
}
