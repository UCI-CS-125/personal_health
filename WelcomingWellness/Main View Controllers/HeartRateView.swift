//
//  HeartRateView.swift
//  WelcomingWellness
//
//  Created by Lee Chu on 6/8/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI
import Charts

//struct PointChartView: View {
//
//    private let chartData = ChartData.pointChartData
//
//    var body: some View {
//        VStack {
//            GroupBox("Heart Beats by Time") {
//                Chart(chartData) { person in
//                    PointMark(
//                        x: .value("Time", person.heartBeat.time, unit: .minute),
//                        y: .value("Heart Beat", person.heartBeat.beat)
//                    )
//                    .foregroundStyle(by: .value("Heart Beat", person.heartBeat.beat))
//                }
//                .padding(.horizontal, 16)
//            }
//            .backgroundStyle(Color.white)
//        }
//        .navigationTitle("Point Chart")
//    }
//}
//
//struct PointChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        PointChartView()
//    }
//}
