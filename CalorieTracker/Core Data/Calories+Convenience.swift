//
//  Calories+Convenience.swift
//  CalorieTracker
//
//  Created by Alex on 6/28/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData

extension CalorieTracker {
    
    convenience init(calories: Int16, timestamp: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.calories = calories
        self.timestamp = timestamp
    }
    
    // creates Entry from EntryRepresentation
//    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) { // optional bc it may not pull data from Firebase
//        guard let mood = Mood(rawValue: entryRepresentation.mood) else {return nil}
//        self.init(title: entryRepresentation.title,
//                  bodyText: entryRepresentation.bodyText,
//                  timestamp: entryRepresentation.timestamp,
//                  mood: mood, identifier: entryRepresentation.identifier, context: context)
//    }
    
}

