//
//  FollowersViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FollowersViewController: GFViewController {
	// MARK: - Properties
	
	private var user: GithubUser

	private let navigationItemProfileButton = GFCircleButton(radius: 18, image: UIImage(asset: .avatarPlaceholder))
	private let collectionView = GFCollectionView(layout: FollowersLayout(itemsPerRow: 3))
	private lazy var dataSource = FollowersDataSource(collectionView: collectionView)
		
	
	// MARK: - Init
	
	init(for user: GithubUser) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
		
		setupNavigationItem()
		setupSearchController()
		setupCollectionView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		
		updateUI()
	}
	
	
	// MARK: - Setup
	
	private func setupNavigationItem() {
		navigationItem.largeTitleDisplayMode = .never
		
		navigationItemProfileButton.addTarget(self, action: #selector(showUserDetailsViewControllerForCurrentUser), for: .touchUpInside)

		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationItemProfileButton)
	}
	
	private func setupSearchController() {
		let searchController = UISearchController()
		searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.obscuresBackgroundDuringPresentation = false
		
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	private func setupCollectionView() {
		view.addSubview(collectionView)
		collectionView.constrainToSuperview()
		
		collectionView.backgroundColor = .gfBackground
		collectionView.alwaysBounceVertical = true

		collectionView.delegate = self
		collectionView.register(FollowerCell.self)
	}
	
	
	// MARK: - Load data
	
	private func loadFollowers() {
		collectionView.isLoading = true
		
		DataManager.shared.getFollowers(for: user.username, url: collectionView.nextPageUrl) { [weak self] result in

			guard let self = self else { return }
			self.collectionView.isLoading = false
			
			switch result {
			case .failure(let error):
				self.showError(error.localizedDescription)

			case .success(let followersNetworkResult):
				self.dataSource.add(followers: followersNetworkResult.data)
				self.checkForEmptyState()

				self.collectionView.nextPageUrl = followersNetworkResult.headers.nextUrl
			}
		}
	}
	
	private func loadNavigationItemProfileImage() {
		DataManager.shared.getProfileImage(for: user) { result in
			if case .success(let image) = result {
				let profileImage = image.withRenderingMode(.alwaysOriginal)
				self.navigationItemProfileButton.setImage(profileImage, for: .normal)
			}
		}
	}
	
	
	// MARK: - Private methods
	
	private func updateUI() {
		title = "\(user.username)'s followers"

		loadFollowers()
		loadNavigationItemProfileImage()
	}
	
	@objc private func showUserDetailsViewControllerForCurrentUser() {
		showUserDetailsViewController(for: user)
	}
	
	private func showUserDetailsViewController(for profile: GithubProfile) {
		let userDetailsViewController = UserDetailsViewController(username: profile.username)
		userDetailsViewController.delegate = self
		present(userDetailsViewController, animated: true)
	}
	
	// There is no option in GitHub API to provide search term for followers request, so disable loading while filtering is active.
	private func loadMoreDataIfScrolledToBottom() {
		guard collectionView.isReadyToLoadMoreData, !dataSource.isFiltering else { return }
		
		let heightToBottom = collectionView.contentSize.height - collectionView.frame.height - collectionView.contentOffset.y + collectionView.adjustedContentInset.bottom
		
		if heightToBottom <= 50 {
			loadFollowers()
		}
	}
	
	private func checkForEmptyState() {
		if dataSource.isEmpty {
			let emptyStateView = GFEmptyStateView(text: "Current user doesn't have any followers.")
			collectionView.setAsBackgroundView(emptyStateView)
		}
	}
}


// MARK: - UICollectionViewDelegate

extension FollowersViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let follower = dataSource.itemIdentifier(for: indexPath) else { return }

		showUserDetailsViewController(for: follower)
	}
}


// MARK: - UISearchResultsUpdating

extension FollowersViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let filterTerm = searchController.searchBar.text?.trimmed else { return }

		dataSource.filter(with: filterTerm)
	}
}


// MARK: - UIScrollViewDelegate

extension FollowersViewController {
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		loadMoreDataIfScrolledToBottom()
	}

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		loadMoreDataIfScrolledToBottom()
	}
}


// MARK: - UserDetailsViewControllerDelegate

extension FollowersViewController: UserDetailsViewControllerDelegate {

	func viewFollowersButtonDidPressed(for user: GithubUser) {
		guard user != self.user else { return }

		// reset
		dataSource.removeAll()
		collectionView.nextPageUrl = nil
		navigationItem.searchController?.searchBar.text = nil
		
		// update
		self.user = user
		updateUI()
		
		collectionView.scrollToTop()
	}
	
	func didFailToLoadData(with error: NetworkError) {
		showError(error.localizedDescription)
	}
}
