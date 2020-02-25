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
	private var followers: [GithubFollower] = []
	private var filterFollowersByNameTerm = ""

	private let navigationItemProfileButton = UIButton(type: .system)
	private let collectionView = GFCollectionView(layout: FollowersLayout(itemsPerRow: 3))
	private lazy var dataSource = FollowersDataSource(collectionView: collectionView)
	
	private var isFiltering: Bool {
		filterFollowersByNameTerm.isNotEmpty
	}
		
	
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

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		
		updateUI()
	}
	
	
	// MARK: - Setup
	
	private func setupNavigationItem() {
		navigationItem.largeTitleDisplayMode = .never
		
		let profileImageHeight: CGFloat = 38
		
		navigationItemProfileButton.setImage(UIImage(asset: .avatarPlaceholder), for: .normal)
		navigationItemProfileButton.addTarget(self, action: #selector(showUserDetailsViewControllerForCurrentUser), for: .touchUpInside)
		
		navigationItemProfileButton.layer.setBorder(color: .gfPrimary, width: 2)
		navigationItemProfileButton.layer.setCornerRadius(profileImageHeight / 2)
		
		navigationItemProfileButton.heightAnchor.constraint(equalToConstant: profileImageHeight).isActive = true
		navigationItemProfileButton.widthAnchor.constraint(equalToConstant: profileImageHeight).isActive = true

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
				let newFollowers = followersNetworkResult.data
				self.followers.append(contentsOf: newFollowers)

				self.dataSource.update(with: self.followers)
				
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
	
	
	// MARK: - Methods
	
	private func updateUI() {
		title = user.username

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
		guard collectionView.nextPageUrl != nil, !collectionView.isLoading, !isFiltering else { return }
		
		let heightToBottom = collectionView.contentSize.height - collectionView.frame.height - collectionView.contentOffset.y + collectionView.adjustedContentInset.bottom
		
		if heightToBottom <= 50 {
			loadFollowers()
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
		guard filterTerm != filterFollowersByNameTerm else { return }

		filterFollowersByNameTerm = filterTerm
		
		if filterTerm.isEmpty {
			dataSource.update(with: followers)
		} else {
			let filteredFollowers = followers.filter { $0.usernameContains(filterTerm) }
			dataSource.update(with: filteredFollowers)
		}
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
		followers.removeAll()
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
