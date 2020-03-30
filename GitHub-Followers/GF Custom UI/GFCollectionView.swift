//
//  GFCollectionView.swift
//  GitHub-Followers
//
//  Created by Aleksey on 22.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFCollectionView: UICollectionView {
	// MARK: - Properties
	
	private let loadingIndicatorView = UIActivityIndicatorView(style: .large)

	var nextPageUrl: URL? {
		didSet {
			guard nextPageUrl != oldValue else { return }
			
			contentInset.bottom = nextPageUrl != nil ? 70 : 0
		}
	}

	var isLoading = false {
		didSet {
			guard isLoading != oldValue else { return }
			
			isLoading ? showLoadingIndicator() : hideLoadingIndicator()
		}
	}
	
	var hasNextPage: Bool {
		nextPageUrl != nil
	}
	
	var isReadyToLoadMoreData: Bool {
		hasNextPage && !isLoading
	}
	
	var isFirstSectionEmpty: Bool {
		numberOfItems(inSection: 0) == 0
	}

	
	// MARK: - Init
	
	init(layout: UICollectionViewLayout) {
		super.init(frame: .zero, collectionViewLayout: layout)
		
		setupLoadingIndicator()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupLoadingIndicator() {
		loadingIndicatorView.color = .gfPrimary
		loadingIndicatorView.startAnimating()
	}
	
	
	// MARK: - API
	
	func scrollToTop() {
		contentOffset.y = -adjustedContentInset.top
	}
	
	
	// MARK: - Loading indicator
		
	private func showLoadingIndicator() {
		addSubview(loadingIndicatorView)
		isFirstSectionEmpty ? showLoadingIndicatorAtCenter() : showLoadingIndicatorAtBottom()
	}
	
	private func showLoadingIndicatorAtCenter() {
		loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false

		loadingIndicatorView.centerXAnchor.constraint(equalTo: frameLayoutGuide.centerXAnchor).isActive = true
		loadingIndicatorView.centerYAnchor.constraint(equalTo: frameLayoutGuide.centerYAnchor).isActive = true
	}
	
	private func showLoadingIndicatorAtBottom() {
		loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = true

		let centerX = bounds.width / 2 - loadingIndicatorView.bounds.width / 2
		let bottomY = contentSize.height
		loadingIndicatorView.frame.origin = CGPoint(x: centerX, y: bottomY)
	}
	
	private func hideLoadingIndicator() {
		loadingIndicatorView.removeFromSuperview()
	}
}
