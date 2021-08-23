//
//  Notes.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/20/21.
//

import SwiftUI

struct DrivingNotes: View {
	@Binding var fullText: String
    var body: some View {
		TextEditor(text: $fullText)
			.padding(.all)
			.font(.custom("HelveticaNeue", size: 13))
			.lineSpacing(5)
			.cornerRadius(10)
			.shadow(radius: 10, x: 5, y: 5)
    }
}

struct Notes_Previews: PreviewProvider {
    static var previews: some View {
        DrivingNotes()
    }
}
