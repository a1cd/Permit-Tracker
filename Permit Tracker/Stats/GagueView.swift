//
//  GraphView.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/14/21.
//

import SwiftUI

struct GagueSlice {
	var lineWidth: CGFloat = 20
	var color: Color
	var opacity: Double = 1
	var start: CGFloat = 0
	var end: CGFloat?
	var lineCap: CGLineCap = .round
	var level: Int = 1
}

//MARK - Gague View
struct GagueView: View {
	@State var BaseGague: GagueSlice?
	@State var Gagues: [GagueSlice]
	func LevelToFrame(_ Gague: GagueSlice) -> CGFloat {
		return ((Gague.lineWidth*2)*CGFloat(Gague.level))+Gague.lineWidth
	}
	func LevelToFrame(_ i: Int) -> CGFloat {
		return LevelToFrame(Gagues[i])
	}
	var body: some View {
		ZStack {
			if BaseGague != nil {
				Circle()
					.stroke(lineWidth: BaseGague!.lineWidth)
					.opacity(BaseGague!.opacity)
					.foregroundColor(BaseGague!.color)
					.frame(width: LevelToFrame(BaseGague!), height: LevelToFrame(BaseGague!))
			}
			ForEach(0..<Gagues.count, content: {i in
				if (Gagues[i].end == nil) {
					Circle()
						.stroke(style: StrokeStyle(lineWidth: Gagues[i].lineWidth, lineCap: Gagues[i].lineCap, lineJoin: .round))
						.foregroundColor(Gagues[i].color)
						.opacity(Gagues[i].opacity)
						.rotationEffect(.init(degrees: 90*3))
						.frame(width: LevelToFrame(i), height: LevelToFrame(i))
				} else {
					Circle()
						.trim(from: Gagues[i].start, to: Gagues[i].end!)
						.stroke(style: StrokeStyle(lineWidth: Gagues[i].lineWidth, lineCap: Gagues[i].lineCap, lineJoin: .round))
						.foregroundColor(Gagues[i].color)
						.opacity(Gagues[i].opacity)
						.rotationEffect(.init(degrees: 90*3))
						.frame(width: LevelToFrame(i), height: LevelToFrame(i))
				}
			})
		}
	}
}

struct GagueView_Previews: PreviewProvider {
    static var previews: some View {
		let baseGague = GagueSlice(color: .clear, opacity: 1)
		
		GagueView(
			BaseGague: baseGague,
			Gagues: [
				GagueSlice(color: .red, start: 0, end: 0.333, level: 4),
				GagueSlice(color: .green, start: 0, end: 0.666, level: 3),
				GagueSlice(color: .blue, start: 0, end: 0.4, level: 2),
				GagueSlice(color: .red, opacity: 0.3, level: 4),
				GagueSlice(color: .green, opacity: 0.3, level: 3),
				GagueSlice(color: .blue, opacity: 0.3, level: 2)
			]
		)
    }
}
