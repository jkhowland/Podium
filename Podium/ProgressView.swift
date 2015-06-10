//
//  Progressview.swift
//  Podium
//
//  Created by Caleb Hicks on 6/9/15.
//  Copyright (c) 2015 [insert name here]. All rights reserved.
//

import UIKit

@IBDesignable

class ProgressView: UIView {
    
    @IBInspectable private let progressLayer: CAShapeLayer = CAShapeLayer()
    @IBInspectable private var dashedLayer: CAShapeLayer = CAShapeLayer()
    
    @IBInspectable var circleColor: UIColor = UIColor.purpleColor() {
        didSet {
            progressLayer.strokeColor = circleColor.CGColor
        }
    }
    
    @IBInspectable var dashColor: UIColor = UIColor.grayColor() {
        didSet {
            progressLayer.strokeColor = dashColor.CGColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createProgressLayer()
        self.animateProgressViewToProgress(0.41)
    }
    
    override func prepareForInterfaceBuilder() {
        createProgressLayer()
        
        self.animateProgressViewToProgress(0.4)
    }
    
    private func createProgressLayer() {
        let startAngle = CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
        
        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: CGRectGetWidth(frame)/2 - 4.0, startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        progressLayer.fillColor = nil
        progressLayer.strokeColor = circleColor.CGColor
        progressLayer.lineWidth = 4.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
        let dashedLayer = CAShapeLayer()
        dashedLayer.strokeColor = dashColor.CGColor
        dashedLayer.fillColor = nil
        dashedLayer.lineDashPattern = [3, 4]
        dashedLayer.lineJoin = "round"
        dashedLayer.lineWidth = 2.0
        dashedLayer.path = progressLayer.path
        layer.insertSublayer(dashedLayer, below: progressLayer)
    }
    
    func animateProgressViewToProgress(progress: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(progressLayer.strokeEnd)
        animation.toValue = CGFloat(progress)
        animation.duration = 0.3
        animation.fillMode = kCAFillModeForwards
        progressLayer.strokeEnd = CGFloat(progress)
        progressLayer.addAnimation(animation, forKey: "animation")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
