//
//  ToolBar.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/11/21.
//

import SwiftUI
import CoreLocation

struct ToolBar: View {
	
	@Environment(\.managedObjectContext) private var viewContext
	
	@Binding var Recording: Bool
	@State var Saving: Bool = false
	
	var StartRecording: () -> Void
	var StopRecording: () -> Void
//	@State var locationAccess: CL
	
	func RecordImage() -> some View {
		if (self.Recording) {
			return Image(systemName: "stop.circle")
				.font(.system(size: 40))
		} else {
			return Image(systemName: "record.circle")
				.font(.system(size: 40))
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
				}
		}
    }
}

func Nothing(_ Nothing: Any?) {
	
}
func Nothing() {
	
}
struct ToolBar_Previews: PreviewProvider {
    static var previews: some View {
		ToolBar(Recording: .constant(false), StartRecording: Nothing, StopRecording: Nothing)
    }
}
