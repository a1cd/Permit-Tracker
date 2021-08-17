//
//  Graph.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/14/21.
//

import SwiftUI

struct Graph: View {
	var List: [CGFloat] = [
		80,
		118,
		293,
		56,
		115,
		209,
		131,
		57,
		77,
		214,
		258,
		243,
		165,
		115,
		56
	]
	
	func Normalize(_ list: [CGFloat]) -> [CGFloat] {
		var NewList: [CGFloat] = []
		let max = list.max() ?? 0
		let min = list.min() ?? 0
		for val in list {
			NewList.append(val/max)
		}
		return NewList
	}
	
	var NormalizedList: [CGFloat] {
		Normalize(List)
	}
	
    var body: some View {
		HStack(alignment: .bottom, spacing: 3) {
			ForEach(0..<NormalizedList.count) {i in
				Capsule()
					.fill(
						LinearGradient(
							gradient: .init(colors:[
								.init(hue: 0, saturation: 1, brightness: 0.6),
								.init(hue: 0, saturation: 1, brightness: Double(0.6+((NormalizedList[i])*0.5)))
							]),
							startPoint: .bottom,
							endPoint: .top
						)
					)
					.frame(height: NormalizedList[i]*300)
			}
		}
		.padding(.all)
		.frame(height: 300.0)
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
		Graph()
			
    }
}
