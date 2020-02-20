//
//  GFLoadingOverlayView.swift
//  GitHub-Followers
//
//  Created by Aleksey on 09.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFLoadingOverlayView: UIView {
	// MARK: - Init
	
	init() {
		super.init(frame: .zero)
		
		setupView()
		setupActivityIndicatorView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupView() {
		backgroundColor = .gfBackground
		isOpaque = false
		alpha = 0
	}
	
	private func setupActivityIndicatorView() {
		let activityIndicatorView = UIActivityIndicatorView(style: .large)
		activityIndicatorView.color = .gfPrimary
		activityIndicatorView.startAnimating()
		
		addSubview(activityIndicatorView)
		activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
	
	
	// MARK: - API
	
	func show(inside superview: UIView) {
		superview.addSubview(self)
		constrainToSuperview()
		
		UIView.animate(withDuration: 0.3) {
			self.alpha = 0.5
		}
	}
	
	func hide() {
		// add little delay before hiding to reduce "flashing" effect

		UIView.animate(withDuration: 0.3, animations: {
			self.alpha = 0
		}, completion: { _ in
			self.removeFromSuperview()
		})
	}
}
