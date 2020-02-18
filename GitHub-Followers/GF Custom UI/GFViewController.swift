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
