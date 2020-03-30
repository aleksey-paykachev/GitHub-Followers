//
//  UIView + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 10.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIView {

	// MARK: - Relative constraints
	
	func constrain(to secondView: UIView, padding: CGFloat = 0) {
		translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: padding),
			topAnchor.constraint(equalTo: secondView.topAnchor, constant: padding),
			trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -padding),
			bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: -padding)
		])
	}
	
	func constrainToSuperview(padding: CGFloat = 0) {
		guard let superview = superview else { return }
		
		constrain(to: superview, padding: padding)
	}
	
	func constrainCenter(to secondView: UIView) {
		translatesAutoresizingMaskIntoConstraints = false
		centerXAnchor.constraint(equalTo: secondView.centerXAnchor).isActive = true
		centerYAnchor.constraint(equalTo: secondView.centerYAnchor).isActive = true
	}
	
	
	// MARK: - Aspect ratio constraints
	
	func constrainWidthToHeight(aspectRatio: CGFloat = 1) {
		widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio).isActive = true
	}
	
	func constrainHeightToWidth(aspectRatio: CGFloat = 1) {
		heightAnchor.constraint(equalTo: widthAnchor, multiplier: aspectRatio).isActive = true
	}
	
	
	// MARK: - Size constraints
	
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
