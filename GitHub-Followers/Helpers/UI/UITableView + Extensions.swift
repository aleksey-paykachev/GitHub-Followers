//
//  UITableView + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 04.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UITableView {
	
	func register(_ cellClass: UITableViewCell.Type) {
		register(cellClass.self, forCellReuseIdentifier: cellClass.reuseId)
	}
	
	func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as? T else {
			fatalError("Can't dequeue cell of type: \(T.reuseId).")
		}
		
		return cell
	}

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
