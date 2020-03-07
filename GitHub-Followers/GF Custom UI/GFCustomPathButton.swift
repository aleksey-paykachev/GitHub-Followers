//
//  GFCustomPathButton.swift
//  GitHub-Followers
//
//  Created by Aleksey on 28.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFCustomPathButton: UIButton {
	// MARK: - Properties

	private let path: UIBezierPath
	private let borderWidth: CGFloat
	private let animationDuration: TimeInterval

	private let borderColor: UIColor
	private let fillColor: UIColor
	private let backgroundFillColor: UIColor

	private lazy var buttonPath = path.scaled(to: bounds).cgPath
	private lazy var backgroundFillLayer = CAShapeLayer(path: buttonPath)
	
	private lazy var backgroundEmptyPath = CGPath.circle(center: bounds.center, radius: .zero)
	private lazy var backgroundFilledPath = CGPath.circle(in: bounds.excircleSquare)
	
	override var isSelected: Bool {
		didSet {
			if isSelected != oldValue { animateSelection() }
		}
	}
	
	
	// MARK: - Init
	
	init(path: UIBezierPath,
		 sideSize: CGFloat,
		 borderWidth: CGFloat,
		 animationDuration: TimeInterval,
		 borderColor: UIColor,
		 fillColor: UIColor,
		 backgroundFillColor: UIColor) {

		self.path = path
		self.borderWidth = borderWidth
		self.animationDuration = animationDuration
		self.borderColor = borderColor
		self.fillColor = fillColor
		self.backgroundFillColor = backgroundFillColor

		let frame = CGRect(origin: .zero, size: CGSize.square(sideSize))
		super.init(frame: frame)
		
		setupSublayers()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Setup
	
	private func setupSublayers() {
		// background layer
		let backgroundLayer = CAShapeLayer(path: buttonPath)
		backgroundLayer.fillColor = backgroundFillColor.cgColor
		
		// border layer
		let borderLayer = CAShapeLayer(path: buttonPath)
		borderLayer.fillColor = UIColor.clear.cgColor
		borderLayer.strokeColor = borderColor.cgColor
		borderLayer.lineWidth = borderWidth
		
		// selection layer
		backgroundFillLayer.path = isSelected ? backgroundFilledPath : backgroundEmptyPath
		backgroundFillLayer.fillColor = fillColor.cgColor
		backgroundFillLayer.mask = CAShapeLayer(path: buttonPath)

		// add sublayers
		layer.addSublayer(backgroundLayer)
		layer.addSublayer(backgroundFillLayer)
		layer.addSublayer(borderLayer)
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
