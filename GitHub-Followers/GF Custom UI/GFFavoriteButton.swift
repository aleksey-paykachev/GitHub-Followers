//
//  GFFavoriteButton.swift
//  GitHub-Followers
//
//  Created by Aleksey on 28.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFFavoriteButton: UIButton {
	// MARK: - Properties

	private let primaryColor: UIColor = .gfFavoriteButton
	private let secondaryColor: UIColor = .gfBackground
	private let borderWidth: CGFloat = 3
	private let animationDuration: TimeInterval

	private lazy var starSymbolPath = GFBezierPaths.starSymbolPath.scale(to: bounds).cgPath
	private lazy var backgroundFillLayer = CAShapeLayer(path: starSymbolPath)
	
	lazy private var backgroundEmptyPath = CGPath.circle(center: bounds.center, radius: .zero)
	lazy private var backgroundFilledPath = CGPath.circle(in: bounds.excircleSquare)
	
	override var isSelected: Bool {
		didSet {
			if isSelected != oldValue { animateSelection() }
		}
	}
	
	
	// MARK: - Init
	
	init(sideSize: CGFloat, animationDuration: TimeInterval) {
		self.animationDuration = animationDuration

		let frame = CGRect(origin: .zero, size: CGSize.square(sideSize))
		super.init(frame: frame)
		
		setupSublayers()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Setup
	
	private func setupSublayers() {
		// shape layer
		let shapeLayer = CAShapeLayer(path: starSymbolPath)
		shapeLayer.fillColor = secondaryColor.cgColor
		shapeLayer.strokeColor = primaryColor.cgColor
		shapeLayer.lineWidth = borderWidth
		
		// selection layer
		backgroundFillLayer.path = isSelected ? backgroundFilledPath : backgroundEmptyPath
		backgroundFillLayer.fillColor = primaryColor.cgColor
		backgroundFillLayer.mask = CAShapeLayer(path: starSymbolPath)

		layer.addSublayer(shapeLayer)
		layer.addSublayer(backgroundFillLayer)
	}
	
	
	// MARK: - Private methods
	
	private func animateSelection() {
		let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
		
		animation.fromValue = isSelected ? backgroundEmptyPath : backgroundFilledPath
		animation.toValue = isSelected ? backgroundFilledPath : backgroundEmptyPath
		animation.duration = animationDuration
		animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		
		backgroundFillLayer.add(animation, forKey: "SelectionLayerPathAnimation")
		backgroundFillLayer.path = isSelected ? backgroundFilledPath : backgroundEmptyPath
	}
}
