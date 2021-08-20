//
//  Description.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/20/21.
//

import Foundation
import SwiftUI

struct Description {
	var text: String
	var description: String
	var link: URL?
	var linkText: String?
	init(_ Text: String, _ Description: String, _ Link: URL? = nil, _ LinkText: String? = nil) {
		self.text = Text
		self.description = Description
		self.link = Link
		self.linkText = LinkText
	}
}
