//
//  UICollectionViewCell + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 08.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
	
	static var reuseId: String {
		String(describing: self)
	}
}
