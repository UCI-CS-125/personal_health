//
//  HeartRateViewController.swift
//  WelcomingWellness
//
//  Created by Lee Chu on 6/8/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import SwiftUI
import Charts
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Foundation
import HealthKit


class HeartRateViewController: UIViewController {
//
//    public func fetchLatestHeartRateSample(
//      completion: @escaping (_ samples: [HKQuantitySample]?) -> Void) {
//
//      /// Create sample type for the heart rate
//      guard let sampleType = HKObjectType
//        .quantityType(forIdentifier: .heartRate) else {
//          completion(nil)
//        return
//      }
//
//      /// Predicate for specifiying start and end dates for the query
//      let predicate = HKQuery
//        .predicateForSamples(
//          withStart: Date.distantPast,
//          end: Date(),
//          options: .strictEndDate)
//
//      /// Set sorting by date.
//      let sortDescriptor = NSSortDescriptor(
//        key: HKSampleSortIdentifierStartDate,
//        ascending: false)
//
//      /// Create the query
//      let query = HKSampleQuery(
//        sampleType: sampleType,
//        predicate: predicate,
//        limit: Int(HKObjectQueryNoLimit),
//        sortDescriptors: [sortDescriptor]) { (_, results, error) in
//
//          guard error == nil else {
//            print("Error: \(error!.localizedDescription)")
//            return
//          }
//
//
//          completion(results as? [HKQuantitySample])
//      }
//
//      /// Execute the query in the health store
//      let healthStore = HKHealthStore()
//      healthStore.execute(query)
//    }
    

//this is diff code i also tried
    let health: HKHealthStore = HKHealthStore()
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    let heartRateType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        var heartRateQuery:HKSampleQuery?

    /*Method to get todays heart rate - this only reads data from health kit. */
     func getTodaysHeartRates() {
        //predicate
        let calendar = NSCalendar.current
        let now = NSDate()
        let components = calendar.dateComponents([.year, .month, .day], from: now as Date)

        guard let startDate:NSDate = calendar.date(from: components) as NSDate? else { return }
        var dayComponent    = DateComponents()
        dayComponent.day    = 1
        let endDate:NSDate? = calendar.date(byAdding: dayComponent, to: startDate as Date) as NSDate?
        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: endDate as Date?, options: [])

        //descriptor
        let sortDescriptors = [
                                NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                              ]

        heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 25, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
            guard error == nil else { print("error"); return }

            self.printHeartRateInfo(results: results)
        }) //eo-query

        health.execute(heartRateQuery!)
     }//eom

    /*used only for testing, prints heart rate info */
    private func printHeartRateInfo(results:[HKSample]?)
    {
        for (_, sample) in results!.enumerated() {
            guard let currData:HKQuantitySample = sample as? HKQuantitySample else { return }

            print("[\(sample)]")
            print("Heart Rate: \(currData.quantity.doubleValue(for: heartRateUnit))")
            print("quantityType: \(currData.quantityType)")
            print("Start Date: \(currData.startDate)")
            print("End Date: \(currData.endDate)")
            print("Metadata: \(currData.metadata)")
            print("UUID: \(currData.uuid)")
            print("Source: \(currData.sourceRevision)")
            print("Device: \(currData.device)")
            print("---------------------------------\n")
        }//eofl
    }//eom
    
    
}

