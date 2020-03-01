//
//  UITableViewCell + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 01.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UITableViewCell {
	
	static var reuseId: String {
		String(describing: self)
	}
}
