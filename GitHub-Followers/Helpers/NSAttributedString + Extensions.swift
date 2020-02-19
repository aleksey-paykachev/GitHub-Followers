//
//  NSAttributedString + Extensions.swift
//  GitHub-Followers
//
//  Created by Aleksey on 18.02.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension NSAttributedString {
	
	// Attributed text string with prepended image attachment
	convenience init?(image: UIImage?, text: String) {
		guard let image = image?.withRenderingMode(.alwaysTemplate) else { return nil }

		// image
		let imageAttachment = NSTextAttachment(image: image)
		let imageString = NSAttributedString(attachment: imageAttachment)

		// text
		let textString = NSAttributedString(string: " " + text)

		// result
		let resultString = NSMutableAttributedString(attributedString: imageString)
		resultString.append(textString)
		
		self.init(attributedString: resultString)
	}
}
