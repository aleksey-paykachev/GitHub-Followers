//
//  GFImageView.swift
//  GitHub-Followers
//
//  Created by Aleksey on 05.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFImageView: UIImageView {
	// MARK: - Init
	
	init(asset: UIImage.GFImageAsset) {
		super.init(image: UIImage(asset: asset))
		
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupView() {
		contentMode = .scaleAspectFit
	}
}
