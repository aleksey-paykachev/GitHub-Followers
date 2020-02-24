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
	
	func reloadData(animated: Bool = false) {
		let favorites = DataManager.shared.allFavorites
		
		guard favorites != snapshot().itemIdentifiers else { return }

		var newSnapshot = NSDiffableDataSourceSnapshot<Section, GithubUser>()
		newSnapshot.appendSections([.favorites])
		newSnapshot.appendItems(favorites)

		apply(newSnapshot, animatingDifferences: animated)
	}
	
	private func delete(_ user: GithubUser) {
		DataManager.shared.removeUserFromFavorites(user)

		var newSnapshot = snapshot()
		newSnapshot.deleteItems([user])
		
		apply(newSnapshot)
	}
	
	
	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		true
	}
	
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

		if case .delete = editingStyle, let user = itemIdentifier(for: indexPath) {
			delete(user)
		}
	}
	
	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		
		DataManager.shared.moveFavorite(from: sourceIndexPath.item, to: destinationIndexPath.item)
		reloadData()
	}
}
