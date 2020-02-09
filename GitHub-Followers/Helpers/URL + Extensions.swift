//
//  URL + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension URL {
	func appending(_ pathComponents: String...) -> URL {
		pathComponents.reduce(into: self) { url, pathComponent in
			url.appendPathComponent(pathComponent)
		}
	}
}
