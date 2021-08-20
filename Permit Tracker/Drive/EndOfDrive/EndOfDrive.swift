//
//  EndOfDrive.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/19/21.
//

import SwiftUI

struct EndOfDrive: View {
	@Binding var working: Bool
    var body: some View {
		VStack {
//			Button("OK", action: working.toggle())
		}
    }
}

struct EndOfDrive_Previews: PreviewProvider {
    static var previews: some View {
		EndOfDrive(working: .constant(true))
    }
}
