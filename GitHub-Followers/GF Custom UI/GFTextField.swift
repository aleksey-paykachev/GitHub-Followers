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
	
	init(placeholder: String? = nil) {
		super.init(frame: .zero)
		
		self.placeholder = placeholder
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupView() {
		// border
		layer.borderWidth = 2
		layer.borderColor = UIColor.tertiarySystemFill.cgColor
		
		// corner
		layer.cornerRadius = 8
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		super.textRect(forBounds: bounds).insetBy(dx: 8, dy: 0)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		super.editingRect(forBounds: bounds).insetBy(dx: 8, dy: 0)
	}
}
