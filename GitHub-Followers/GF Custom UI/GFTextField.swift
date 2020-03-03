//
//  GFTextField.swift
//  GitHub-Followers
//
//  Created by Aleksey on 05.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class GFTextField: UITextField {
	// MARK: - Init
	
	init(placeholder: String? = nil, useAutoCorrection: Bool = false, showClearButton: Bool = true) {
		super.init(frame: .zero)
		
		self.placeholder = placeholder
		autocorrectionType = useAutoCorrection ? .yes : .no
		clearButtonMode = showClearButton ? .always : .never
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - API
	
	func showWrongInputError() {
		// shake textfield
		transform = transform.translatedBy(x: 8, y: 0)
		
		UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, animations: {

			self.transform = .identity
		})
		
		// temporary change border color
		let borderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
		borderColorAnimation.duration = 0.3
		borderColorAnimation.autoreverses = true
		borderColorAnimation.fromValue = layer.borderColor
		borderColorAnimation.toValue = UIColor.gfError.cgColor
		
		layer.add(borderColorAnimation, forKey: nil)
	}
	
	
	// MARK: - Setup
	
	private func setupView() {
		backgroundColor = .gfTextFieldBackground
		layer.setBorder(color: .gfTextFieldBorder, width: 2)
		layer.setCornerRadius(8)
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		super.textRect(forBounds: bounds).insetBy(dx: 8, dy: 0)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		super.editingRect(forBounds: bounds).insetBy(dx: 8, dy: 0)
	}
}
