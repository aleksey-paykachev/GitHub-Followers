//
//  FavoritesViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 03.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {
	// MARK: - Properties
	
	private lazy var dataSource = createDataSource()

	
	// MARK: - Init
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		title = "Favorites"

		setupTabBar()
		setupNavigationBar()
		setupTableView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Create
	
	private func createDataSource() -> FavoritesDataSource {
		FavoritesDataSource(tableView: tableView, cellProvider: { tableView, indexPath, user -> UITableViewCell? in
			
			let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId, for: indexPath) as? FavoriteCell
			cell?.set(user: user)
			return cell
		})
	}
	
	
	// MARK: - Setup
	
	private func setupTabBar() {
		tabBarItem.image = UIImage(sfSymbol: .starFill)
	}
	
	private func setupNavigationBar() {
		navigationItem.rightBarButtonItem = editButtonItem
	}
	
	private func setupTableView() {
		tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
		tableView.separatorStyle = .none
	}
	
	
	// MARK: - View lifecycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		navigationController?.navigationBar.prefersLargeTitles = true
		dataSource.reloadData()
	}
}


// MARK: - UITableViewDelegate

extension FavoritesViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let user = dataSource.itemIdentifier(for: indexPath) else { return }
		
		let followersVC = FollowersViewController(for: user)
		navigationController?.pushViewController(followersVC, animated: true)
	}
}
