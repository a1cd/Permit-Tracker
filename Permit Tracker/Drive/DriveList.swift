//
//  DriveList.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/13/21.
//

import SwiftUI

struct DriveList: View {
	
	var locationViewModel: LocationViewModel
	var Drives: FetchedResults<Item>
	
	let deleteItems: (_ offsets: IndexSet) -> Void
	
    var body: some View {
//		NavigationView {
			List {
				ForEach(0..<Drives.count, content: {i in
					if Drives[i].locations != nil {
						if Drives[i].locations!.count > 0 {
							NavigationLink(
								destination:
									FullDriveData(
										locationViewModel: locationViewModel,
										driveDetail: DriveDetails(item: Drives[i])
									)
							)
							{
								Drive(
									locationViewModel: locationViewModel,
									driveDetail: DriveDetails(item: Drives[i])
								)
							}
						}
					}
				})
				.onDelete(perform: deleteItems)
			}
//		}
    }
}
