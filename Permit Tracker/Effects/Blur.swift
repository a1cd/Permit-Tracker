//
//  Blur.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/15/21.
//

import SwiftUI

struct Blur: UIViewRepresentable {
	var style: UIBlurEffect.Style = .systemMaterial
	
	func makeUIView(context: Context) -> UIVisualEffectView {
		return UIVisualEffectView(effect: UIBlurEffect(style: style))
	}
	
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		uiView.effect = UIBlurEffect(style: style)
	}
	
}
