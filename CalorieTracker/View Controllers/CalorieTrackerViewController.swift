//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Alex on 6/28/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource { //NSFetchedResultsControllerDelegate

    // MARK: - Properties
    var addedCalories: Int16 = 0
    var chartData = [Double]()
    
    let calorieController = CalorieTrackerController()

//    lazy var fetchedResultsController: NSFetchedResultsController<CalorieTracker> = {
//        let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
//
//        let moc = CoreDataStack.shared.mainContext
//
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
//        fetchedResultsController.delegate = self
//
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            print("Error performing fetchedResultsController: \(error)")
//        }
//        return fetchedResultsController
//    }()
    
    // MARK: - Outlets
    
    @IBOutlet var chartView: Chart!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Actions
    
    @IBAction func addCalloriesToTrackerTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories", preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            guard let caloriesString = alert.textFields?.first?.text, let calories = Int16(caloriesString) else {return}
            self.addedCalories = calories
            self.calorieController.create(calories: calories, timestamp: Date())
            
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: NSNotification.Name("NewCalories"), object: self)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        
        present(alert, animated: true)
    }
    
    @objc func caloriesAdded(_ notification: NSNotification) {
        updateViews()
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(caloriesAdded), name: NSNotification.Name("NewCalories"), object: nil)
        updateViews()
    }
    
    // MARK: - Operations
    
    func updateViews() {
        let series = ChartSeries(chartData)
        
        for calories in calorieController.calories {
            //fetchedResultsController.fetchedObjects as! [CalorieTracker]
            chartData.append(Double(calories.calories))
        }
        if addedCalories > 0 {
            chartData.append(Double(addedCalories))
        }
        chartView.add(series)
        
        tableView.reloadData()
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("HERE, number of objects: ", calorieController.calories.count)
//        return fetchedResultsController.fetchedObjects?.count ?? 0
        return calorieController.calories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail Cell", for: indexPath)
        
        let calories = calorieController.calories[indexPath.row] // entryController.entries[indexPath.row]
        guard let timestamp = calories.timestamp else { return cell }

//        let cellCalories = fetchedResultsController.object(at: indexPath)
//        guard let timestamp = cellCalories.timestamp else { return cell }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, Y, h:mm a"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        cell.textLabel?.text = "Calories: \(calories.calories)" //cellCalories.calories

        
        return cell
    }
}
