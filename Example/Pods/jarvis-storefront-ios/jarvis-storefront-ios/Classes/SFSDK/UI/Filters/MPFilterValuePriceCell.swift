//
//  MPFilterValuePriceCell.swift
//  marketplace-ios
//
//  Created by Shikha Sharma on 24/07/19.
//

import UIKit

class MPFilterValuePriceCell: UITableViewCell {
    @IBOutlet weak private var priceFromTextField: UITextField!
    @IBOutlet weak private var priceToTextField: UITextField!
    @IBOutlet weak private var priceSlider: RangeSeekSlider!
    var priceValueUpdatedBlock:((Int,Int)-> Void)?
    var showAlert:((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createLeftTextFieldView(txtField: priceFromTextField)
        createLeftTextFieldView(txtField: priceToTextField)
        priceSlider.delegate = self
        priceFromTextField.doneAccessory = true
        priceToTextField.doneAccessory = true
    }
    
    private func createLeftTextFieldView(txtField: UITextField){
        let outerView = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: 15, height: 15))
        let leftPrefixView = UILabel.init(frame: CGRect(x: 5, y: 0.0, width: 15, height: 15))
        leftPrefixView.text = NSLocalizedString("Rs", comment: "")
        leftPrefixView.font = UIFont.systemFont(ofSize: 12)
        leftPrefixView.textColor = UIColor(hex:"506D85")
        outerView.addSubview(leftPrefixView)
        txtField.leftView = outerView
        txtField.leftViewMode = .always
    }
    
    func configurePriceCell(filter: SFFilter){
        if filter.values.count > 0 {
            setMinMaxPriceValue(value: filter.values.first, isApplied: false)
        }
        if filter.appliedFiltersArray.count > 0 {
            setMinMaxPriceValue(value: filter.appliedFiltersArray.first, isApplied: true)
        }
    }
    
    private func setMinMaxPriceValue(value: SFFilterValue?, isApplied:Bool) {
        if let price = value?.minPrice {
            if !isApplied {
                priceSlider.minValue = CGFloat(Float(price))
            }
            priceFromTextField.text = String(describing: price)
            priceSlider.selectedMinValue = CGFloat(Float(price))
        }
        if let price = value?.maxPrice {
            if !isApplied {
                priceSlider.maxValue = CGFloat(Float(price))
            }
            priceToTextField.text = String(describing: price)
            priceSlider.selectedMaxValue = CGFloat(Float(price))
        }
        priceSlider.layoutSubviews()
    }
}


extension MPFilterValuePriceCell: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === priceSlider {
            priceFromTextField.text = String(describing: Int(minValue))
            priceToTextField.text = String(describing: Int(maxValue))
        }
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        priceValueUpdatedBlock?(Int(slider.selectedMinValue),Int(slider.selectedMaxValue))
    }
}

extension MPFilterValuePriceCell: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField.text?.count == 0 {
            showAlert?("Price value cannot be blank")
        } else if let text = textField.text, text.contain(subStr:".") {
            showAlert?("Please enter valid price")
        } else if let priceText = textField.text , let price = Int(priceText) {
            if (price < Int(priceSlider.minValue)) || (price > Int(priceSlider.maxValue)){
                showAlert?("Enter the price range value between \(Int(priceSlider.minValue)) and \(Int(priceSlider.maxValue))")
            }else if textField == priceFromTextField ,let ToPriceText = priceToTextField.text, let ToPrice = Int(ToPriceText), price > ToPrice{
                showAlert?("Enter the price lesser than \(Int(priceSlider.selectedMaxValue))")
            }else if textField == priceToTextField ,let fromPriceText = priceFromTextField.text, let fromPrice = Int(fromPriceText), price < fromPrice{
                showAlert?("Enter the price greater than \(Int(priceSlider.selectedMinValue))")
            }
            else {
                if textField == priceToTextField {
                    if let fromPriceString = priceFromTextField.text, let fromPrice = Int(fromPriceString) , let toPriceString = textField.text , let toPrice = Int(toPriceString) {
                        priceValueUpdatedBlock?(fromPrice,toPrice)
                    }
                }else if let fromPriceString = textField.text, let fromPrice = Int(fromPriceString) , let toPriceString = priceToTextField.text , let toPrice = Int(toPriceString) {
                    priceValueUpdatedBlock?(fromPrice,toPrice)
                }
            }
        }
        else {
            showAlert?("Please enter valid price")
        }
    }
}
