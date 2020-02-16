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
	
	
	// MARK: - API
	
	func reloadData() {
		let favorites = DataManager.shared.allFavorites

		var newSnapshot = snapshot()
		newSnapshot.deleteAllItems()

		newSnapshot.appendSections([.favorites])
		newSnapshot.appendItems(favorites)

		apply(newSnapshot, animatingDifferences: false)
	}
	
	func delete(_ user: GithubUser) {
		DataManager.shared.removeUserFromFavorites(user)

		var newSnapshot = snapshot()
		newSnapshot.deleteItems([user])
		
		apply(newSnapshot)
	}
	
	
	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

		switch editingStyle {
		case .delete:
			guard let user = itemIdentifier(for: indexPath) else { return }
			delete(user)

		default:
			break
		}
	}
}
