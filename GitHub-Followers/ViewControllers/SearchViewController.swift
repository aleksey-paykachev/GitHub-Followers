//
//  SearchViewController.swift
//  GitHub-Followers
//
//  Created by Aleksey on 03.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		title = "Search"
		tabBarItem.image = UIImage(systemName: "magnifyingglass")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .green
	}
}
