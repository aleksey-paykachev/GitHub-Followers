//
//  FollowersDataSource.swift
//  GitHub-Followers
//
//  Created by Aleksey on 25.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FollowersDataSource: UICollectionViewDiffableDataSource<FollowersDataSource.Section, GithubFollower> {
	// MARK: - Sections
	
	enum Section {
		case followers
	}
	
	
	// MARK: - Properties

	private var followers: [GithubFollower] = []
	private var filterFollowersByNameTerm = ""
	
	var isFiltering: Bool {
		filterFollowersByNameTerm.isNotEmpty
	}

	typealias CellProvider = (UICollectionView, IndexPath, GithubFollower) -> UICollectionViewCell?

	private let cellProvider: CellProvider = { collectionView, indexPath, follower in
		let cell: FollowerCell = collectionView.dequeueReusableCell(for: indexPath)
		cell.follower = follower
		return cell
	}
	
	
	// MARK: - Init

	init(collectionView: UICollectionView) {
		super.init(collectionView: collectionView, cellProvider: cellProvider)
	}
	
	
	// MARK: - API
	
	func add(_ newFollowers: [GithubFollower]) {
		followers.append(contentsOf: newFollowers)
		reload(with: followers)
	}
	
	func removeAll() {
		followers.removeAll()
		reload(with: [])
	}
	
	func filter(with filterTerm: String) {
		guard filterTerm != filterFollowersByNameTerm else { return }

		filterFollowersByNameTerm = filterTerm
		
		if filterTerm.isEmpty {
			reload(with: followers)
		} else {
			let filteredFollowers = followers.filter { $0.usernameContains(filterTerm) }
			reload(with: filteredFollowers)
		}
	}
	
	
	// MARK: - Private methods
	
	private func reload(with followers: [GithubFollower]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, GithubFollower>()
		snapshot.appendSections([.followers])
		snapshot.appendItems(followers)

		apply(snapshot, animatingDifferences: true)
	}
}
