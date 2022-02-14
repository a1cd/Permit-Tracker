//
//  Record Button.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 2/11/22.
//

import SwiftUI



struct RecordButton: View {
	@Binding var recording: Bool
    var body: some View {
		Group {
//			if (recording !) {
				if (recording) {
					Image(systemName: "stop.circle")
						.font(.system(size: 25))
				} else {
					Image(systemName: "record.circle")
						.font(.system(size: 25))
				}
//			}
		}
		.padding(.horizontal)
		.imageScale(.large)
		.foregroundColor(.red)
    }
}

struct RecordButton_Previews: PreviewProvider {
    static var previews: some View {
		VStack {
		RecordButton(recording: .constant(true))
			.padding(.all)
		RecordButton(recording: .constant(false))
			.padding(.all)
		}
    }
}
