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
		setupActivityIndicatorView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupActivityIndicatorView() {
		let activityIndicatorView = UIActivityIndicatorView(style: .large)
		activityIndicatorView.color = .systemGreen
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
		
		backgroundColor = .clear
		UIView.animate(withDuration: 0.25) {
			self.backgroundColor = UIColor.white.withAlphaComponent(0.75)
		}
	}
	
	func hide() {
		removeFromSuperview()
	}
}
