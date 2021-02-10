//
//  JRPrefixTextField.swift
//  Jarvis
//
//  Created by Alok Rao on 19/07/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit
import jarvis_utility_ios

open class JRPrefixTextField: JVFloatLabeledTextField {
    @IBInspectable open var showClearButton : Bool = true
    
    @objc open var prefixText = ""
    fileprivate var isPrefixInserted:Bool = false
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    open override func layoutSubviews() {
        super.layoutSubviews()
        if showClearButton{
            clearButtonMode = .whileEditing
        }else{
            clearButtonMode = .never
        }
    }

    
    override open var delegate:UITextFieldDelegate? {
        didSet {
            prefixTextFieldDelegate = delegate
            super.delegate = self
        }
    }
    
    override open var text: String? {
        get {
            var textString:NSString? = ""
            
            if let text = super.text, text.hasPrefix(prefixText) {
                textString = NSString(string: text)
                let prefixLength = (prefixText as NSString).localizedStandardRange(of:prefixText).length
                textString = textString!.substring(from: prefixLength) as NSString?
            } else if let text = super.text {
                textString = NSString(string: text)
            }
            
            return textString as String?
        }
        
        set(newText) {
            
            if let sText = super.text, sText == prefixText && (newText == nil || newText?.length == 0) {
                // ignore this case
            } else {
                super.text = getWholeText(newText)
            }
        }
    }
    
    var textWithPrefix: String? {
        get {
            var textString:String? = text
            
            if isPrefixInserted {
                textString = prefixText + text!
            }
            
            return textString
        }
    }
    
    fileprivate weak var prefixTextFieldDelegate:UITextFieldDelegate?
    
    fileprivate func getWholeText(_ newText:String?) -> String? {
        
        var wholeText:String?
        
        if let newText = newText {
            let textString:NSString = NSString(string: newText)
            if textString.hasPrefix(prefixText) == false {
                wholeText = prefixText + newText
                isPrefixInserted = true
            } else {
                wholeText = newText
            }
        } else {
            wholeText = prefixText
            isPrefixInserted = true
        }
        
        return wholeText
    }
    
    open var hasAnyText:Bool{
        get{
            if let length = self.text?.length, length > 0 {
                return true
            }else if prefixText.length > 0 {
                return true
            }
            return false
        }
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        if hasAnyText {
            let x = bounds.origin.x
            let y = bounds.origin.y + (floatingLabel.font.lineHeight + placeholderYPadding)
            let width = bounds.size.width - 30 //for text search icon
            let height = bounds.size.height - (floatingLabel.font.lineHeight + placeholderYPadding)
            return CGRect(x:x,y:y,width:width,height:height)
        }
        return super.editingRect(forBounds: bounds)
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        if hasAnyText {
            let x = bounds.origin.x
            let y = bounds.origin.y + (floatingLabel.font.lineHeight + placeholderYPadding)
            let width = bounds.size.width
            let height = bounds.size.height - (floatingLabel.font.lineHeight + placeholderYPadding)
            return CGRect(x:x,y:y,width:width,height:height)
        }
        return super.textRect(forBounds: bounds)
    }
    
    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.x  = rect.origin.x - 5
        if let floatingLabel = floatingLabel {
            rect.origin.y = rect.origin.y + (floatingLabel.font.lineHeight + placeholderYPadding)/2
        }
        else {
            rect.origin.y = rect.origin.y + placeholderYPadding/2
        }
        return rect
    }
}

extension JRPrefixTextField : UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var shouldBeginEditing:Bool = true
        
        if let prefixTextFieldDelegate = prefixTextFieldDelegate, prefixTextFieldDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldBeginEditing(_:))) {
            shouldBeginEditing = (prefixTextFieldDelegate.textFieldShouldBeginEditing!(textField))
        }
        
        return shouldBeginEditing
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let prefixTextFieldDelegate = prefixTextFieldDelegate, prefixTextFieldDelegate.responds(to: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:))) {
            prefixTextFieldDelegate.textFieldDidBeginEditing!(textField)
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let prefixTextFieldDelegate = prefixTextFieldDelegate, prefixTextFieldDelegate.responds(to: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:))) {
            prefixTextFieldDelegate.textFieldDidEndEditing!(textField)
        }
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        var shouldClear:Bool = true
        
        if let prefixTextFieldDelegate = prefixTextFieldDelegate, prefixTextFieldDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldClear(_:))) {
            shouldClear = (prefixTextFieldDelegate.textFieldShouldClear!(textField))
        }
        
        if shouldClear {
            super.text = nil
            super.insertText(prefixText)
        }
        
        return false
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        var shouldEndEditing:Bool = true
        
        if let prefixTextFieldDelegate = prefixTextFieldDelegate, prefixTextFieldDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:))) {
            shouldEndEditing = (prefixTextFieldDelegate.textFieldShouldEndEditing!(textField))
        }
        
        return shouldEndEditing
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldChange:Bool = true
        
        let sel = #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))
        let textStr:String = NSString(string:super.text!).replacingCharacters(in: range, with: string) as String
        
        if isPrefixInserted && prefixText != "" && textStr.hasPrefix(prefixText) == false {
            shouldChange = false
        } else if let prefixTextFieldDelegate = prefixTextFieldDelegate, prefixTextFieldDelegate.responds(to: sel) {
            
            var newRange:NSRange = range
            
            if true == isPrefixInserted {
                let prefixLength = (prefixText as NSString).localizedStandardRange(of:prefixText).length
                newRange = NSRange(location: range.location - prefixLength, length: range.length)
            }
            
            shouldChange = (prefixTextFieldDelegate.textField!(textField, shouldChangeCharactersIn:newRange, replacementString:string))
        }
        
        if (shouldChange && isPrefixInserted == false) {
            if textStr != self.text {
                super.text = nil
                super.insertText(getWholeText(textStr)!)
                shouldChange = false
            }
        }
        
        return shouldChange
    }
}

open class JRCountryCodePrefixTextField: JRPrefixTextField {
    
    open var maxCharacters:Int = 10
    private let countryCode: String = "+91"
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prefixText = "\(countryCode) "
    }
    
    open override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldChange:Bool = true
        
        let sel = #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))
        
        let unformattedString = unformattedPhoneNumberString(string)
        let textStr:String = NSString(string:textWithPrefix!).replacingCharacters(in: range, with: unformattedString) as String
        
        if false == string.isEmpty, maxCharacters > 0 && textStr.length > (maxCharacters + prefixText.length) {
            shouldChange = false
        } else if isPrefixInserted && prefixText != "" && textStr.hasPrefix(prefixText) == false {
            shouldChange = false
        } else if let prefixTextFieldDelegate = prefixTextFieldDelegate, prefixTextFieldDelegate.responds(to: sel) {
            
            var newRange:NSRange = range
            
            if true == isPrefixInserted {
                let rangeLength = (range.location - prefixText.length) > 0 ? (range.location - prefixText.length) : 0
                newRange = NSRange(location: rangeLength, length: range.length)
            }
            
            shouldChange = (prefixTextFieldDelegate.textField!(textField, shouldChangeCharactersIn:newRange, replacementString:unformattedString))
        }
        
        if (shouldChange && (isPrefixInserted == false || unformattedString.length != string.length)) {
            if textStr != self.text {
                text = getWholeText(textStr)!
                sendActions(for: .editingChanged)
                shouldChange = false
            }
        }
        
        return shouldChange
    }
    
    func unformattedPhoneNumberString(_ formmattedNumberString:String) -> String {
        var formmattedNumberString = excludeCountryCode(from: formmattedNumberString)
        let toExclude:CharacterSet = CharacterSet(charactersIn: "0123456789").inverted
        let components:NSArray = (formmattedNumberString as NSString).components(separatedBy: toExclude) as NSArray
        let unformattedString = components.componentsJoined(by: "")
        return unformattedString
    }
    
    func excludeCountryCode(from number: String) -> String {
        var number = number.replacingOccurrences(of: countryCode, with: "")
        number = number.replacingOccurrences(of: " ", with: "")
        return number
    }
}

open class JRGenericPrefixTextField: UITextField, UITextFieldDelegate {
    open var maxCharacters:Int = 10
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func addPrefix(_ prefix: String) {
        var font = UIFont.systemFont(ofSize: 21, weight: .bold)
        if let fontForTextField = super.font {
            font = fontForTextField
        }
        
        let width = prefix.widthOfString(usingFont: font)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        label.text = prefix
        label.font = font
        leftView = label
        leftViewMode = .whileEditing
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldChange: Bool = true
        
        if false == string.isEmpty, maxCharacters > 0 && string.length > maxCharacters {
            shouldChange = false
        }
        
        return shouldChange
    }
}
