//
//  BadgeView.swift
//
//  Created by Nicolae Rogojan on 26.10.2021.
//

import UIKit

class BadgeView: UIView {

    var animationTime: Double = 0.8
    var needsArcDraw = false
    var needsPercentageDraw = false

    var arc: BadgeArc? {
        didSet {
            needsArcDraw = true
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        draw()
        drawPercentage()
    }
    
    func initSubviews() {
        backgroundColor = .clear
    }
}

// MARK: - Extension RatingView

extension BadgeView {
    internal func drawPercentage() {
        guard needsPercentageDraw, let budgetArc = arc else { return }
        
        // Draw the percentage in the middle of the view.
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        let rect = CGRect(x: viewCenter.x - 30, y: viewCenter.y - 12, width: 50, height: 25)
        
        // NSAttributedString cannot be used because of baselineOffset is not working
        let percentage = createTextLayer(text: String(format: "%3.0f", (budgetArc.percentage)))
        percentage.frame = rect
        percentage.font = ThemeSettings.theme.fonts.defaultFont(ofSize: 16, weight: .bold)
        percentage.fontSize = 16
        layer.addSublayer(percentage)
        
        let percentSign = createTextLayer(text: "%")
        percentSign.frame = CGRect(x: rect.minX + 36, y: rect.minY + 2, width: 10, height: 10)
        percentSign.font = ThemeSettings.theme.fonts.defaultFont(ofSize: 10, weight: .bold)
        percentSign.fontSize = 8
        layer.addSublayer(percentSign)
    }
    
    internal func draw() {
        
        guard needsArcDraw else { return }
        needsArcDraw = false
        
        // remove previous sublayers first
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        guard let budgetArc = arc else { return }
        
        let circleBackround = createCircle(color: ThemeSettings.theme.ratingViewBackround, in: self)
        layer.addSublayer(circleBackround)
        
        let backroundLayer = createArc(color: budgetArc.backgroundColor, in: self)
        layer.addSublayer(backroundLayer)
        
        let circleLayer = createArc(color: budgetArc.percentageColor, in: self)
        layer.addSublayer(circleLayer)
        
        var realPercentage = CGFloat(budgetArc.percentage / 100.0)
        if realPercentage == 0 {
            realPercentage = 0.0001
        }
        
        let animation = createAnimation(withDuration: animationTime, toValue: realPercentage)
        circleLayer.strokeEnd = realPercentage
        circleLayer.add(animation, forKey: "animateCircle")
        
    }

    // MARK: - Drawing methods
    
    private func createTextLayer(text: String) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.alignmentMode = .center
        textLayer.string = text
        textLayer.isWrapped = true
        textLayer.truncationMode = .end
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = UIColor.white.cgColor
        return textLayer
    }
    
    private func createCircle(color: UIColor, in view: UIView) -> CAShapeLayer {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                      radius: (frame.size.width / 2.0) + 6,
                                      startAngle: 0,
                                      endAngle: CGFloat(.pi * 2.0),
                                      clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = color.cgColor
        return circleLayer
    }

    internal func createArc(color: UIColor,
                            in view: UIView) -> CAShapeLayer {
        let frame = view.frame
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                      radius: frame.size.width / 2.0,
                                      startAngle: 0,
                                      endAngle: CGFloat(.pi * 2.0),
                                      clockwise: true)

        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = color.cgColor
        circleLayer.lineWidth = .grid(1)
        circleLayer.lineCap = CAShapeLayerLineCap.butt
        circleLayer.strokeEnd = 1
        return circleLayer
    }

    internal func createAnimation(withDuration duration: CFTimeInterval,
                                  toValue endValue: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 1
        animation.toValue = endValue
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }
}

// MARK: - Extension CGFloat

private extension CGFloat {
    static func grid(_ n: CGFloat) -> CGFloat {
        return n * 4.0
    }
}
