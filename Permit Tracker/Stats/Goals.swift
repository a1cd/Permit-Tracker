//
//  Goals.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/14/21.
//

import Foundation
import SwiftUI

enum GoalType {
	case Distance
	case Time
	case Drives
}

class Goal {
	var Name: String
	init(Name: String) {
		self.Name = Name
	}
}

class DistanceGoal: Goal {
	var Limit: Double
	init(Name: String, Limit: Double) {
		self.Limit = Limit
		super.init(Name: Name)
	}
}

var GoalsDict: [String: [Goal]] = [
	"Distance": [
		DistanceGoal(Name: "First Mile", Limit: 3)
	],
	"Time": [
	],
	"Drives": [
	]
]

struct Goals: View {
	
	
	
    var body: some View {
        Text("")
    }
}

struct Goals_Previews: PreviewProvider {
    static var previews: some View {
        Goals()
    }
}
