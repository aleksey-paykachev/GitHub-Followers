//
//  UserDetailsInfoBlocksView.swift
//  GitHub-Followers
//
//  Created by Aleksey on 10.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

class UserDetailsInfoBlocksView: UIView {
	// MARK: - Properties
	
	let infoBlocks: [InfoBlock]
	let buttonData: ButtonData
	
	
	// MARK: - Init
	
	init(infoBlocks: [InfoBlock], buttonData: ButtonData) {
		self.infoBlocks = infoBlocks
		self.buttonData = buttonData
		super.init(frame: .zero)
		
		setupView()
		setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup
	
	private func setupView() {
		backgroundColor = .gfDetailsInfoBlockBackground
		layer.setCornerRadius(16)
	}
	
	private func setupSubviews() {
		let infoBlockLabels = infoBlocks.map { infoBlock in
			GFLabel(text: infoBlock.text,
					image: infoBlock.logoImage,
					fontSize: 17.5,
					fontWeight: .medium,
					color: .gfTextSecondary,
					alignment: .center,
					allowMultipleLines: true)
		}
		
		let infoBlockStack = HStackView(infoBlockLabels, alignment: .leading, distribution: .fillEqually)

		let actionButton = GFButton(title: buttonData.title, backgroundColor: buttonData.color)
		actionButton.constrainHeight(42)
		actionButton.addTarget(self, action: #selector(buttonDidPressed), for: .touchUpInside)
		
		let detailsViewStack = VStackView([infoBlockStack, actionButton], spacing: 18)

		addSubview(detailsViewStack)
		detailsViewStack.constrainToSuperview(padding: 14)
	}
	
	
	// MARK: - Methods
	
	@objc private func buttonDidPressed() {
		buttonData.action()
	}
	

	// MARK: - Nested types
	
	enum InfoBlock {
		case repos(count: Int)
		case gists(count: Int)
		case following(count: Int)
		case followers(count: Int)
		
		var logoImage: UIImage? {
			switch self {
			case .repos:
				return .sfSymbolFolder
			case .gists:
				return .sfSymbolDocText
			case .followers:
				return .sfSymbolPerson2
			case .following:
				return .sfSymbolHeart
			}
		}
		
		var text: String {
			switch self {
			case .repos(let count):
				return "Public Repos\n\(count)"
			case .gists(let count):
				return "Public Gists\n\(count)"
			case .followers(let count):
				return "Followers\n\(count)"
			case .following(let count):
				return "Following\n\(count)"
			}
		}
	}
	
	struct ButtonData {
		let title: String
		let type: ButtonType
		let action: () -> ()
		
		var color: UIColor {
			switch type {
			case .primary: return .gfPrimary
			case .secondary: return .gfSecondary
			}
		}
		
		enum ButtonType {
			case primary
			case secondary
		}
	}
}
