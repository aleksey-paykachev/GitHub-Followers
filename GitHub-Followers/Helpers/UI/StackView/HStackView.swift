//
//  HStackView.swift
//  GitHub-Followers
//
//  Created by Aleksey on 10.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class HStackView: CustomStackView {
	// MARK: - Init
	
	override init(_ arrangedSubviews: [UIView],
				  spacing: CGFloat = 0,
				  alignment: UIStackView.Alignment = .fill,
				  distribution: UIStackView.Distribution = .fill) {

		super.init(arrangedSubviews, spacing: spacing, alignment: alignment, distribution: distribution)
		axis = .horizontal
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
