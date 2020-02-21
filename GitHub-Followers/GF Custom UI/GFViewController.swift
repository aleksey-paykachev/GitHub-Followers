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
	
	var isLoading = false {
		didSet {
			if isLoading != oldValue {
				isLoading ? showLoadingIndicator() : hideLoadingIndicator()
			}
		}
	}
	
	
	// MARK: - API

	func showError(_ message: String, hideAfter interval: TimeInterval = 4) {
		let errorMessageView = GFErrorMessageView(message: message)
		view.addSubview(errorMessageView)

		// constraints
		errorMessageView.translatesAutoresizingMaskIntoConstraints = false

		let errorMessageViewTopConstraint = errorMessageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -100)

		NSLayoutConstraint.activate([
			errorMessageView.widthAnchor.constraint(equalToConstant: 300),
			errorMessageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			errorMessageViewTopConstraint
		])
		
		// prepare
		errorMessageView.alpha = 0
		view.layoutIfNeeded()
		
		// show
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
			errorMessageViewTopConstraint.constant = 10
			errorMessageView.alpha = 1
			self.view.layoutIfNeeded()
		}, completion: { _ in
			
			// hide
			UIView.animate(withDuration: 0.3, delay: interval, options: .curveEaseIn, animations: {
				errorMessageViewTopConstraint.constant = -100
				errorMessageView.alpha = 0
				self.view.layoutIfNeeded()
			}, completion: { _ in
				
				// remove
				errorMessageView.removeFromSuperview()
			})
		})
	}
	
	
	// MARK: - Methods
	
	private func showLoadingIndicator() {
		loadingOverlayView.show(inside: view)
	}
	
	private func hideLoadingIndicator() {
		// add little delay before hiding loading indicator to reduce its "flashing" on screen

		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
			self.loadingOverlayView.hide()
		}
	}
}
