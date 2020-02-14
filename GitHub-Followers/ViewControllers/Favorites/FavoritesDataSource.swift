//
//  FavoritesDataSource.swift
//  GitHub-Followers
//
//  Created by Aleksey on 14.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FavoritesDataSource: UITableViewDiffableDataSource<FavoritesDataSource.Section, GithubUser> {
	// MARK: - Sections
	
	enum Section: Hashable {
		case favorites
	}
	
	
	// MARK: - Methods
	
	func reloadData() {
		var newSnapshot = snapshot()
		newSnapshot.deleteAllItems()

		newSnapshot.appendSections([.favorites])
		let favorites = DataManager.shared.allFavorites
		newSnapshot.appendItems(favorites)

		apply(newSnapshot, animatingDifferences: false)
	}
	
	
	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		true
	}
}
