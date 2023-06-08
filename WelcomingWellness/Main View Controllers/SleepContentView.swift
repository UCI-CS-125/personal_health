//
//  SleepContentView.swift
//  WelcomingWellness
//
//  Created by Lee Chu on 6/7/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

struct SleepContentView: View {
    
    @ObservedObject private var sleepModel = sleepViewModel()
    
    var body: some View {
        NavigationView {
            List(sleepModel.hours) { hour in
                VStack(alignment: .leading) {
                    Text(hour.datey).font(.title)
                    Text(hour.hoursSlept).font(.subheadline)
                }
            }.navigationBarTitle("Hours Slept")
                .onAppear() {
                    self.sleepModel.fetchData()
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        SleepContentView()
//    }
//}

//var child = UIHostingController(rootView: SleepContentView())
//var parent = UIViewController()
//child.view.translatesAutoresizingMaskIntoConstraints = false
//child.view.frame = parent.view.bounds
//
//parent.view.addSubview(child.view)
//parent.addChild(child)
//
//child.removeFromParent()
//child.view.removeFromSuperview()
