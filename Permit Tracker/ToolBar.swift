//
//  ToolBar.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/11/21.
//

import SwiftUI

struct ToolBar: View {
	
	@Environment(\.managedObjectContext) private var viewContext
	
	@Binding var Recording: Bool
	@State var Saving: Bool = false
	
	var StartRecording: () -> Void
	var StopRecording: () -> Void
	
	func RecordImage() -> Image {
		if (self.Recording) {
			return Image(systemName: "pause.circle")
		} else {
			return Image(systemName: "record.circle")
		}
	}
	func SaveImage() -> Image {
		if (viewContext.hasChanges) {
			return Image(systemName: "externaldrive.badge.xmark")
		} else if (Saving) {
			return Image(systemName: "arrow.triangle.2.circlepath")
		} else {
			return Image(systemName: "externaldrive.badge.checkmark")
		}
	}
	
    var body: some View {
		HStack{
			RecordImage()
				.padding(.all)
				.imageScale(.large)
				.foregroundColor(.red)
				.onTapGesture {
					if (Recording) {
						StopRecording()
					} else {
						StartRecording()
					}
					Recording.toggle()
				}
			SaveImage()
				.padding(.all)
				.imageScale(.large)
				.foregroundColor(.red)
				.rotationEffect(.degrees(Saving ? 360: 0))
				.animation(.interactiveSpring(), value: Saving)
				.onTapGesture {
					Saving = true
					do {
						try viewContext.save()
						Saving = false
					} catch {
						Saving = false
					}
				}
		}
    }
}

func Nothing() {
	
}
struct ToolBar_Previews: PreviewProvider {
    static var previews: some View {
		ToolBar(Recording: .constant(false), StartRecording: Nothing, StopRecording: Nothing)
    }
}
