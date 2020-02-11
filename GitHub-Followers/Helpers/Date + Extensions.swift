//
//  Date + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 11.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension Date {
	var relativeToNowText: String {
		RelativeDateTimeFormatter().localizedString(for: self, relativeTo: Date())
	}
}
