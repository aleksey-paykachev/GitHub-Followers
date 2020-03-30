//
//  UIView + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 10.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIView {

	// MARK: - Relative constraint
	
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
	
	func constrainCenter(to secondView: UIView) {
		translatesAutoresizingMaskIntoConstraints = false
		centerXAnchor.constraint(equalTo: secondView.centerXAnchor).isActive = true
		centerYAnchor.constraint(equalTo: secondView.centerYAnchor).isActive = true
	}
	
	
	// MARK: - Aspect ratio
	
	func constrainWidthToHeight(aspectRatio: CGFloat = 1) {
		widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio).isActive = true
	}
	
	func constrainHeightToWidth(aspectRatio: CGFloat = 1) {
		heightAnchor.constraint(equalTo: widthAnchor, multiplier: aspectRatio).isActive = true
	}
	
	
	// MARK: - Size
	
	func constrainWidth(_ width: CGFloat) {
		widthAnchor.constraint(equalToConstant: width).isActive = true
	}
	
	func constrainHeight(_ height: CGFloat) {
		heightAnchor.constraint(equalToConstant: height).isActive = true
	}
	
	func constrainSize(width: CGFloat, height: CGFloat) {
		constrainWidth(width)
		constrainHeight(height)
	}
}
