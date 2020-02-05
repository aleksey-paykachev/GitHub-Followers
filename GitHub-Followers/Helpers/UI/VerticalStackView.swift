//
//  VerticalStackView.swift
//  GitHub-Followers
//
//  Created by Aleksey on 05.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {
	// MARK: - Init
	
	init(_ arrangedSubviews: [UIView], spacing: CGFloat = 0) {
		super.init(frame: .zero)
		
		axis = .vertical
		self.spacing = spacing
		arrangedSubviews.forEach(addArrangedSubview)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
