//
//  GraphView.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/14/21.
//

import SwiftUI

struct GagueSlice: Equatable, Identifiable, Hashable {
	var id: Int {hashValue}
	
	
	static func == (lhs: GagueSlice, rhs: GagueSlice) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
	
	var i = 0
	var lineWidth: CGFloat = 20
	var color: Color
	var opacity: Double = 1
	var start: CGFloat = 0
	var end: CGFloat?
	var lineCap: CGLineCap = .round
	var level: Int = 1
}

//MARK - Gague View
struct GagueView: View, Animatable {
	@State var BaseGague: GagueSlice?
	@Binding var Gagues: [GagueSlice]
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
			ForEach(Gagues, content: {i in
				if (i.end == nil) {
					Circle()
						.stroke(style: StrokeStyle(lineWidth: i.lineWidth, lineCap: i.lineCap, lineJoin: .round))
						.foregroundColor(i.color)
						.opacity(i.opacity)
						.rotationEffect(.init(degrees: 90*3))
						.animation(Animation.easeInOut(duration: 10), value: i)
						.frame(width: LevelToFrame(i), height: LevelToFrame(i))
				} else {
					Circle()
						.trim(from: i.start, to: i.end!)
						.stroke(style: StrokeStyle(lineWidth: i.lineWidth, lineCap: i.lineCap, lineJoin: .round))
						.foregroundColor(i.color)
						.opacity(i.opacity)
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
		@State var gagues =
		[
			GagueSlice(color: .red, start: 0, end: 0.333, level: 4),
			GagueSlice(color: .green, start: 0, end: 0.666, level: 3),
			GagueSlice(color: .blue, start: 0, end: 0.4, level: 2),
			GagueSlice(color: .red, opacity: 0.3, level: 4),
			GagueSlice(color: .green, opacity: 0.3, level: 3),
			GagueSlice(color: .blue, opacity: 0.3, level: 2)
		]
		return GagueView(
			BaseGague: baseGague,
			Gagues: $gagues
		)
		.onAppear() {
			withAnimation(Animation.easeInOut(duration: 5.0)) {
				gagues[0].end = 0.5
			}
		}
    }
}
