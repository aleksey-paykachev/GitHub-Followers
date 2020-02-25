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
	
	func update(with followers: [GithubFollower]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, GithubFollower>()
		snapshot.appendSections([.followers])
		snapshot.appendItems(followers)

		apply(snapshot, animatingDifferences: true)
	}
}
