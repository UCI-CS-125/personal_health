//
//  ExerciseHeartrateChildVC.swift
//  WelcomingWellness
//
//  Created by Ulia on 5/1/23.
//  Copyright © 2023 Apple. All rights reserved.
//


import UIKit
import HealthKit

/// A representation of health data related to mobility.
class ExerciseHeartrateChildVC: DataTypeCollectionViewController {
    
    let calendar: Calendar = .current
    
    var mobilityContent: [String] = [
        HKQuantityTypeIdentifier.heartRate.rawValue
    ]
    
    var queries: [HKAnchoredObjectQuery] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = mobilityContent.map { ($0, []) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Authorization
        if !queries.isEmpty { return }
        
        HealthData.requestHealthDataAccessIfNeeded(dataTypes: mobilityContent) { (success) in
            if success {
                self.setUpBackgroundObservers()
                self.loadData()
            }
        }
    }
    
    // MARK: - Data Functions
    
    func loadData() {
        performQuery {
            // Dispatch UI updates to the main thread.
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        }
    }
    
    func setUpBackgroundObservers() {
        data.compactMap { getSampleType(for: $0.dataTypeIdentifier) }.forEach { (sampleType) in
            createAnchoredObjectQuery(for: sampleType)
        }
    }
    
    func createAnchoredObjectQuery(for sampleType: HKSampleType) {
        // Customize query parameters
        let predicate = createLastWeekPredicate()
        let limit = HKObjectQueryNoLimit
        
        // Fetch anchor persisted in memory
        let anchor = HealthData.getAnchor(for: sampleType)
        
        // Create HKAnchoredObjecyQuery
        let query = HKAnchoredObjectQuery(type: sampleType, predicate: predicate, anchor: anchor, limit: limit) {
            (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            
            // Handle error
            if let error = errorOrNil {
                print("HKAnchoredObjectQuery initialResultsHandler with identifier \(sampleType.identifier) error: \(error.localizedDescription)")
                
                return
            }
            
            print("HKAnchoredObjectQuery initialResultsHandler has returned for \(sampleType.identifier)!")
            
            // Update anchor for sample type
            HealthData.updateAnchor(newAnchor, from: query)
            
            Network.push(addedSamples: samplesOrNil, deletedSamples: deletedObjectsOrNil)
        }
        
        // Create update handler for long-running background query
        query.updateHandler = { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            
            // Handle error
            if let error = errorOrNil {
                print("HKAnchoredObjectQuery initialResultsHandler with identifier \(sampleType.identifier) error: \(error.localizedDescription)")
                
                return
            }
            
            print("HKAnchoredObjectQuery initialResultsHandler has returned for \(sampleType.identifier)!")
            
            // Update anchor for sample type
            HealthData.updateAnchor(newAnchor, from: query)
            
            // The results come back on an anonymous background queue.
            Network.push(addedSamples: samplesOrNil, deletedSamples: deletedObjectsOrNil)
        }
        
        HealthData.healthStore.execute(query)
        queries.append(query)
    }
    
    // MARK: Data Functions
    
    func performQuery(completion: @escaping () -> Void) {
        // Create a query for each data type.
        for (index, item) in data.enumerated() {
            // Set dates
            let now = Date()
            let startDate = getLastWeekStartDate()
            let endDate = now
            
            let predicate = createLastWeekPredicate()
            let dateInterval = DateComponents(day: 1)
            
            // Process data.
            let statisticsOptions = getStatisticsOptions(for: item.dataTypeIdentifier)
            let initialResultsHandler: (HKStatisticsCollection) -> Void = { (statisticsCollection) in
                var values: [Double] = []
                statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                    let statisticsQuantity = getStatisticsQuantity(for: statistics, with: statisticsOptions)
                    if let unit = preferredUnit(for: item.dataTypeIdentifier),
                        let value = statisticsQuantity?.doubleValue(for: unit) {
                        print("heartrate valueEEEE: ", value)
                        values.append(value)
                    }
                }
                
                print("heartrate values: ", values)
                
                self.data[index].values = values
                
                completion()
            }
            
            // Fetch statistics.
            HealthData.fetchStatistics(with: HKQuantityTypeIdentifier(rawValue: item.dataTypeIdentifier),
                                       predicate: predicate,
                                       options: statisticsOptions,
                                       startDate: startDate,
                                       interval: dateInterval,
                                       completion: initialResultsHandler)
        }
    }
}





////
////  ExerciseHeartbeatChildVC.swift
////  SmoothWalker
////
////  Created by Ulia on 5/12/23.
////  Copyright © 2023 Apple. All rights reserved.
////
//
//import UIKit
//
//class ExerciseHeartrateChildVC: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .purple
//        // Do any additional setup after loading the view.
//    }
//}
