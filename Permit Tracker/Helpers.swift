//
//  Helpers.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/22/21.
//

import Foundation
import SwiftUI

extension UIColor {
	var color: Color {
		return Color(self)
	}
}
func TimeIntervalFrom(Days: Double = 0, Hours: Double = 0, Minuites: Double = 0, Seconds: Double = 0) -> TimeInterval {
	var interval: TimeInterval = TimeInterval()
	interval += Days
	interval *= 24
	
	interval += Hours
	interval *= 60
	
	interval += Minuites
	interval *= 60
	
	interval += Seconds
	interval *= 60
	
	return interval
}
