//
//  KeyboardNotificationUserInfo.swift
//  GitHub-Followers
//
//  Created by Aleksey on 05.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

struct KeyboardNotificationUserInfo {
	let animationDuration: TimeInterval
	let frame: CGRect
	let height: CGFloat
	let width: CGFloat
	
	init?(userInfo: [AnyHashable : Any]?) {
		guard
			let userInfo = userInfo,
			let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
			let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
			else {
				return nil
		}
		
		self.animationDuration = animationDuration
		self.frame = keyboardFrame
		self.height = keyboardFrame.size.height
		self.width = keyboardFrame.size.width
	}
}
