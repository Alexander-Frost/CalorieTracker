//
//  CalorieTrackerController.swift
//  CalorieTracker
//
//  Created by Alex on 6/28/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData

class CalorieTrackerController {
    
    var calories: [CalorieTracker] {
        return loadFromCoreDataStore()
    }
    
    // MARK: - Operations
    
    func create(calories: Int16, timestamp: Date){
        _ = CalorieTracker(calories: calories, timestamp: timestamp)
        saveToPersistentStore()
    }
    
    func loadFromCoreDataStore() -> [CalorieTracker] {
        let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching from core data.")
            return []
        }
    }
    
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save() // save to persistent store
        } catch let error {
            print("Error saving moc: \(error)")
        }
    }
}
