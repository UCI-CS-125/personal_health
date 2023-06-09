/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A collection view controller that displays charts for mobility health data.
*/

import UIKit
import HealthKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

/// A representation of health data related to mobility.
class MobilityChartDataViewController: DataTypeCollectionViewController {
    
    let calendar: Calendar = .current
    
    var mobilityContent: [String] = [
//        HKQuantityTypeIdentifier.stepCount.rawValue,
        HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue
    ]
    
    var queries: [HKAnchoredObjectQuery] = []
    
    
    var docRef: DocumentReference!
    var docRef2: DocumentReference!
    let db = Firestore.firestore()
    
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
            let initialResultsHandler: (HKStatisticsCollection) -> Void = { [self] (statisticsCollection) in
                var values: [Double] = []
                statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                    let statisticsQuantity = getStatisticsQuantity(for: statistics, with: statisticsOptions)
                    if let unit = preferredUnit(for: item.dataTypeIdentifier),
                        let value = statisticsQuantity?.doubleValue(for: unit) {
                        values.append(value)
                    }
                }
                
                self.data[index].values = values
                
                print("exercise values: ", values)
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM_dd_yyyy"
                
                docRef = Firestore.firestore().document("exerciseData/" + (dateFormatter.string(from: date)))
                
                docRef2 = Firestore.firestore().document("lifeStyleData/" + (dateFormatter.string(from: date)))
                
                let exerciseDoc = self.db.collection("exerciseData").document(dateFormatter.string(from: date))
                
                let lifeStyleDoc = self.db.collection("lifeStyleData").document(dateFormatter.string(from: date))
                
                
                exerciseDoc.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
        //                print("Document data: \(dataDescription)")
                    } else {
                        print("Document does not exist")
                        self.db.collection("exerciseData").document(dateFormatter.string(from: date)).setData([:]) { err in
                                if let err = err {
                                    print("Error writing doc: \(err)")
                                } else {
                                    print("Doc successfully created")
                                }
                            }
                    }
                }
                
                for element in values {
                  print(element)
                }
//                let sum = values.reduce(0, +)
//                print("total dist ", sum)
                let today_dist = values.last
//                print("today_dist", today_dist)
                let meters_to_walk = 3218.69
                var get_exercise_score_daily = today_dist! / meters_to_walk
                print("get_exercise_score_daily", get_exercise_score_daily)
                if get_exercise_score_daily > 1 {
                    get_exercise_score_daily = 1.00
                }
                
                let dataToSave: [String: Any] = ["exerciseLifeScore": get_exercise_score_daily]
                docRef.setData(dataToSave) { (error) in
                    if let error = error {
                        print("errror: \(error.localizedDescription)")
                    } else {
                        print("Exercise Data has been saved")
                    }
                }
                
                
                lifeStyleDoc.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
        //                print("Document data: \(dataDescription)")
                    } else {
                        print("Document does not exist")
                        self.db.collection("lifeStyleData").document(dateFormatter.string(from: date)).setData(["exercise": get_exercise_score_daily]) { err in
                                if let err = err {
                                    print("Error writing doc: \(err)")
                                } else {
                                    print("Doc successfully created")
                                }
                            }
                    }
                }
                
                
              
                
                /*let dataToSave2: [String: Any] = ["exercise": get_exercise_score_daily]
                docRef2.setData(dataToSave2) { (error) in
                    if let error = error {
                        print("errror: \(error.localizedDescription)")
                    } else {
                        print("Exercise Data 2 has been saved")
                    }
                }*/
                
                docRef2.updateData(["exercise": get_exercise_score_daily])
            
                
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
