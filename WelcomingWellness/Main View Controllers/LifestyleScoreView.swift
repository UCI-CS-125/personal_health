//
//  CircularProgressView.swift
//  WelcomingWellness
//
//  Created by Serena Rupani on 5/3/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class LifestyleScoreView: UIView {
    
    private var circle = CAShapeLayer()
    private var progress = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircle()
    }
    
    func createCircle() {
            let path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 80, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
            circle.path = path.cgPath
            circle.fillColor = UIColor.clear.cgColor
            circle.lineCap = .round
            circle.lineWidth = 20.0
            circle.strokeEnd = 1.0
            circle.strokeColor = UIColor.white.cgColor
            layer.addSublayer(circle)
            progress.path = path.cgPath
            progress.fillColor = UIColor.clear.cgColor
            progress.lineCap = .round
            progress.lineWidth = 10.0
            progress.strokeEnd = 0
            progress.strokeColor = UIColor.blue.cgColor
            layer.addSublayer(progress)
        }
    
    func Animation(duration: TimeInterval, toValue: Double) {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.toValue = toValue
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            progress.add(animation, forKey: "progress")
        }
}
