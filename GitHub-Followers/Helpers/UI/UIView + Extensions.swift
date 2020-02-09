//
//  UIView + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 10.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIView {
	
	func constrainToSuperview(padding: CGFloat = 0, respectSafeArea: Bool = false) {
		guard let superview = superview else { return }
		
		constrain(to: superview, padding: padding, respectSafeArea: respectSafeArea)
	}
	
	func constrain(to secondView: UIView, padding: CGFloat = 0, respectSafeArea: Bool = false) {
		translatesAutoresizingMaskIntoConstraints = false

		if respectSafeArea {
			NSLayoutConstraint.activate([
				leadingAnchor.constraint(equalTo: secondView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
				topAnchor.constraint(equalTo: secondView.safeAreaLayoutGuide.topAnchor, constant: padding),
				trailingAnchor.constraint(equalTo: secondView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
				bottomAnchor.constraint(equalTo: secondView.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
			])

		} else {
			NSLayoutConstraint.activate([
				leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: padding),
				topAnchor.constraint(equalTo: secondView.topAnchor, constant: padding),
				trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -padding),
				bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: -padding)
			])
		}
	}
}
