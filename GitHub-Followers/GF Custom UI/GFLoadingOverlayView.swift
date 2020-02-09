//
//  GFLoadingOverlayView.swift
//  GitHub-Followers
//
//  Created by Aleksey on 09.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFLoadingOverlayView: UIView {
	// MARK: - Properties
	
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)

	
	// MARK: - Init
	
	init() {
		super.init(frame: .zero)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup
	
	private func setupView() {
		backgroundColor = UIColor.black.withAlphaComponent(0.2)
		activityIndicatorView.color = .white
		
		addSubview(activityIndicatorView)
		activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
	
	
	// MARK: - API
	
	func show(inside superview: UIView) {
		guard !activityIndicatorView.isAnimating else { return }
		
		activityIndicatorView.startAnimating()
		
		superview.addSubview(self)
		constrainToSuperview()
	}
	
	func hide() {
		activityIndicatorView.stopAnimating()
		removeFromSuperview()
	}
}
