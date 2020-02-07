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
	
	private var followers: [GithubUser] = []
	
	private let flowLayout = UICollectionViewFlowLayout()
	private let reuseCellId = "FollowerCell"
	
	
	// MARK: - Init
	
	init(followers: [GithubUser]) {
		super.init(collectionViewLayout: flowLayout)
		
		self.followers = followers
		setupCollectionView()
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
