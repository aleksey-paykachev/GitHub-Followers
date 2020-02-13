//
//  FollowersListViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FollowersListViewController: UICollectionViewController {
	// MARK: - Sections
	
	enum Section {
		case followers
	}
	
	
	// MARK: - Properties
	
	private let user: GithubUser
	private var followers: [GithubFollower] = []
	private var filterFollowersByNameTerm = ""
	
	private var dataSource: UICollectionViewDiffableDataSource<Section, GithubFollower>!
	private let loadingOverlayView = GFLoadingOverlayView()
	
	
	// MARK: - Init
	
	init(user: GithubUser) {
		self.user = user
		super.init(collectionViewLayout: UICollectionViewLayout())
		
		setupNavigationItemProfileImage()
		setupSearchController()
		setupCollectionView()
		setupLayout()
		setupDataSource()
		loadData()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupNavigationItemProfileImage() {
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
		// show search bar on first appearance, but set it to "hideWhenScrolling" in viewDidAppear
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	private func setupCollectionView() {
		title = user.username
		collectionView.backgroundColor = .systemBackground
		collectionView.alwaysBounceVertical = true

		collectionView.register(FollowerCell.self)
	}
	
	private func setupLayout() {
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
		let layout = UICollectionViewCompositionalLayout(section: section)
		collectionView.collectionViewLayout = layout
	}
	
	private func setupDataSource() {
		dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in

			let cell: FollowerCell = collectionView.dequeueReusableCell(for: indexPath)
			cell.follower = follower
			return cell
		})
		
		// initial snapshot
		var snapshot = dataSource.snapshot()
		snapshot.appendSections([.followers])
		dataSource.apply(snapshot)
	}
	
	
	// MARK: - Load data
	
	private func loadData() {
		loadingOverlayView.show(inside: view)
		
		DataManager.shared.getFollowers(for: user.username) { [weak self] result in
			guard let self = self else { return }
			self.loadingOverlayView.hide()
			
			switch result {
			case .failure(let error):
				print("Network error:", error)
				self.navigationController?.popViewController(animated: true)

			case .success(let followers):
				self.followers.append(contentsOf: followers)
				self.appendCollectionView(with: followers)
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
	
	
	// MARK: - View lifecycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationItem.hidesSearchBarWhenScrolling = true
	}
}


// MARK: - UICollectionViewDelegate

extension FollowersListViewController {
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let follower = followers[indexPath.item]
		showUserDetailsViewController(for: follower)
	}
}


// MARK: - UISearchResultsUpdating

extension FollowersListViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let filterTerm = searchController.searchBar.text?.trimmed else { return }

		if filterTerm != filterFollowersByNameTerm {
			print("Filter followers with:", filterTerm)
			filterFollowersByNameTerm = filterTerm
		}
	}
}
