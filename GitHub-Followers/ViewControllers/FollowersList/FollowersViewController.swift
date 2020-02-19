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
	
	private let user: GithubUser
	private var followers: [GithubFollower] = []
	private var nextUrl: URL?
	private var filterFollowersByNameTerm = ""
	
	private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
	private lazy var dataSource = createDataSource()
	
	
	// MARK: - Init
	
	init(for user: GithubUser) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
		
		setupNavigationItem()
		setupSearchController()
		setupCollectionView()
		loadData()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Create
	
	private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
		// item
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3 * 1.3))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 6, trailing: 6)
		
		// group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		// section
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10)
		
		// layout
		return UICollectionViewCompositionalLayout(section: section)
	}
	
	private func createDataSource() -> UICollectionViewDiffableDataSource<Section, GithubFollower> {
		let dataSource = UICollectionViewDiffableDataSource<Section, GithubFollower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in

			let cell: FollowerCell = collectionView.dequeueReusableCell(for: indexPath)
			cell.follower = follower
			return cell
		})
		
		// initial snapshot
		var snapshot = dataSource.snapshot()
		snapshot.appendSections([.followers])
		dataSource.apply(snapshot)
		
		return dataSource
	}
	
	
	// MARK: - Setup
	
	private func setupNavigationItem() {
		navigationItem.largeTitleDisplayMode = .never
		
		let profileImageHeight: CGFloat = 38

		let profileButton = UIButton(type: .system)
		profileButton.setImage(UIImage(asset: .avatarPlaceholder), for: .normal)
		profileButton.addTarget(self, action: #selector(showUserDetailsViewControllerForCurrentUser), for: .touchUpInside)
		
		profileButton.layer.setBorder(color: .systemGreen, width: 2)
		profileButton.layer.setCornerRadius(profileImageHeight / 2)
		
		profileButton.heightAnchor.constraint(equalToConstant: profileImageHeight).isActive = true
		profileButton.widthAnchor.constraint(equalToConstant: profileImageHeight).isActive = true

		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
		
		// download and set profile image for current user
		DataManager.shared.getProfileImage(for: user) { result in
			if case .success(let image) = result {
				let profileImage = image.withRenderingMode(.alwaysOriginal)
				profileButton.setImage(profileImage, for: .normal)
			}
		}
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
		
		title = user.username
		collectionView.backgroundColor = .systemBackground
		collectionView.alwaysBounceVertical = true

		collectionView.delegate = self
		collectionView.register(FollowerCell.self)
	}
	
	
	// MARK: - Load data
	
	private func loadData() {
		isLoading = true
		
		DataManager.shared.getFollowers(for: user.username, url: nextUrl) { [weak self] result in
			guard let self = self else { return }
			self.isLoading = false
			
			switch result {
			case .failure(let error):
				print("Network error:", error)

			case .success(let followersNetworkResult):
				let newFollowers = followersNetworkResult.data

				self.followers.append(contentsOf: newFollowers)
				self.appendCollectionView(with: newFollowers)
				
				self.nextUrl = followersNetworkResult.headers.nextUrl
			}
		}
	}
	
	
	// MARK: - Methods
	
	private func appendCollectionView(with followers: [GithubFollower]) {
		var snapshot = dataSource.snapshot()
		snapshot.appendItems(followers)
		dataSource.apply(snapshot, animatingDifferences: false)
	}
	
	@objc private func showUserDetailsViewControllerForCurrentUser() {
		showUserDetailsViewController(for: user)
	}
	
	private func showUserDetailsViewController(for profile: GithubProfile) {
		let userDetailsViewController = UserDetailsViewController(username: profile.username)
		present(userDetailsViewController, animated: true)
	}
	
	private func loadMoreDataIfScrolledToBottom() {
		guard nextUrl != nil, !isLoading else { return }
		
		let heightToBottom = collectionView.contentSize.height - collectionView.frame.height - collectionView.contentOffset.y + collectionView.adjustedContentInset.bottom
		
		if heightToBottom <= 50 {
			loadData()
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
