//
//  FollowersViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FollowersViewController: GFViewController {
	// MARK: - Sections
	
	enum Section {
		case followers
	}
	
	
	// MARK: - Properties
	
	private var user: GithubUser
	private var followers: [GithubFollower] = []
	private var filterFollowersByNameTerm = ""

	private let navigationItemProfileButton = UIButton(type: .system)
	private let collectionView = GFCollectionView(layout: FollowersLayout(itemsPerRow: 3))
	private lazy var dataSource = createDataSource()
	
	typealias FollowersDataSource = UICollectionViewDiffableDataSource<Section, GithubFollower>
	
	
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
	
	
	// MARK: - Create
	
	private func createDataSource() -> FollowersDataSource {
		FollowersDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in

			let cell: FollowerCell = collectionView.dequeueReusableCell(for: indexPath)
			cell.follower = follower
			return cell
		})
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

				self.updateCollectionViewData()
				
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
	
	private func updateCollectionViewData() {
		var snapshot = NSDiffableDataSourceSnapshot<Section, GithubFollower>()
		snapshot.appendSections([.followers])
		snapshot.appendItems(followers)
		dataSource.apply(snapshot, animatingDifferences: false)
	}
	
	@objc private func showUserDetailsViewControllerForCurrentUser() {
		showUserDetailsViewController(for: user)
	}
	
	private func showUserDetailsViewController(for profile: GithubProfile) {
		let userDetailsViewController = UserDetailsViewController(username: profile.username)
		userDetailsViewController.delegate = self
		present(userDetailsViewController, animated: true)
	}
	
	private func loadMoreDataIfScrolledToBottom() {
		guard collectionView.nextPageUrl != nil, !collectionView.isLoading else { return }
		
		let heightToBottom = collectionView.contentSize.height - collectionView.frame.height - collectionView.contentOffset.y + collectionView.adjustedContentInset.bottom
		
		if heightToBottom <= 50 {
			loadFollowers()
		}
	}
}


// MARK: - UICollectionViewDelegate

extension FollowersViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let follower = followers[indexPath.item]
		showUserDetailsViewController(for: follower)
	}
}


// MARK: - UISearchResultsUpdating

extension FollowersViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let filterTerm = searchController.searchBar.text?.trimmed else { return }

		if filterTerm != filterFollowersByNameTerm {
			print("Filter followers with:", filterTerm)
			filterFollowersByNameTerm = filterTerm
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
		
		// update
		self.user = user
		updateUI()
		
		collectionView.scrollToTop()
	}
}
