//
//  NotesView.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/20/21.
//

import SwiftUI

struct NotesView: View {
	@State var notes: String
	var processedNotes: String {
		if notes == "" {
			return "No notes were recorded on this drive."
		} else {
			return notes
		}
	}
    var body: some View {
		GroupBox(content: {
			Text(processedNotes)
				.font(.body)
				.multilineTextAlignment(.leading)
				.padding(1.0)
		}, label: {
			Text("Notes")
				.font(.body)
				.multilineTextAlignment(.leading)
		})
			.padding(10.0)
			.cornerRadius(10.0)
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
		NotesView(notes: "Did *some* good driving... at least. :/")
		NotesView(notes: "")
    }
}
