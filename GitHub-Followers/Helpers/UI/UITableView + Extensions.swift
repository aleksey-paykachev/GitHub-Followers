//
//  UITableView + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 04.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UITableView {

	func setAsBackgroundView(_ view: UIView?) {
		guard let view = view else {
			backgroundView = nil
			return
		}
		
		backgroundView = UIView()
		backgroundView?.addSubview(view)
		view.constrainToSuperview()
	}
}
