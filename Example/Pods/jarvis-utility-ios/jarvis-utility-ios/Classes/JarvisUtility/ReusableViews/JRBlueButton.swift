//
//  JRBlueButton.swift
//  Jarvis
//
//  Created by Sandesh Kumar on 04/01/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit

@objc public enum JRButtonType : UInt32 {
    case BackgroundColorBlue, BorderBlue, BackgroundColorOrange, BorderGray, BackgroundColorGreen, BackgroundColorGray, BackgroundColorLightOrange, //// It is being used in Your Order Screen
    BackgroundColorBlueWithCircle, BackgroundColorBlueWithOval, BorderWhite, Invoice, BorderLightGray, BlueWithRightBorderWhite, BlueWithLeftBorderWhite, DarkBlue, BackgroundColorRed, TextWithoutBorder
}
open class JRBlueButton: UIButton {
    
    //MARK: Public section
    @objc public var type: NSNumber?
    @objc public init(frame: CGRect, withType type: JRButtonType) {
        super.init(frame: frame)
        
        setValue(NSNumber(value: type.rawValue), forKey: "type")
        initializeWithType(buttonType: type)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setValue(NSNumber(value: 0), forKey: "type")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setValue(NSNumber(value: 0), forKey: "type")
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        let type = value(forKey: "type") as? NSNumber ?? NSNumber(value: 0)
        
        let buttonType = JRButtonType(rawValue: type.uint32Value)!
        initializeWithType(buttonType: buttonType)
        
    }
}


fileprivate extension JRBlueButton {
    
    func initializeWithType(buttonType: JRButtonType) {
        
        
        switch buttonType {
            
        case .BackgroundColorBlue: setupButtonBackgroundColorWithBlue()
            
        case .BackgroundColorRed: setupButtonBackgroundColorRed()
            
        case .BorderBlue: setupButtonBorderColorWithBlue()
            
        case .BackgroundColorOrange: setupButtonBackgroundColorWithOrange()
            
        case .BorderGray: setupButtonBorderColorWithGray()
            
        case .BackgroundColorGreen: setupButtonBackgroundColorWithGreen()
            
        case .BackgroundColorGray: setupButtonBackgroundColorWithGray()
            
        case .BackgroundColorLightOrange: setupButtonBackgroundColorWithLightOrange()
            
        case .BackgroundColorBlueWithCircle: setupCircleButtonBackgroundColorWithBlue()
            
        case  .BackgroundColorBlueWithOval: setupOvalButtonBackgroundColorWithBlue()
            
        case .BorderWhite: setupButtonBorderColorWithWhite()
            
        case .Invoice: setupButtonTypeInvoice()
            
            
        case .BorderLightGray: setupButtonBorderColorWithLightGray()
            
        case .BlueWithRightBorderWhite: setupBlueButtonBackgroundWithRightBorderWhite()
            
        case .BlueWithLeftBorderWhite: setupBlueButtonBackgroundWithLeftBorderWhite()
            
        case .DarkBlue: setupDarkBlueButton()
            
        case .TextWithoutBorder: setupTextWithoutBorder()
            
        }
    }
    
    func setupButtonBackgroundColorWithOrange() {
        
        setBackgroundImage(nil, for: .normal)
        titleLabel?.textAlignment = .center
        layer.backgroundColor = UIColor.paytmOrangeColor().cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
        setTitleColor(UIColor.white, for: .normal)
        
    }
    
    func setupButtonBorderColorWithBlue() {
        
        titleLabel?.textAlignment = .center
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderWidth = 0.7
        layer.cornerRadius = 4.0
        setTitleColor(UIColor.appColor(), for: .normal)
        layer.borderColor = UIColor.appColor().cgColor
    }
    
    func setupButtonBorderColorWithWhite() {
        
        titleLabel?.textAlignment = .center
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 5.0
        setTitleColor(UIColor.white, for: .normal)
    }
    
    func setupButtonBorderColorWithGray() {
        
        titleLabel?.textAlignment = .center
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 5.0
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = UIFont.helveticaNeueFontOfSize(14)
        
    }
    func setupButtonBorderColorWithLightGray() {
        
        titleLabel?.textAlignment = .center
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5.0
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = UIFont.helveticaNeueFontOfSize(14)
        
    }
    
    func setupTextWithoutBorder() {
        titleLabel?.textAlignment = .center
        let color = UIColor.clear
        setUpBackgroundColor(color)
        setTitleColor(UIColor.appColor(), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    func setupButtonBackgroundColorWithGreen() {
        
        let color = UIColor(red: 21.0 / 255.0, green: 152.0 / 255.0, blue: 62.0 / 255.0, alpha: 1)
        setUpBackgroundColor(color)
        
    }
    
    func setupButtonBackgroundColorWithGray() {
        
        let color = UIColor(red: 134.0 / 255.0, green: 134.0 / 255.0, blue: 134.0 / 255.0, alpha: 1)
        setUpBackgroundColor(color)
    }
    
    func setupButtonBackgroundColorWithLightOrange() {
        
        let color = UIColor(red: 250.0 / 255.0, green: 125.0 / 255.0, blue: 14.0 / 255.0, alpha: 1)
        setUpBackgroundColor(color)
    }
    
    func setUpBackgroundColor(_ color: UIColor) {
        
        setBackgroundImage(nil, for:.normal)
        titleLabel?.textAlignment = .center
        layer.backgroundColor = color.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 2
        titleLabel?.font = UIFont.systemFont(ofSize: 11)
        setTitleColor(UIColor.white, for: .normal)
        
    }
    
    func setupCircleButtonBackgroundColorWithBlue() {
        
        var normalImage = UIImage(named: "blue_button_generic")!
        normalImage = normalImage.stretchableImage(withLeftCapWidth: 4, topCapHeight: Int(normalImage.size.height / 2))
        setBackgroundImage(normalImage, for: .normal)
        titleLabel?.textAlignment = .center
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        contentEdgeInsets = UIEdgeInsets(top: 0.5, left: 2.0, bottom: 0.0, right: 0.0)
        layer.masksToBounds = true
        layer.cornerRadius = 11.0
        titleLabel?.font = UIFont.helveticaNeueMediumFontOfSize(12)
        setTitleColor(UIColor.white, for: .normal)
        
    }
    func setupOvalButtonBackgroundColorWithBlue() {
        
        var normalImage = UIImage(named: "blue_button_generic")!
        normalImage = normalImage.stretchableImage(withLeftCapWidth: 4, topCapHeight: Int(normalImage.size.height / 2))
        setBackgroundImage(normalImage, for: .normal)
        titleLabel?.textAlignment = .center
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        contentEdgeInsets = UIEdgeInsets(top: 0.5, left: 0.0, bottom: 0.0, right: 0.0)
        layer.masksToBounds = true
        layer.cornerRadius = 9.0
        titleLabel?.font = UIFont.helveticaNeueMediumFontOfSize(12)
        setTitleColor(UIColor.white, for: .normal)
    }
    
    func setupButtonTypeInvoice() {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 2, width: 20, height: 20))
        imageView.image = UIImage(named: "invoice")!
        imageView.contentMode = .scaleToFill
        addSubview(imageView)
        
        titleLabel?.textAlignment = .center
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        contentEdgeInsets = UIEdgeInsets(top: 0.5, left: 2.0, bottom: 0.0, right: 0.0)
        layer.masksToBounds = true
        layer.cornerRadius = 11.0
        titleLabel?.font = UIFont.helveticaNeueMediumFontOfSize(12)
        setTitleColor(UIColor.appColor(), for: .normal)
        
    }
    
    func setupDarkBlueButton() {
        
        setButtonPropertiesWithimageName("dark_blue_button_generic")
    }
    
    func setupButtonBackgroundColorWithBlue() {
        
        setButtonPropertiesWithimageName("blue_button_generic")
    }
    
    func setupButtonBackgroundColorRed() {
        
        setButtonPropertiesWithimageName("red_background_button")
    }
    //used in wallet and updates signed out screens
    func setupBlueButtonBackgroundWithLeftBorderWhite() {
        
        setButtonPropertiesWithimageName("blue_button_left_white_border")
    }
    func setupBlueButtonBackgroundWithRightBorderWhite() {
        
        setButtonPropertiesWithimageName("blue_button_right_white_border")
    }

    func setButtonPropertiesWithimageName(_ name: String) {
        
        if JRUtilityManager.shared.moduleConfig.varient == .mall{
            layer.backgroundColor = UIColor.paytmRedColor().cgColor
            
        }else{
            var normalImage = UIImage(named: name)!
            //make images stretchable
            normalImage = normalImage.stretchableImage(withLeftCapWidth: 4, topCapHeight: Int(normalImage.size.height / 2))
            
            //set background image
            setBackgroundImage(normalImage, for: .normal)
        }
        
        //set font
        titleLabel?.font = UIFont.helveticaNeueMediumFontOfSize(17.0)
        setTitleColor(UIColor.white, for: .normal)
    }
}
