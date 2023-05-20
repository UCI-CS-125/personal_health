//
//  ExerciseGoals.swift
//  WelcomingWellness
//
//  Created by Jason Wong on 5/19/23.
//  Copyright © 2023 Apple. All rights reserved.
//
import SwiftUI
import UIKit

struct ExerciseGoals: View {
    @State private var contacts = [
         "John",
         "Alice",
         "Bob",
         "Foo",
         "Bar"
     ]
     
//     var body: some View {
//         List {
//             ForEach(contacts, id: \.self) { contact in
//
//                 Text(contact)
//             }
//         }
//     }
    var body: some View {
        HStack{
            List {
                ForEach(contacts, id: \.self) { contact in
            
                    Text(contact)
                }
            }
        }
//        ZStack {
//            Color.pink
//            Button("Hello, SwiftUI!") {
//
//            }
//            .font(.title)
//            .buttonStyle(.borderedProminent)
//            .padding()
//        }
//                 List {
//                     ForEach(contacts, id: \.self) { contact in
//
//                         Text(contact)
//                     }
//                 }
        
    }
}
