//
//  CustomSegmentedControl.swif
//
//
//  Created by Prateek Prem on 05/09/20.
//

import UIKit
protocol CustomSegmentedControlDelegate:class {
    func change(to index:Int)
}

enum SelectorViewType: Int {
    case full
    case centered
}

class CustomSegmentedControl: UIView {
    private var buttonTitles:[String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    private var font: UIFont!
    private var selectedFont: UIFont!

    var textColor:UIColor = .black
    var selectorViewColor: UIColor = .red
    var selectorTextColor: UIColor = .red
    var selectorViewType: SelectorViewType = .centered
    weak var delegate:CustomSegmentedControlDelegate?
    
    public private(set) var selectedIndex : Int = 0
    
    convenience init(frame:CGRect,buttonTitle:[String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()

        UIView.animate(withDuration: 0.2) {
            if self.selectorViewType == .centered {
                self.selectorView.frame.origin.x =  (self.frame.width/CGFloat(self.buttonTitles.count))/4
            }
        }
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    func setButtonFont(buttonFont: UIFont){
        self.font = buttonFont
        self.updateView()
    }
    
    func setSelectedButtonFont(buttonFont: UIFont){
        self.selectedFont = buttonFont
    }
    func setIndex(index:Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            if self.selectorViewType == .centered {
                self.selectorView.frame.origin.x = selectorPosition  + (self.frame.width/CGFloat(self.buttonTitles.count))/4
            } else {
                self.selectorView.frame.origin.x = selectorPosition
            }
        }
    }
    
    @objc func buttonAction(sender:UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    if self.selectorViewType == .centered {
                        self.selectorView.frame.origin.x = selectorPosition  + (self.frame.width/CGFloat(self.buttonTitles.count))/4
                    } else {
                        self.selectorView.frame.origin.x = selectorPosition
                    }
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}

//Configuration View
extension CustomSegmentedControl {
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        if selectorViewType == .full {
            selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
        } else {
            selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth/2, height: 2))
        }
        
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font =  self.font
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    
}
