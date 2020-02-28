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
	private let borderWidth: CGFloat = 4
	private let animationDuration: TimeInterval

	private let shapeLayer = CAShapeLayer()
	private let backgroundFillLayer = CAShapeLayer()
	
	lazy private var backgroundEmptyPath: CGPath = {
		let centerZeroSizeRect = (CGRect(origin: CGPoint(x: bounds.width / 2, y: bounds.height / 2), size: .zero))
		return CGPath(ellipseIn: centerZeroSizeRect, transform: nil)
	}()
	
	lazy private var backgroundFilledPath: CGPath = {
		let side = bounds.width
		let scaledSide = (side * side * 2).squareRoot() // outer diameter (hypotenuse)
		let offset = (scaledSide - side) / 2
		let scaledSquare = CGRect(x: -offset, y: -offset, width: scaledSide, height: scaledSide)
		
		return CGPath(ellipseIn: scaledSquare, transform: nil)
	}()
	
	override var isSelected: Bool {
		didSet {
			if isSelected != oldValue { animateSelection() }
		}
	}
	
	
	// MARK: - Init
	
	init(sideSize: CGFloat, animationDuration: TimeInterval) {
		self.animationDuration = animationDuration

		let frame = CGRect(origin: .zero, size: CGSize(width: sideSize, height: sideSize))
		super.init(frame: frame)
		
		setupView()
		setupSublayers()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Setup
	
	private func setupView() {
		backgroundColor = .clear
	}
	
	private func setupSublayers() {
		// shape layer
		shapeLayer.path = starSymbolPath.cgPath
		shapeLayer.fillColor = secondaryColor.cgColor
		shapeLayer.strokeColor = primaryColor.cgColor
		shapeLayer.lineWidth = borderWidth
		
		let scaleFactor = bounds.width / starSymbolPath.bounds.width
		shapeLayer.transform = CATransform3DMakeScale(scaleFactor, scaleFactor, 1)

		// selection layer
		backgroundFillLayer.path = isSelected ? backgroundFilledPath : backgroundEmptyPath
		backgroundFillLayer.fillColor = primaryColor.cgColor
		let maskLayer = CAShapeLayer()
		maskLayer.path = starSymbolPath.cgPath
		maskLayer.transform = CATransform3DMakeScale(scaleFactor, scaleFactor, 1)
		backgroundFillLayer.mask = maskLayer

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
	
	
	// MARK: - Bezier path
	
	let starSymbolPath: UIBezierPath = {
        let path = UIBezierPath()

		path.move(to: CGPoint(x: 1.72, y: 32.48))
        path.addLine(to: CGPoint(x: 15.28, y: 44.08))
        path.addCurve(to: CGPoint(x: 16.82, y: 48.82), controlPoint1: CGPoint(x: 16.64, y: 45.24), controlPoint2: CGPoint(x: 17.24, y: 47.07))
        path.addLine(to: CGPoint(x: 12.67, y: 66.17))
        path.addCurve(to: CGPoint(x: 19.81, y: 71.35), controlPoint1: CGPoint(x: 11.68, y: 70.3), controlPoint2: CGPoint(x: 16.18, y: 73.57))
        path.addLine(to: CGPoint(x: 35.03, y: 62.05))
        path.addCurve(to: CGPoint(x: 40.01, y: 62.05), controlPoint1: CGPoint(x: 36.56, y: 61.11), controlPoint2: CGPoint(x: 38.49, y: 61.11))
        path.addLine(to: CGPoint(x: 55.24, y: 71.35))
        path.addCurve(to: CGPoint(x: 62.37, y: 66.17), controlPoint1: CGPoint(x: 58.86, y: 73.57), controlPoint2: CGPoint(x: 63.36, y: 70.3))
        path.addLine(to: CGPoint(x: 58.23, y: 48.82))
        path.addCurve(to: CGPoint(x: 59.77, y: 44.08), controlPoint1: CGPoint(x: 57.81, y: 47.07), controlPoint2: CGPoint(x: 58.41, y: 45.24))
        path.addLine(to: CGPoint(x: 73.32, y: 32.48))
        path.addCurve(to: CGPoint(x: 70.6, y: 24.08), controlPoint1: CGPoint(x: 76.55, y: 29.71), controlPoint2: CGPoint(x: 74.83, y: 24.42))
        path.addLine(to: CGPoint(x: 52.81, y: 22.67))
        path.addCurve(to: CGPoint(x: 48.78, y: 19.74), controlPoint1: CGPoint(x: 51.02, y: 22.52), controlPoint2: CGPoint(x: 49.47, y: 21.39))
        path.addLine(to: CGPoint(x: 41.93, y: 3.26))
        path.addCurve(to: CGPoint(x: 33.11, y: 3.26), controlPoint1: CGPoint(x: 40.3, y: -0.67), controlPoint2: CGPoint(x: 34.74, y: -0.67))
        path.addLine(to: CGPoint(x: 26.27, y: 19.74))
        path.addCurve(to: CGPoint(x: 22.24, y: 22.67), controlPoint1: CGPoint(x: 25.58, y: 21.39), controlPoint2: CGPoint(x: 24.02, y: 22.52))
        path.addLine(to: CGPoint(x: 4.45, y: 24.08))
        path.addCurve(to: CGPoint(x: 1.72, y: 32.48), controlPoint1: CGPoint(x: 0.21, y: 24.42), controlPoint2: CGPoint(x: -1.51, y: 29.71))
        path.close()
		
		return path
	}()
}
