//
//  FollowersLayout.swift
//  GitHub-Followers
//
//  Created by Aleksey on 20.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FollowersLayout: UICollectionViewCompositionalLayout {
	// MARK: - Init
	
	init(itemsPerRow: Int) {
		let section = Self.createSection(itemsPerRow: itemsPerRow)
		super.init(section: section)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Create
	
	static private func createSection(itemsPerRow: Int) -> NSCollectionLayoutSection {
		
		// item
		let itemFractionalWidth = 1 / CGFloat(itemsPerRow)
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalWidth), heightDimension: .fractionalWidth(itemFractionalWidth * 1.3))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 6, trailing: 6)
		
		// group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		// section
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10)
		
		return section
	}
}
