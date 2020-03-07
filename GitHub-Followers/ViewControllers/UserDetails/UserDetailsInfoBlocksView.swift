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
	let action: Action
	
	// MARK: - Init
	
	init(infoBlocks: [InfoBlock], action: Action) {
		self.infoBlocks = infoBlocks
		self.action = action
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

		let actionButton = GFButton(title: action.title, backgroundColor: action.buttonColor)
		actionButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
		actionButton.addTarget(self, action: #selector(buttonDidPressed), for: .touchUpInside)
		
		let detailsViewStack = VStackView([infoBlockStack, actionButton], spacing: 18)

		addSubview(detailsViewStack)
		detailsViewStack.constrainToSuperview(padding: 14)
	}
	
	
	// MARK: - Methods
	
	@objc private func buttonDidPressed() {
		action.completion()
	}
	

	// MARK: - Enum types
	
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
	
	enum Action {
		case primary(title: String, completion: () -> ())
		case secondary(title: String, completion: () -> ())
		
		var title: String {
			switch self {
			case .primary(let title, _): return title
			case .secondary(let title, _): return title
			}
		}
		
		var buttonColor: UIColor {
			switch self {
			case .primary: return .gfPrimary
			case .secondary: return .gfSecondary
			}
		}
		
		var completion: () -> () {
			switch self {
			case .primary(_, let completion): return completion
			case .secondary(_, let completion): return completion
			}
		}
	}
}
