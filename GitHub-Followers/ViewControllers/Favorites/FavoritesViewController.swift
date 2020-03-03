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
		
		let emptyStateView = UIView()
		
		let emptyStateLabel = GFLabel(text: "No favorite users. Set user as favorite on user info page by pressing ⭐️ icon.", fontSize: 22, color: .gfTextSecondary, alignment: .center, allowMultipleLines: true)
		let emptyStateImageView = GFImageView(asset: .emptyState)
		
		emptyStateView.addSubview(emptyStateLabel)
		emptyStateView.addSubview(emptyStateImageView)
		emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
		emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
			emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -80),
			emptyStateLabel.widthAnchor.constraint(equalTo: emptyStateView.widthAnchor, multiplier: 0.8),
			
			emptyStateImageView.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor),
			emptyStateImageView.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),
			emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -50)
		])
		
		tableView.backgroundView = UIView()
		tableView.backgroundView?.addSubview(emptyStateView)
		emptyStateView.constrainToSuperview()
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
