//
//  GFViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 15.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFViewController: UIViewController {
	// MARK: - Properties

	private let loadingOverlayView = GFLoadingOverlayView()
	
	
	// MARK: - API

	func showError(_ message: String, hideAfter intervalBeforeHide: TimeInterval = 4) {
		// properties
		let topConstraintHidden: CGFloat = -100
		let topConstraintShown: CGFloat = 10
		let widthConstraint: CGFloat = 300
		let animationDuration: TimeInterval = 0.3
		
		let errorMessageView = GFErrorMessageView(message: message)
		view.addSubview(errorMessageView)

		// constraints
		errorMessageView.translatesAutoresizingMaskIntoConstraints = false

		let errorMessageViewTopConstraint = errorMessageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintHidden)

		NSLayoutConstraint.activate([
			errorMessageView.widthAnchor.constraint(equalToConstant: widthConstraint),
			errorMessageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			errorMessageViewTopConstraint
		])
		
		// show-wait-hide animation:
		// prepare
		errorMessageView.alpha = 0
		view.layoutIfNeeded()
		
		// show
		UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
			errorMessageViewTopConstraint.constant = topConstraintShown
			errorMessageView.alpha = 1
			self.view.layoutIfNeeded()
		}, completion: { _ in
			
			// hide
			UIView.animate(withDuration: animationDuration, delay: intervalBeforeHide, options: .curveEaseIn, animations: {
				errorMessageViewTopConstraint.constant = topConstraintHidden
				errorMessageView.alpha = 0
				self.view.layoutIfNeeded()
			}, completion: { _ in
				
				// remove
				errorMessageView.removeFromSuperview()
			})
		})
	}
	
	func showLoadingOverlay() {
		loadingOverlayView.show(inside: view)
	}
	
	func hideLoadingOverlay() {
		// add little delay before hiding loading overlay to reduce its "flashing" effect

		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
			self.loadingOverlayView.hide()
		}
	}
}
