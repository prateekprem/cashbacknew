//
//  ScratchView.swift
//  ScratchCard
//
//  Created by Prateek Prem on 2019/12/23.
//

import Foundation
import UIKit

struct ScratchViewConfig {
    var width: Int!
    var height: Int!
    var location: CGPoint!
    var previousLocation: CGPoint!
    var firstTouch: Bool!
    var scratched: CGImage!
    var alphaPixels: CGContext!
    var provider: CGDataProvider!
    var pixelBuffer: UnsafeMutablePointer<UInt8>!
    var couponImage: UIImage!
    var scratchWidth: CGFloat!
    var contentLayer: CALayer!
    var maskLayer: CAShapeLayer!
}


internal protocol ScratchViewDelegate: class {
    func began(_ view: ScratchView)
    func moved(_ view: ScratchView)
    func ended(_ view: ScratchView)
}

class ScratchView: UIView {
    internal var config: ScratchViewConfig = ScratchViewConfig()
    internal weak var delegate: ScratchViewDelegate!
    internal var position: CGPoint!
   
    init(frame: CGRect, CouponImage: UIImage, ScratchWidth: CGFloat) {
        super.init(frame: frame)
        config.couponImage = CouponImage
        config.scratchWidth = ScratchWidth
        self.initMe()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initMe() {
        let image = processPixels(image: config.couponImage)
        if image != nil {
            config.scratched = image?.cgImage
        } else {
            config.scratched = config.couponImage?.cgImage
        }
        let ww = self.frame.width
        let hh = self.frame.height
        
        self.isOpaque = false
        
        let colorspace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        
        let pixels: CFMutableData = CFDataCreateMutable(nil, (CFIndex(ww * hh)))
        
        config.alphaPixels = CGContext( data: CFDataGetMutableBytePtr(pixels), width: Int(ww), height: Int(hh), bitsPerComponent: 8, bytesPerRow: Int(ww), space: colorspace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        
        config.alphaPixels.setFillColor(UIColor.black.cgColor)
        config.alphaPixels.setStrokeColor(UIColor.white.cgColor)
        config.alphaPixels.setLineWidth(config.scratchWidth)
        config.alphaPixels.setLineCap(CGLineCap.round)
    
        // fix mask initialization error on simulator device(issue9)
        config.pixelBuffer = config.alphaPixels.data?.bindMemory(to: UInt8.self, capacity: Int(ww * hh))
        config.provider = CGDataProvider(data: pixels)
        
        config.maskLayer = CAShapeLayer()
        config.maskLayer.frame =  CGRect(x:0, y:0, width: ww, height: hh)
        config.maskLayer.backgroundColor = UIColor.clear.cgColor
        
        config.contentLayer = CALayer()
        config.contentLayer.frame =  CGRect(x:0, y:0, width: ww, height: hh)
        config.contentLayer.contents = config.scratched
        config.contentLayer.mask = config.maskLayer
        self.layer.addSublayer(config.contentLayer)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>,
        with event: UIEvent?) {
            if let touch = touches.first {
                config.firstTouch = true
                config.location = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y)
                
                position = config.location
                
                if self.delegate != nil {
                    self.delegate.began(self)
                }
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>,
        with event: UIEvent?) {
            if let touch = touches.first {
                if config.firstTouch! {
                    config.firstTouch = false
                    config.previousLocation =  CGPoint(x: touch.previousLocation(in: self).x, y: touch.previousLocation(in: self).y)
                } else {
                    
                    config.location = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y)
                    config.previousLocation = CGPoint(x: touch.previousLocation(in: self).x, y: touch.previousLocation(in: self).y)
                }
                
                position = config.previousLocation
                
                renderLineFromPoint(config.previousLocation, end: config.location)
                
                if self.delegate != nil {
                    self.delegate.moved(self)
                }
            }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if !config.firstTouch! {
                config.firstTouch = false
                config.previousLocation =  CGPoint(x: touch.previousLocation(in: self).x, y: touch.previousLocation(in: self).y)
                
                position = config.previousLocation
                
                renderLineFromPoint(config.previousLocation, end: config.location)
                
                if self.delegate != nil {
                    self.delegate.ended(self)
                }
            }
        }
    }
    
    func renderLineFromPoint(_ start: CGPoint, end: CGPoint) {
        config.alphaPixels.move(to: CGPoint(x: start.x, y: start.y))
        config.alphaPixels.addLine(to: CGPoint(x: end.x, y: end.y))
        config.alphaPixels.strokePath()
        drawLine(onLayer: config.maskLayer, fromPoint: start, toPoint: end)
    }
    
    func drawLine(onLayer layer: CALayer, fromPoint start: CGPoint, toPoint end: CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        linePath.lineCapStyle = .round
        line.lineWidth = config.scratchWidth
        line.path = linePath.cgPath
        line.opacity = 1
        line.strokeColor = UIColor.white.cgColor
        line.lineCap = .round
        layer.addSublayer(line)
    }
    
    internal func getAlphaPixelPercent() -> Double {
        var byteIndex: Int  = 0
        var count: Double = 0
        let data = UnsafePointer(config.pixelBuffer)
        for _ in 0...Int(self.frame.width * self.frame.height) {
            if  data![byteIndex] != 0 {
                count += 1
            }
            byteIndex += 1
        }
        return count / Double(self.frame.width * self.frame.height)
    }
    
    private func processPixels(image: UIImage) -> UIImage? {
        
        guard let inputCGImage = image.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        return outputImage
    }
}
