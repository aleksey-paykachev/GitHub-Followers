//
//  FollowersListViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 06.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FollowersListViewController: UICollectionViewController {
	// MARK: - Properties
	
	private let user: GithubUser
	private var followers: [GithubFollower] = []
	private var filterFollowersByNameTerm = ""
	
	private let flowLayout = UICollectionViewFlowLayout()
	let loadingOverlayView = GFLoadingOverlayView()
	
	
	// MARK: - Init
	
	init(user: GithubUser) {
		self.user = user
		super.init(collectionViewLayout: flowLayout)
		
		setupSearchController()
		setupCollectionView()
		loadData()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
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
		let cellSideSize: CGFloat = 100
		flowLayout.itemSize = CGSize(width: cellSideSize, height: cellSideSize * 1.3)
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
				self.followers = followers
				self.collectionView.reloadData()
			}
		}
	}
	
	
	// MARK: - View lifecycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationItem.hidesSearchBarWhenScrolling = true
	}
}


// MARK: - UICollectionViewDataSource

extension FollowersListViewController {
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		followers.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell: FollowerCell = collectionView.dequeueReusableCell(for: indexPath)
		cell.follower = followers[indexPath.item]
		
		return cell
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
