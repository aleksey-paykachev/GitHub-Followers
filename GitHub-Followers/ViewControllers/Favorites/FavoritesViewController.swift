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
		setupToolbar()
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
	
	private func setupToolbar() {
		toolbarItems = [
			UIBarButtonItem(customView: GFLabel(text: "Sort by name: ")),
			UIBarButtonItem(image: UIImage(sfSymbol: .chevronDown), style: .plain, target: self, action: #selector(sortAscending)),
			UIBarButtonItem(image: UIImage(sfSymbol: .chevronUp), style: .plain, target: self, action: #selector(sortDescending))
		]
	}
	
	private func setupTableView() {
		tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
		tableView.separatorStyle = .none
		tableView.rowHeight = 100
	}
	
	
	// MARK: - Methods
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		navigationController?.setToolbarHidden(!editing, animated: true)
	}
	
	@objc private func sortAscending() {
		DataManager.shared.sortFavorites(by: <)
		dataSource.reloadData(animated: true)
	}
	
	@objc private func sortDescending() {
		DataManager.shared.sortFavorites(by: >)
		dataSource.reloadData(animated: true)
	}
	
	private func setState(isEmpty: Bool) {
		navigationItem.rightBarButtonItem?.isEnabled = !isEmpty
		
		if isEmpty {
			let emptyStateView = GFEmptyStateView(text: "No favorite users. Set user as favorite on user info page by pressing ⭐️ icon.")
			tableView.backgroundView = UIView()
			tableView.backgroundView?.addSubview(emptyStateView)
			emptyStateView.constrainToSuperview()
		} else {
			tableView.backgroundView = nil
		}
	}
	
	
	// MARK: - View lifecycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		navigationController?.navigationBar.prefersLargeTitles = true
		dataSource.reloadData()
		
		setState(isEmpty: dataSource.snapshot().numberOfItems == 0)
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
