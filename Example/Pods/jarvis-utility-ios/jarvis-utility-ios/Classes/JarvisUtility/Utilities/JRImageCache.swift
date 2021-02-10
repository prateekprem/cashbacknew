//
//  JRImageCache.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 31/01/19.
//  Copyright © 2019 One97. All rights reserved.
//
//  Description: Factory Wrapper for Image caching
//

import UIKit
import SDWebImage

@objc public class JRImageCacheOptions : NSObject,OptionSet {
    @objc public let rawValue: Int
    
    @objc required public override convenience init() {
        self.init(rawValue: 0)
    }
    
    @objc required public init(rawValue: Int) {
        self.rawValue = rawValue
        super.init()
    }
    
    @objc public static let retryFailed = JRImageCacheOptions(rawValue: 1 << 0)
    @objc public static let lowPriority = JRImageCacheOptions(rawValue: 1 << 1)
    @objc public static let cacheMemoryOnly = JRImageCacheOptions(rawValue: 1 << 2)
    @objc public static let progressiveDownload = JRImageCacheOptions(rawValue: 1 << 3)
    @objc public static let refreshCached = JRImageCacheOptions(rawValue: 1 << 4)
    @objc public static let continueInBackground = JRImageCacheOptions(rawValue: 1 << 5)
    @objc public static let handleCookies = JRImageCacheOptions(rawValue: 1 << 6)
    @objc public static let allowInvalidSSLCertificates = JRImageCacheOptions(rawValue: 1 << 7)
    @objc public static let highPriority = JRImageCacheOptions(rawValue: 1 << 8)
    @objc public static let delayPlaceholder = JRImageCacheOptions(rawValue: 1 << 9)
    @objc public static let transformAnimatedImage = JRImageCacheOptions(rawValue: 1 << 10)
    @objc public static let avoidAutoSetImage = JRImageCacheOptions(rawValue: 1 << 11)
    @objc public static let scaleDownLargeImages = JRImageCacheOptions(rawValue: 1 << 12)
    @objc public static let queryDataWhenInMemory = JRImageCacheOptions(rawValue: 1 << 13)
    @objc public static let queryDiskSync = JRImageCacheOptions(rawValue: 1 << 14)
    @objc public static let fromCacheOnly = JRImageCacheOptions(rawValue: 1 << 15)
    @objc public static let forceTransition = JRImageCacheOptions(rawValue: 1 << 16)
    
    public var factoryType : SDWebImageOptions{
        return SDWebImageOptions.init(rawValue: UInt(self.rawValue))
    }
}

@objc public enum JRImageCacheType : Int {
    case none
    case disk
    case memory
    
    public var factoryType : SDImageCacheType{
        return SDImageCacheType.init(rawValue: self.rawValue)!
    }
}

//factory Extensions
public extension SDWebImageOptions{
    var genericType : JRImageCacheOptions{
        get{
            return JRImageCacheOptions.init(rawValue: Int(self.rawValue))
        }
    }
}

public extension SDImageCacheType{
    var genericType : JRImageCacheType{
        get{
            return JRImageCacheType.init(rawValue: self.rawValue)!
        }
    }
}

public typealias JRImageCacheDownloadProgressBlock = (_ receivedSize : Int,_ expectedSize : Int) -> ()
public typealias JRImageCacheCompletionBlock = (_ image : UIImage?,_ error : Error?,_ cacheType : JRImageCacheType,_ imageUrl : URL?) -> ()
public typealias JRImageCacheCompletionWithFinishedBlock = (_ image : UIImage?,_ error : Error?,_ cacheType : JRImageCacheType,_ finished : Bool,_ imageUrl : URL?) -> ()

@objc public protocol JRImageCacheOperation : SDWebImageOperation {
    @objc optional func cancel()
}

@objc public class JRImageCache: NSObject {
    private override init(){}
    @objc public static var shared : JRImageCache = JRImageCache()
    
    @objc public var shouldDecompressImages : Bool = false
    @objc public func getShouldCacheImagesInMemory() -> Bool{
        return SDImageCache.shared.config.shouldCacheImagesInMemory
    }
    @objc public func setShouldCacheImagesInMemory(_ bool : Bool){
        SDImageCache.shared.config.shouldCacheImagesInMemory = bool
    }
    
    @discardableResult
    @objc public func downloadImage(with url : URL?, options: JRImageCacheOptions, progress : JRImageCacheDownloadProgressBlock?, completed : JRImageCacheCompletionWithFinishedBlock?) -> JRImageCacheOperation? {
        let operation : SDWebImageOperation? = SDWebImageManager.shared.loadImage(with: url, options: options.factoryType, progress: { (receiveSize, expectedSize, url) in
            progress?(receiveSize,expectedSize)
        }) { (image, data, error, cacheType, finished, url) in
            completed?(image,error,cacheType.genericType,finished,url)
        }
        return operation as? JRImageCacheOperation
    }
    
    @objc public func imageFromDiskCache(forKey key: String?) -> UIImage?{
        return SDImageCache.shared.imageFromDiskCache(forKey: key)
    }
    
    @objc public func diskImageExists(withKey key: String?) -> Bool{
        return SDImageCache.shared.diskImageDataExists(withKey: key)
    }
    
    @objc public func storeImageData(toDisk data: Data, forKey key: String){
        SDImageCache.shared.storeImageData(toDisk: data, forKey: key)
    }
    
    @objc public func cleanDisk(){
        SDImageCache.shared.clearDisk {}
    }
    
    @objc public func cleanMemory(){
        SDImageCache.shared.clearMemory()
    }
    
}

//MARK: Extension Button
public extension UIButton{
    
    @objc func jr_setBackgroundImage(with url : URL?,for state : UIControl.State){
        self.sd_setBackgroundImage(with: url, for: state)
    }
    
    @objc func jr_setImage(with url: URL?, forState state: UIControl.State, placeholderImage placeholder: UIImage?, completed:JRImageCacheCompletionBlock?){
        self.sd_setImage(with: url, for: state, placeholderImage: placeholder, options: [.avoidDecodeImage], context: nil, progress: nil) { (image, error, cacheType, url) in
            completed?(image,error,cacheType.genericType,url)
        }
    }
    
}

//Extension: Extension ImageView
public extension UIImageView{
    
    //MARK: IMAGE METHODS
    @objc func jr_setImage(with url : URL?){
        self.jr_setImage(with: url, placeholderImage: nil, options: JRImageCacheOptions(), completed : nil)
    }
    
    @objc func jr_setImage(with url: URL?, placeholderImage placeholder: UIImage?){
        self.jr_setImage(with: url, placeholderImage: placeholder, options: JRImageCacheOptions(), completed : nil)
    }
    
    @objc func jr_setImage(with url: URL?, completed : JRImageCacheCompletionBlock?){
        self.jr_setImage(with: url, placeholderImage: nil, options: JRImageCacheOptions(), completed : completed)
    }
    
    @objc func jr_setImage(with url : URL?, placeholderImage placeholder: UIImage?, completed : JRImageCacheCompletionBlock?){
        self.jr_setImage(with: url, placeholderImage: placeholder, options: JRImageCacheOptions(), completed : completed)
    }
    
    @objc func jr_setImage(with url : URL?, placeholderImage placeholder : UIImage?, options: JRImageCacheOptions,completed : JRImageCacheCompletionBlock?){
        if let url = url{
            self.sd_setImage(with: url, placeholderImage: placeholder, options: [.avoidDecodeImage, options.factoryType], context: nil, progress: nil) { (image, error, cacheType, url) in
                completed?(image,error,cacheType.genericType,url)
            }
        }
    }
    
    func updateUrl(forUrl url : URL, andFrame frame : CGRect) -> URL?{
        //This method is no longer used, Previously it was used to download smaller size images based on frame size
        var returnUrl : URL = url
        func getQueryStringParameter(url: String?, param: String) -> String? {
            if let url = url, let urlComponents = URLComponents(string: url), let queryItems = (urlComponents.queryItems), queryItems.count > 0 {
                return queryItems.first(where: { $0.name == param })?.value
            }
            return nil
        }
        
        let baseUrl : String = url.absoluteString
        if baseUrl.contains(find: "imwidth") && baseUrl.contains(find: "width"){
            var scalingFactor : Double = 1.0
            if let weexScalingFactor : String = ModuleRouter.getManager(forModule: .common)?.common_getWeexScalingFactoriOS(), let value = Double(weexScalingFactor){
                scalingFactor = value
            }
            if let _ = getQueryStringParameter(url: baseUrl, param: "isScalingRequired"){
                let width = ceil(frame.size.width)/CGFloat(scalingFactor)
                if width > 0{
                    if let range : Range = baseUrl.range(of: "?"){
                        let param : String = baseUrl.distance(from: range.lowerBound, to: range.upperBound) > 0 ? "&" : "?"
                        let imageString = String.init(format: "%@%@imwidth=%d", baseUrl,param, width)
                        if let url = URL.init(string: imageString){
                            returnUrl = url
                        }
                    }
                }
            }
        }
        return returnUrl
    }
    
    @objc func jr_cancelCurrentImageLoad(){
        self.sd_cancelCurrentImageLoad()
    }
    
    //MARK: INDICATOR METHODS
    @objc func jr_setIndicatorStyle(_ style : UIActivityIndicatorView.Style){
        switch style {
        case .gray:
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        case .white:
            self.sd_imageIndicator = SDWebImageActivityIndicator.white
        case .whiteLarge:
            self.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        default:
            self.sd_imageIndicator = SDWebImageActivityIndicator.init()
        }
    }
    
    @objc func jr_setShowActivityIndicator(_ bool : Bool){
        if bool{
            self.sd_imageIndicator?.startAnimatingIndicator()
        }else{
            self.sd_imageIndicator?.stopAnimatingIndicator()
        }
    }
}

//MARK: OLD METHODS
public extension UIImageView{
    
    /**
     Method to setImage from given URL
     */
    @objc func setImageFromUrlPath(_ urlPath: String) {
        setImageFromUrlPath(urlPath, withConstrainedWidth: self.frame.size.width)
    }
    
    /**
     Method to setImage from given URL
     */
    func setImageFromUrlPath(_ urlPath: String, withConstrainedWidth width: CGFloat) {
        
        setImageFromUrlPath(urlPath, withConstrainedWidth: width, handler: nil)
    }
    
    /**
     Method to setImage from given URL with handler
     */
    @objc func setImageFromUrlPath(_ urlPath: String, withConstrainedWidth width: CGFloat, handler: JRImageCacheCompletionBlock?) {
        setImageFromUrlPath(urlPath, withConstrainedWidth: width, layout: true, handler: handler)
    }
    
    func addImageFrom(urlStr: String, placeHolder: UIImage?) {
        if urlStr.count > 0 {
            if let url = URL(string: urlStr) {
                if let placeH = placeHolder {
                    self.jr_setImage(with: url, placeholderImage: placeH)
                    
                } else {
                    self.jr_setImage(with: url, completed: { (img, err, cacheType, url1) in
                    })
                }
            }
        }
    }
    
    func setImageFromUrlPath(_ urlPath: String, withConstrainedWidth width: CGFloat, layout:Bool, handler: JRImageCacheCompletionBlock?) {
        
        if let urlStr = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            jr_setImage(with:  URL(string: urlStr), completed: handler)
        }
    }
    
    /**
     Method to setImage with placeholder image from given URL
     */
    @objc func setImageFromUrlPath(_ urlPath: String, placeHolderImageName name: String?) {
        
        setImageFromUrlPath(urlPath, withConstrainedWidth: self.frame.size.width, placeHolderImageName: name)
    }
    
    /**
     Method to setImage with placeholder from given URL
     */
    func setImageFromUrlPath(_ urlPath: String, withConstrainedWidth width: CGFloat, placeHolderImageName name: String?) {
        
        setImageFromUrlPath(urlPath, withConstrainedWidth: width, placeHolderImageName: name, handler: nil)
    }
    
    
    func setImageFromUrlPath(_ urlPath: String, withConstrainedWidth width: CGFloat, placeHolderImageName: String?, handler: JRImageCacheCompletionBlock?) {
        
        var placeHolderImage: UIImage?
        if let placeHolderImageName = placeHolderImageName {
            placeHolderImage = UIImage(named: placeHolderImageName)
        }
        
        if let urlStr = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            jr_setImage(with: URL(string: urlStr), placeholderImage: placeHolderImage, completed: handler)
        }
    }
    
}

