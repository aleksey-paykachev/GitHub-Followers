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
	
	private let userName: String
	private var followers: [GithubUser] = []
	
	private let flowLayout = UICollectionViewFlowLayout()
	private let reuseCellId = "FollowerCell"
	
	
	// MARK: - Init
	
	init(for userName: String) {
		self.userName = userName
		super.init(collectionViewLayout: flowLayout)
		
		setupCollectionView()
		loadData()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupCollectionView() {
		collectionView.backgroundColor = .systemBackground

		collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: reuseCellId)
		let cellSideSize: CGFloat = 100
		flowLayout.itemSize = CGSize(width: cellSideSize, height: cellSideSize * 1.3)
	}
	
	
	// MARK: - Load
	
	private func loadData() {
		NetworkManager.shared.getFollowers(for: userName) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .failure(let error):
				print("Network error:", error)
			case .success(let followers):
				self.followers = followers
				self.collectionView.reloadData()
			}
		}
	}
}


// MARK: - UICollectionViewDataSource

extension FollowersListViewController {
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		followers.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellId, for: indexPath) as! FollowerCell
		cell.follower = followers[indexPath.item]
		
		return cell
	}
}
