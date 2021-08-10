//
//  Tracker.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import Foundation
import MapKit

var Locations: [CLLocationCoordinate2D] = [
	CLLocationCoordinate2D(latitude: 35.943589, longitude: -78.959919),
	CLLocationCoordinate2D(latitude: 35.943543, longitude: -78.960043),
	CLLocationCoordinate2D(latitude: 35.943507, longitude: -78.960229),
	CLLocationCoordinate2D(latitude: 35.943501, longitude: -78.960532),
	CLLocationCoordinate2D(latitude: 35.943544, longitude: -78.96076),
	CLLocationCoordinate2D(latitude: 35.943673, longitude: -78.961196),
	CLLocationCoordinate2D(latitude: 35.943702, longitude: -78.961415),
	CLLocationCoordinate2D(latitude: 35.943737, longitude: -78.961957),
	CLLocationCoordinate2D(latitude: 35.943872, longitude: -78.961954),
	CLLocationCoordinate2D(latitude: 35.943978, longitude: -78.961988),
	CLLocationCoordinate2D(latitude: 35.944326, longitude: -78.962186),
	CLLocationCoordinate2D(latitude: 35.944623, longitude: -78.962302),
	CLLocationCoordinate2D(latitude: 35.944868, longitude: -78.962331),
	CLLocationCoordinate2D(latitude: 35.945864, longitude: -78.962219),
	CLLocationCoordinate2D(latitude: 35.946896, longitude: -78.962164),
	CLLocationCoordinate2D(latitude: 35.947093, longitude: -78.96221),
	CLLocationCoordinate2D(latitude: 35.947235, longitude: -78.962295),
	CLLocationCoordinate2D(latitude: 35.947385, longitude: -78.962454),
	CLLocationCoordinate2D(latitude: 35.947694, longitude: -78.962885),
	CLLocationCoordinate2D(latitude: 35.947865, longitude: -78.963054),
	CLLocationCoordinate2D(latitude: 35.94797, longitude: -78.963123),
	CLLocationCoordinate2D(latitude: 35.948143, longitude: -78.963201),
	CLLocationCoordinate2D(latitude: 35.948338, longitude: -78.963252),
	CLLocationCoordinate2D(latitude: 35.948512, longitude: -78.963265),
	CLLocationCoordinate2D(latitude: 35.949052, longitude: -78.963197),
	CLLocationCoordinate2D(latitude: 35.949363, longitude: -78.96319),
	CLLocationCoordinate2D(latitude: 35.950299, longitude: -78.963291),
	CLLocationCoordinate2D(latitude: 35.950443, longitude: -78.963322),
	CLLocationCoordinate2D(latitude: 35.95076, longitude: -78.96343),
	CLLocationCoordinate2D(latitude: 35.950344, longitude: -78.965506),
	CLLocationCoordinate2D(latitude: 35.950188, longitude: -78.966174),
	CLLocationCoordinate2D(latitude: 35.95017, longitude: -78.966344),
	CLLocationCoordinate2D(latitude: 35.950184, longitude: -78.966549),
	CLLocationCoordinate2D(latitude: 35.950285, longitude: -78.966845),
	CLLocationCoordinate2D(latitude: 35.950384, longitude: -78.966778),
	CLLocationCoordinate2D(latitude: 35.95039, longitude: -78.966759),
	CLLocationCoordinate2D(latitude: 35.950433, longitude: -78.966764),
	CLLocationCoordinate2D(latitude: 35.950772, longitude: -78.966531),
	CLLocationCoordinate2D(latitude: 35.951095, longitude: -78.96636),
	CLLocationCoordinate2D(latitude: 35.951566, longitude: -78.966183),
	CLLocationCoordinate2D(latitude: 35.952046, longitude: -78.966093),
	CLLocationCoordinate2D(latitude: 35.95255, longitude: -78.966067),
	CLLocationCoordinate2D(latitude: 35.952674, longitude: -78.966064),
	CLLocationCoordinate2D(latitude: 35.952889, longitude: -78.966058),
	CLLocationCoordinate2D(latitude: 35.952916, longitude: -78.966071),
	CLLocationCoordinate2D(latitude: 35.954709, longitude: -78.966015),
	CLLocationCoordinate2D(latitude: 35.954738, longitude: -78.96599),
	CLLocationCoordinate2D(latitude: 35.954748, longitude: -78.965994),
	CLLocationCoordinate2D(latitude: 35.954917, longitude: -78.965993),
	CLLocationCoordinate2D(latitude: 35.954925, longitude: -78.965984),
	CLLocationCoordinate2D(latitude: 35.954987, longitude: -78.966015),
	CLLocationCoordinate2D(latitude: 35.956666, longitude: -78.965972),
	CLLocationCoordinate2D(latitude: 35.956712, longitude: -78.965957),
	CLLocationCoordinate2D(latitude: 35.956824, longitude: -78.965956),
	CLLocationCoordinate2D(latitude: 35.956848, longitude: -78.965944),
	CLLocationCoordinate2D(latitude: 35.956879, longitude: -78.965966),
	CLLocationCoordinate2D(latitude: 35.95744, longitude: -78.965948),
	CLLocationCoordinate2D(latitude: 35.957729, longitude: -78.965898),
	CLLocationCoordinate2D(latitude: 35.95812, longitude: -78.965756),
	CLLocationCoordinate2D(latitude: 35.958425, longitude: -78.965593),
	CLLocationCoordinate2D(latitude: 35.958746, longitude: -78.965337),
	CLLocationCoordinate2D(latitude: 35.958974, longitude: -78.965097),
	CLLocationCoordinate2D(latitude: 35.959335, longitude: -78.964484),
	CLLocationCoordinate2D(latitude: 35.95936, longitude: -78.964404),
	CLLocationCoordinate2D(latitude: 35.959359, longitude: -78.964359),
	CLLocationCoordinate2D(latitude: 35.959367, longitude: -78.964355),
	CLLocationCoordinate2D(latitude: 35.959508, longitude: -78.964101),
	CLLocationCoordinate2D(latitude: 35.959503, longitude: -78.964084),
	CLLocationCoordinate2D(latitude: 35.959537, longitude: -78.964063),
	CLLocationCoordinate2D(latitude: 35.959581, longitude: -78.964),
	CLLocationCoordinate2D(latitude: 35.959783, longitude: -78.963528),
	CLLocationCoordinate2D(latitude: 35.960122, longitude: -78.962924),
	CLLocationCoordinate2D(latitude: 35.96036, longitude: -78.96259),
	CLLocationCoordinate2D(latitude: 35.960773, longitude: -78.962114),
	CLLocationCoordinate2D(latitude: 35.961458, longitude: -78.961403),
	CLLocationCoordinate2D(latitude: 35.961498, longitude: -78.96134),
	CLLocationCoordinate2D(latitude: 35.961504, longitude: -78.961296),
	CLLocationCoordinate2D(latitude: 35.96151, longitude: -78.96129),
	CLLocationCoordinate2D(latitude: 35.961594, longitude: -78.961224),
	CLLocationCoordinate2D(latitude: 35.961631, longitude: -78.961302),
	CLLocationCoordinate2D(latitude: 35.961631, longitude: -78.961302),
	CLLocationCoordinate2D(latitude: 35.961687, longitude: -78.961421),
	CLLocationCoordinate2D(latitude: 35.961567, longitude: -78.961534),
	CLLocationCoordinate2D(latitude: 35.96094, longitude: -78.962557),
	CLLocationCoordinate2D(latitude: 35.961086, longitude: -78.964301),
	CLLocationCoordinate2D(latitude: 35.961103, longitude: -78.964435),
	CLLocationCoordinate2D(latitude: 35.961161, longitude: -78.964663),
	CLLocationCoordinate2D(latitude: 35.961229, longitude: -78.964816),
	CLLocationCoordinate2D(latitude: 35.96146, longitude: -78.965143),
	CLLocationCoordinate2D(latitude: 35.961614, longitude: -78.965265),
	CLLocationCoordinate2D(latitude: 35.961775, longitude: -78.965355),
	CLLocationCoordinate2D(latitude: 35.961959, longitude: -78.965409),
	CLLocationCoordinate2D(latitude: 35.963008, longitude: -78.965408),
	CLLocationCoordinate2D(latitude: 35.96324, longitude: -78.965434),
	CLLocationCoordinate2D(latitude: 35.963347, longitude: -78.965465),
	CLLocationCoordinate2D(latitude: 35.963578, longitude: -78.965584),
	CLLocationCoordinate2D(latitude: 35.963776, longitude: -78.965737),
	CLLocationCoordinate2D(latitude: 35.964002, longitude: -78.965961),
	CLLocationCoordinate2D(latitude: 35.964145, longitude: -78.966177),
	CLLocationCoordinate2D(latitude: 35.964262, longitude: -78.966462),
	CLLocationCoordinate2D(latitude: 35.964319, longitude: -78.966747),
	CLLocationCoordinate2D(latitude: 35.964334, longitude: -78.966919),
	CLLocationCoordinate2D(latitude: 35.964346, longitude: -78.967667),
	CLLocationCoordinate2D(latitude: 35.964394, longitude: -78.967966),
	CLLocationCoordinate2D(latitude: 35.964436, longitude: -78.968098),
	CLLocationCoordinate2D(latitude: 35.964598, longitude: -78.96847),
	CLLocationCoordinate2D(latitude: 35.964669, longitude: -78.968714),
	CLLocationCoordinate2D(latitude: 35.964692, longitude: -78.96899),
	CLLocationCoordinate2D(latitude: 35.96469, longitude: -78.970086),
	CLLocationCoordinate2D(latitude: 35.964668, longitude: -78.970325),
	CLLocationCoordinate2D(latitude: 35.964617, longitude: -78.970573),
	CLLocationCoordinate2D(latitude: 35.964463, longitude: -78.970961),
	CLLocationCoordinate2D(latitude: 35.964376, longitude: -78.970896),
	CLLocationCoordinate2D(latitude: 35.964356, longitude: -78.970937),
	CLLocationCoordinate2D(latitude: 35.964112, longitude: -78.971419),
	CLLocationCoordinate2D(latitude: 35.964069, longitude: -78.971503),
	CLLocationCoordinate2D(latitude: 35.963902, longitude: -78.971811),
	CLLocationCoordinate2D(latitude: 35.963884, longitude: -78.971858),
	CLLocationCoordinate2D(latitude: 35.963953, longitude: -78.971916),
	CLLocationCoordinate2D(latitude: 35.963107, longitude: -78.97351),
	CLLocationCoordinate2D(latitude: 35.963269, longitude: -78.973638),
	CLLocationCoordinate2D(latitude: 35.961492, longitude: -78.976945),
	CLLocationCoordinate2D(latitude: 35.96167, longitude: -78.977007),
	CLLocationCoordinate2D(latitude: 35.961595, longitude: -78.97715),
	CLLocationCoordinate2D(latitude: 35.961595, longitude: -78.97715),
	CLLocationCoordinate2D(latitude: 35.961554, longitude: -78.977227),
	CLLocationCoordinate2D(latitude: 35.961303, longitude: -78.977005),
	CLLocationCoordinate2D(latitude: 35.961364, longitude: -78.976913),
	CLLocationCoordinate2D(latitude: 35.956292, longitude: -78.97354),
	CLLocationCoordinate2D(latitude: 35.956264, longitude: -78.973542),
	CLLocationCoordinate2D(latitude: 35.956264, longitude: -78.973526),
	CLLocationCoordinate2D(latitude: 35.956156, longitude: -78.973478),
	CLLocationCoordinate2D(latitude: 35.955559, longitude: -78.973209),
	CLLocationCoordinate2D(latitude: 35.95545, longitude: -78.973149),
	CLLocationCoordinate2D(latitude: 35.954714, longitude: -78.972812),
	CLLocationCoordinate2D(latitude: 35.954685, longitude: -78.972814),
	CLLocationCoordinate2D(latitude: 35.954685, longitude: -78.972799),
	CLLocationCoordinate2D(latitude: 35.954593, longitude: -78.972749),
	CLLocationCoordinate2D(latitude: 35.954585, longitude: -78.972765),
	CLLocationCoordinate2D(latitude: 35.954067, longitude: -78.972491),
	CLLocationCoordinate2D(latitude: 35.954056, longitude: -78.972478),
	CLLocationCoordinate2D(latitude: 35.954084, longitude: -78.972375),
	CLLocationCoordinate2D(latitude: 35.952902, longitude: -78.971599),
	CLLocationCoordinate2D(latitude: 35.952371, longitude: -78.97123),
	CLLocationCoordinate2D(latitude: 35.952317, longitude: -78.97136),
	CLLocationCoordinate2D(latitude: 35.952286, longitude: -78.971339),
	CLLocationCoordinate2D(latitude: 35.951632, longitude: -78.970896),
	CLLocationCoordinate2D(latitude: 35.951561, longitude: -78.970847),
	CLLocationCoordinate2D(latitude: 35.950932, longitude: -78.970423),
	CLLocationCoordinate2D(latitude: 35.95087, longitude: -78.970413),
	CLLocationCoordinate2D(latitude: 35.950781, longitude: -78.970347),
	CLLocationCoordinate2D(latitude: 35.950833, longitude: -78.970194),
	CLLocationCoordinate2D(latitude: 35.950124, longitude: -78.969726),
	CLLocationCoordinate2D(latitude: 35.949399, longitude: -78.969346),
	CLLocationCoordinate2D(latitude: 35.949311, longitude: -78.96925),
	CLLocationCoordinate2D(latitude: 35.948698, longitude: -78.969004),
	CLLocationCoordinate2D(latitude: 35.948698, longitude: -78.969004),
	CLLocationCoordinate2D(latitude: 35.948639, longitude: -78.968982),
	CLLocationCoordinate2D(latitude: 35.948755, longitude: -78.968872),
	CLLocationCoordinate2D(latitude: 35.948391, longitude: -78.968709),
	CLLocationCoordinate2D(latitude: 35.948385, longitude: -78.968687),
	CLLocationCoordinate2D(latitude: 35.948326, longitude: -78.968705),
	CLLocationCoordinate2D(latitude: 35.948246, longitude: -78.968701),
	CLLocationCoordinate2D(latitude: 35.947655, longitude: -78.968503),
	CLLocationCoordinate2D(latitude: 35.947103, longitude: -78.968388),
	CLLocationCoordinate2D(latitude: 35.946732, longitude: -78.968288),
	CLLocationCoordinate2D(latitude: 35.945906, longitude: -78.967978),
	CLLocationCoordinate2D(latitude: 35.945847, longitude: -78.967917),
	CLLocationCoordinate2D(latitude: 35.945832, longitude: -78.967924),
	CLLocationCoordinate2D(latitude: 35.945778, longitude: -78.967904),
	CLLocationCoordinate2D(latitude: 35.945797, longitude: -78.967795),
	CLLocationCoordinate2D(latitude: 35.945818, longitude: -78.96735),
	CLLocationCoordinate2D(latitude: 35.945698, longitude: -78.966188),
	CLLocationCoordinate2D(latitude: 35.945954, longitude: -78.966158),
	CLLocationCoordinate2D(latitude: 35.946193, longitude: -78.966094)
]
