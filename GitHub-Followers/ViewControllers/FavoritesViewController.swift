//
//  FavoritesViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 03.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {
	// MARK: - Sections
	
	private enum Section {
		case favorites
	}

	
	// MARK: - Properties
	
	private var dataSource: UITableViewDiffableDataSource<Section, GithubUser>!

	
	// MARK: - Init
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		title = "Favorites"
		tabBarItem.image = UIImage(systemName: "star.fill")
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
		setupDataSource()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupDataSource() {
		dataSource = UITableViewDiffableDataSource<Section, GithubUser>(tableView: tableView, cellProvider: { tableView, indexPath, user -> UITableViewCell? in
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
			cell.textLabel?.text = user.username
			return cell
		})
	}

	
	// MARK: - Methods
	
	private func reloadData() {
		var snapshot = dataSource.snapshot()
		snapshot.deleteAllItems()

		snapshot.appendSections([.favorites])
		let favorites = DataManager.shared.allFavorites
		snapshot.appendItems(favorites)

		dataSource.apply(snapshot, animatingDifferences: false)
	}

	
	// MARK: - View lifecycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		reloadData()
	}
}
