//
//  GFLabel.swift
//  GitHub-Followers
//
//  Created by Aleksey on 10.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFLabel: UILabel {
	// MARK: - Init
	
	init(text: String,
		 font: UIFont? = nil,
		 color: UIColor? = nil,
		 alignment: NSTextAlignment = .left,
		 allowMultipleLines: Bool = false) {

		super.init(frame: .zero)
		
		// setup
		self.text = text
		self.font = font
		self.textColor = color
		self.textAlignment = alignment
		self.numberOfLines = allowMultipleLines ? 0 : 1
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
