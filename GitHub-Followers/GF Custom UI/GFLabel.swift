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
	
	init(text: String? = nil,
		 image: UIImage? = nil,
		 fontSize: CGFloat = 17,
		 fontWeight: UIFont.Weight = .regular,
		 color: UIColor? = .gfText,
		 alignment: NSTextAlignment = .left,
		 allowMultipleLines: Bool = false) {

		super.init(frame: .zero)
		
		// setup
		self.text = text
		self.font = .systemFont(ofSize: fontSize, weight: fontWeight)
		self.textColor = color
		self.textAlignment = alignment
		self.numberOfLines = allowMultipleLines ? 0 : 1
		
		if let image = image, let text = text {
			attributedText = NSAttributedString(image: image, text: text)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
