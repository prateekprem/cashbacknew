//
//  BSKeyboardControl.swift
//  jarvis-common-ios
//
//  Created by Deekshith Bellare on 13/05/20.
//

import Foundation
@objc public enum BSKeyboardControl: UInt8 {
    case allZeros = 0b00
    case previousNext = 0b01
    case done = 0b10
    case allButtons = 0b11        // Needed for pretty weak Swift NSOption support
}

///  Directions in which the fields can be selected.
///  These are relative to the active field.
@objc public enum BSKeyboardControlsDirection : Int {
    case previous = 0
    case next
}

@objc public class BSKeyboardControls: UIView {
    ///  Delegate to send callbacks to.
    @objc public weak var delegate: BSKeyboardControlsDelegate?
    ///  Visible controls. Use a bitmask to show multiple controls.
    public var visibleControls: BSKeyboardControl? {
        didSet {
            toolbar.items = self.toolbarItems()
        }
    }
    ///  Fields which the controls should handle.
    ///  The order of the fields is important as this determines which text field
    ///  is the previous and which is the next.
    ///  All fields will automatically have the input accessory view set to
    ///  the instance of the controls.
    @objc public var fields: [UIView]?
    ///  The active text field.
    ///  This should be set when the user begins editing a text field or a text view
    ///  and it is automatically set when selecting the previous or the next field.
    @objc public var activeField: UIView? {
        didSet {
            activeField?.becomeFirstResponder()
            updatePreviousNextEnabledStates()
        }
    }
    
    ///  Title of the previous button. If this is not set, a default localized title will be used. iOS 6 Only.
    @objc public var previousTitle: String? {
        didSet {
            segmentedControl.setTitle(previousTitle, forSegmentAt: Int(BSKeyboardControlsDirection.previous.rawValue))
        }
    }
    ///  Title of the next button. If this is not set, a default localized title will be used. iOS 6 Only.
    @objc public var nextTitle: String? {
        didSet {
            segmentedControl.setTitle(nextTitle, forSegmentAt: Int(BSKeyboardControlsDirection.next.rawValue))
        }
    }
    ///  Title of the done button. If this is not set, a default localized title will be used.
    @objc public var doneTitle: String? {
        didSet {
            doneButton.title = doneTitle
        }
    }
    ///  Tint color of the done button.
    @objc public var doneTintColor: UIColor? {
        didSet {
            doneButton.tintColor = doneTintColor
        }
    }
    
    private var toolbar: UIToolbar!
    private var segmentedControl: UISegmentedControl!
    private var leftArrowButton: UIBarButtonItem!
    private var rightArrowButton: UIBarButtonItem!
    private var doneButton: UIBarButtonItem!
    private var segmentedControlItem: UIBarButtonItem!
    
    @objc public var barStyle: UIBarStyle {
        get {return toolbar.barStyle}
        set {toolbar.barStyle = newValue}
    }
    
    @objc public var barTintColor: UIColor? {
        didSet {
            toolbar.tintColor = barTintColor
        }
    }
    ///  Tint color of the segmented control. iOS 6 Only.
    @objc public var segmentedControlTintControl: UIColor? {
        didSet {
            segmentedControl.tintColor = segmentedControlTintControl
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    // MARK: Lifecycle
    convenience init() {
        self.init(fields: nil)
    }
    
    convenience override init(frame: CGRect) {
        self.init(fields: nil)
    }
    
    ///  Initialize keyboard controls.
    ///  - Parameter fields: Fields which the controls should handle.
    ///  - Returns: Initialized keyboard controls.
    @objc public init(fields: [UIView]?) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 44.0))
        self.toolbar = UIToolbar(frame: frame)
        toolbar.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        addSubview(toolbar)
        
        backgroundColor = UIColor.white
        
        if let item = UIBarButtonItem.SystemItem(rawValue: 105) {
            self.leftArrowButton = UIBarButtonItem(barButtonSystemItem: item, target: self, action: #selector(selectPreviousField))
        }
        leftArrowButton.isEnabled = false
        if let item = UIBarButtonItem.SystemItem(rawValue: 106) {
            self.rightArrowButton = UIBarButtonItem(barButtonSystemItem: item, target: self, action: #selector(selectNextField))
        }
        rightArrowButton.isEnabled = false
        
        
        self.doneButton = UIBarButtonItem(
            title: "jr_rc_Done".localized,
            style: .done,
            target: self,
            action: #selector(doneButtonPressed(_:)))
        
        self.visibleControls = BSKeyboardControl(rawValue: BSKeyboardControl.previousNext.rawValue | BSKeyboardControl.done.rawValue)
        
        barTintColor = UIColor.appColor()
        self.fields = fields
        self.installFields()
        self.updateToolbar()
    }
    
    
    private func updateToolbar() {
        toolbar.items = toolbarItems()
    }
    private func installFields() {
        guard let fields = self.fields else {
            return
        }
        for field in fields {
            if let field = field as? UITextView {
                field.inputAccessoryView = self
            } else if let field = field as? UITextField {
                field.inputAccessoryView = self
            }
        }
    }
    
    @objc private func doneButtonPressed(_ sender: Any?) {
        delegate?.keyboardControlsDonePressed?(self)
    }
    
    
    private func updatePreviousNextEnabledStates() {
        guard let field = self.activeField, let fields = self.fields else {
            return }
        if let index = fields.firstIndex(of: field) {
            leftArrowButton.isEnabled = (index > 0)
            rightArrowButton.isEnabled = (index < fields.count - 1)
        }
    }
    
    @objc private func selectPreviousField() {
        guard let field = self.activeField, let fields = self.fields else {
            return }
        
        if var index = fields.firstIndex(of: field), index > 0 {
            index -= 1
            let field = fields[index]
            self.activeField = field
            delegate?.keyboardControls?(self, selectedField: self.activeField!, in: .previous)
        }
    }
    
    @objc private func selectNextField() {
        guard let field = self.activeField, let fields = self.fields else {
            return }
        if let index = fields.firstIndex(of: field),index < fields.count - 1  {
            activeField = fields[index + 1]
            delegate?.keyboardControls?(self, selectedField: activeField!, in: .next)
        }
    }
    
    private func toolbarItems() -> [UIBarButtonItem]? {
        guard let visibleControls = self.visibleControls else  {
            return nil
        }
        var outItems = [UIBarButtonItem]()
        
        if visibleControls.rawValue & BSKeyboardControl.previousNext.rawValue > 0 {
            outItems.append(leftArrowButton)
            outItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            outItems.append(rightArrowButton)
        }
        if visibleControls.rawValue & BSKeyboardControl.done.rawValue > 0 {
            outItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            outItems.append(doneButton)
        }
        return outItems
    }
}

extension BSKeyboardControls: UIInputViewAudioFeedback {
    func enableInputClicksWhenVisible() -> Bool {
        return true
    }
}

@objc public protocol BSKeyboardControlsDelegate: NSObjectProtocol {
    ///  Called when a field was selected by going to the previous or the next field.
    ///  The implementation of this method should scroll to the view.
    ///  - Parameters:
    ///   - keyboardControls: The instance of keyboard controls.
    ///    - field: The selected field.
    ///    - direction: Direction in which the field was selected.
    @objc optional func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView?, in direction: BSKeyboardControlsDirection)
    ///  Called when the done button was pressed.
    ///  - Parameter keyboardControls: The instance of keyboard controls.
    @objc optional func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls)
}
