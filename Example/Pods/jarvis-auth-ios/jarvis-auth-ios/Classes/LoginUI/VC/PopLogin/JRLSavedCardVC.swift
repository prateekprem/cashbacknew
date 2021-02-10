//
//  JRLSavedCardVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 21/04/20.
//

import UIKit

class JRLCardCell:UITableViewCell{
    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var textLbl: UILabel!
    var callbackClosure: (() -> Void)?
    
    var isCardSelected: Bool = false {
        didSet {
            radioBtn.isSelected = self.isCardSelected
        }
    }
    // Configure the cell here
    func configure(callbackClosure: (() -> Void)?) {
        self.callbackClosure = callbackClosure
    }
    @IBAction fileprivate func actionPressed(_ sender: Any) {
        guard let closure = callbackClosure else { return }
        closure()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension String {
    func characterAtIndex(index: Int) -> Character? {
        var cur = 0
        for char in self {
            if cur == index {
                return char
            }
            cur = cur+1
        }
        return nil
    }
}


protocol MyTextFieldDelegate: AnyObject {
    func textFieldDidDelete(textField:JRTextField)
}
protocol JRLUnitTextFieldDelegate: AnyObject {
    func textDidEndEditing()
}

class JRTextField:UITextField{
    weak var myDelegate: MyTextFieldDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete(textField:self)
    }
}

class JRLUnitTextField : UIView, UITextFieldDelegate, MyTextFieldDelegate{
    let baseTag = 100
    let units : Int
    let combinedUnits : Int
    var alreadyReturned = false
    var resultString:String = "xxxxxxxxxxxxxxxx"
    var placeholder:String = "x"
    var firstTextField:UITextField!
    weak var delegate: JRLUnitTextFieldDelegate?

    init(units: Int, combinedUnits: Int, frame : CGRect) {
        self.units = units
        self.combinedUnits = combinedUnits
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize(){
        var x:CGFloat = 0.0
        let y:CGFloat = 0.0
        let width:CGFloat = self.frame.size.width / CGFloat((self.units + self.combinedUnits))
        let height:CGFloat = 1.0 * self.frame.size.height
        let spacing:CGFloat = width / CGFloat((self.units - self.combinedUnits))
        for i in 1...units {
            let myField: JRTextField = JRTextField(frame:CGRect(x:x, y:y, width:width, height:height))
            myField.borderStyle = .none
            myField.textAlignment = .center
            myField.backgroundColor = UIColor.clear
            myField.placeholder = placeholder
            myField.delegate = self
            myField.myDelegate = self
            self.addSubview(myField)
            myField.keyboardType = .numberPad
            myField.font = UIFont.boldSystemFont(ofSize: 13)
            myField.tag = baseTag + i
            if (i % 4 == 0 && self.units == 16) || (i == units-combinedUnits){
                x = x+width+width
                continue
            }else{
                x = x+width+spacing
            }
        }
    }
    
    func makeFirstResponder(){
        firstTextField.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JRLUnitTextField{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        let tag = textField.tag - 100
        if newString == ""{
            resultString = resultString.prefix(tag-1) + "x" + resultString.dropFirst(tag)
            alreadyReturned = true
            return true
        }
        if newString.length <= maxLength{
            resultString = String(resultString.prefix(tag-1) + Substring(newString as String) + resultString.dropFirst(tag))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let view = self.viewWithTag(textField.tag + 1), view.isKind(of: UITextField.self){
                if view.isUserInteractionEnabled == false {
                    self.delegate?.textDidEndEditing()
                }
                else{
                    view.becomeFirstResponder()
                }
            }
        }
        return newString.length <= maxLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidDelete(textField:JRTextField){
        if alreadyReturned{
            alreadyReturned = false
        }else{
            if let view = self.viewWithTag(textField.tag - 1), let textField = view as? UITextField{
                textField.text = ""
                let tag = view.tag - 100
                resultString = resultString.prefix(tag-1) + "x" + resultString.dropFirst(tag)
                view.becomeFirstResponder()
            }
        }
    }
}

class JRLSavedCardVC: JRAuthBaseVC, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,JRLUnitTextFieldDelegate {
    
    var dataModel: JRLOtpPsdVerifyModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    
    var cardList = [String]()
    var preSelectedCardIndex: IndexPath?
    
    var verifierId = ""
    var fallbackTextField: UITextField!
    var dateField : JRTextField!
    var yearField : JRTextField!

    
    @IBAction func onBackBtnTouched(_ sender: UIButton) {
        goBack()
    }
    
    private func goBack(){
        if let model = dataModel, model.isLoginFlow {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    private func showAlertWithBack(message: String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "jr_login_ok".localized, style: UIAlertAction.Style.default, handler: { action in
           self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onCloseBtnTouched(_ sender: Any) {
        hideView(false)
        fallbackTextField.removeFromSuperview()
        dateField.removeFromSuperview()
        yearField.removeFromSuperview()

        if let index = preSelectedCardIndex, let cell = tableView.cellForRow(at: index) as? JRLCardCell {
            cell.isCardSelected = false
        }
        preSelectedCardIndex = nil
    }
    
    @IBAction func onConfirmBtnTouched(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        if (areInputsValid()){
            invokeVerifyCardDetailsPI()
        }
    }
    func textDidEndEditing() {
       dateField.becomeFirstResponder()
    }
    
    func areInputsValid() -> Bool{
        if fallbackTextField.text == "" {
            self.showError(text: "jr_login_enter_card_number".localized)
            return false
        }
        if let text = fallbackTextField.text, isStringContainsOnlyNumbers(string:text) == false{
            self.showError(text: "jr_login_enter_valid_card_number".localized)
            return false
        }
        if dateField.text?.isEmpty == true{
            self.showError(text: "jr_login_enter_month".localized)
            return false
        }
        if let value = dateField.text?.intValue, value <= 0{
            self.showError(text: "jr_login_enter_valid_month".localized)
            return false
        }
        if let value = dateField.text?.intValue, value > 12{
            self.showError(text: "jr_login_enter_valid_month".localized)
            return false
        }
        if yearField.text?.isEmpty == true{
            self.showError(text: "jr_login_enter_year".localized)
            return false
        }
        if let value = yearField.text?.intValue, value <= 0{
            self.showError(text: "jr_login_enter_valid_year".localized)
            return false
        }
        return true
    }
    
    func isStringContainsOnlyNumbers(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.dismissKeyboardOnTap()
        loadingIndicatorView.isHidden = true
        tableView.tableFooterView = UIView()
        hideView(false)
        
    }
    
    private func addCardView(cardDigit: Int){
        fallbackTextField = UITextField(frame: CGRect(x: 20.0, y: 0.28*cardView.frame.size.height, width: 0.80 * cardView.frame.size.width, height: 0.125 * cardView.frame.size.height))
        fallbackTextField.backgroundColor = UIColor.clear
        fallbackTextField.delegate = self
        fallbackTextField.keyboardType = .numberPad
        cardView.addSubview(fallbackTextField)
        
        dateField = JRTextField(frame:CGRect(x:20, y:0.71*cardView.frame.size.height, width:40, height:0.125 * cardView.frame.size.height))
        dateField.borderStyle = .none
        dateField.textAlignment = .center
        dateField.backgroundColor = UIColor.clear
        dateField.placeholder = "mm"
        dateField.delegate = self
        cardView.addSubview(dateField)
        dateField.keyboardType = .numberPad
        dateField.font = UIFont.boldSystemFont(ofSize: 13)
        
        let label = UILabel()
        label.frame = CGRect(x:60, y:0.7*cardView.frame.size.height, width:8, height:0.125 * cardView.frame.size.height)
        label.text = "/"
        label.backgroundColor = .clear
        cardView.addSubview(label)
        
        yearField = JRTextField(frame:CGRect(x:72, y:0.71*cardView.frame.size.height, width:80, height:0.125 * cardView.frame.size.height))
        yearField.borderStyle = .none
        yearField.textAlignment = .left
        yearField.backgroundColor = UIColor.clear
        yearField.placeholder = "yy"
        yearField.delegate = self
        cardView.addSubview(yearField)
        yearField.keyboardType = .numberPad
        yearField.font = UIFont.boldSystemFont(ofSize: 13)
        dateField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        yearField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        
        dropShadow(onView:cardView, color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 5, scale: true)
        
        fallbackTextField.text = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let maskPath = UIBezierPath(roundedRect: popupView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        popupView.layer.mask = shape
    }
    
    static func controller(_ dataModel: JRLOtpPsdVerifyModel) -> JRLSavedCardVC {
        let vc = UIStoryboard.init(name: "JRLOTPViaEmail", bundle: JRLBundle).instantiateViewController(withIdentifier: "JRLSavedCardVC") as! JRLSavedCardVC
        vc.dataModel = dataModel
        return vc
    }
    
    // OUTPUT 2
    func dropShadow(onView view:UIView , color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        view.layer.cornerRadius = radius
        let shadowPath = UIBezierPath.init(roundedRect: view.bounds, cornerRadius: radius)
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.init(white: 0, alpha: 0.14).cgColor
        view.layer.shadowOffset = CGSize(width: -1, height: 0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowPath = shadowPath.cgPath
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        if text?.utf16.count == 2{
            switch textField{
            case dateField:
                yearField.becomeFirstResponder()
            case yearField:
                yearField.resignFirstResponder()
            default:
                break
            }
        }
        else if text?.utf16.count == 0, textField == yearField  {
           dateField.becomeFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fallbackTextField {
            guard !string.isEmpty else { return true }
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered
        }
        let maxLength = 2
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    private func bringView(_ animated:Bool){
        var duration = 0.0
        if animated{
            duration = 0.3
        }
        self.bgView.backgroundColor = UIColor.clear
        self.bgView.isHidden = false
        self.bgView.frame.origin.y = self.bgView.frame.size.height
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.bgView.backgroundColor = LOGINCOLOR.blackBgWithAlpha70
            self.bgView.backgroundColor = UIColor.clear
            self.bgView.frame.origin.y = 0
        }, completion: { _ in
            self.bgView.backgroundColor = LOGINCOLOR.blackBgWithAlpha70
            self.bgView.frame.origin.y = 0
            self.fallbackTextField.becomeFirstResponder()
        })
    }
    
    private func hideView(_ animated:Bool){
        var duration = 0.0
        if animated{
            duration = 0.3
        }
        self.bgView.frame.origin.y = 0
        self.bgView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.bgView.frame.origin.y = self.bgView.frame.size.height
            self.bgView.isHidden = true
        }, completion: { _ in
            self.bgView.frame.origin.y = self.bgView.frame.size.height
            self.bgView.isHidden = true
            self.view.endEditing(true)
        })
    }
    
}

extension JRLSavedCardVC{
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell: JRLCardCell = cell as? JRLCardCell else { return }
        cell.configure(callbackClosure: { [weak self] in
            self?.buttonAction(indexPath: indexPath)
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JRLCardCell", for: indexPath) as! JRLCardCell
        let string = cardList[indexPath.row]
        let endIndex = string.index(string.startIndex, offsetBy: 5)
        let range = string.startIndex...endIndex
        let updatedText = string.replacingCharacters(in: range, with: "XXXXXX")
        cell.textLbl.text = updatedText
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if bgView.isHidden == true {
            handleCardSelection(tableView, indexPath)
        }
    }
    func buttonAction(indexPath: IndexPath) {
        // do your actions here
        handleCardSelection(tableView, indexPath)
    }
    fileprivate func handleCardSelection(_ tableView: UITableView, _ indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? JRLCardCell {
            cell.isCardSelected = true
        }
        if let index = preSelectedCardIndex, let cell = tableView.cellForRow(at: index) as? JRLCardCell {
            cell.isCardSelected = false
        }
        preSelectedCardIndex = indexPath
        let string = cardList[indexPath.row]
        addCardView(cardDigit: string.count)
        bringView(true)
        let endIndex = string.index(string.startIndex, offsetBy: 5)
        let range = string.startIndex...endIndex
        _ = string.replacingCharacters(in: range, with: "xxxxxx")
        dateField.text = ""
        yearField.text = ""
    }
    
}

//MARK:- Keyboard notification delegates
extension JRLSavedCardVC{
    @objc override func keyboardWillShow(notification:Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            var safeAreaBottomInset: CGFloat = 0;
            if #available(iOS 11.0, *) {
                safeAreaBottomInset = view.safeAreaInsets.bottom
            }
            viewBottomConst.constant = keyboardSize.height - safeAreaBottomInset
        }
    }
    
    @objc override func keyboardWillHide(notification:Notification){
        viewBottomConst.constant = 0
    }
}

//MARK:- APIs
extension JRLSavedCardVC{
    func invokeVerifyCardDetailsPI() {
        guard let dataModel = dataModel, let _ = dataModel.loginId else {
            return
        }
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        view.isUserInteractionEnabled = false
        
        let month = dateField.text
        let year = yearField.text
        let params = ["meta" : ["verifyId":  verifierId],
                      "cardNo" : fallbackTextField.text ?? "",
                      "cardExpiryMonth" : month as Any,
                      "cardExpiryYear": year as Any] as [String : Any]
        JRLServiceManager.cardDetails(params) { [weak self] (data,error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                self?.loadingIndicatorView.isHidden = true
                self?.view.isUserInteractionEnabled = true
                if error != nil {
                    if let message = error?.localizedDescription {
                        weakSelf.showError(text: message)
                    } else {
                        weakSelf.showError(text: JRLoginConstants.generic_error_message)
                    }
                    return
                }
                if let responseData = data, let status = responseData[LOGINWSKeys.kStatus] as? String,let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    if status == "SUCCESS", responseCode == "01" {
                        weakSelf.invokeFullFillAPI()
                    }
                    else if responseCode == "02", let message = responseData[LOGINWSKeys.kMesssage] as? String {
                       weakSelf.showError(text: message)
                    }
                    else if status == "FAILURE", let message = responseData[LOGINWSKeys.kMesssage] as? String{
                        if responseCode == "414" || responseCode == "500" || responseCode == "400" || responseCode == "402"{
                            weakSelf.showAlertWithBack(message: message)
                        }
                        else{
                            weakSelf.showError(text: message)
                        }
                    }
                }
                else {
                    weakSelf.showError(text: "jr_login_server_error".localized)
                }
            }
        }
    }
    
    func invokeFullFillAPI() {
        guard self.isNetworkReachable() else { return }
        
        guard let dataModel = dataModel, let stateToken = dataModel.stateToken else {
            return
        }
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        view.isUserInteractionEnabled = false
        let params: [String: String] = ["stateCode": stateToken]
        JRLServiceManager.fulfill(params) { [weak self] (data,error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                self?.loadingIndicatorView.isHidden = true
                self?.view.isUserInteractionEnabled = true
                if error != nil {
                    if let message = error?.localizedDescription {
                        weakSelf.showError(text: message)
                    } else {
                        weakSelf.showError(text: JRLoginConstants.generic_error_message)
                    }
                    return
                }
                if let responseData = data, let status = responseData[LOGINWSKeys.kStatus] as? String,let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    if let stateCode = responseData["stateCode"] as? String,status == "SUCCESS", responseCode == "BE1400001" {
                        if let dataModel = weakSelf.dataModel {
                            let dataModel = dataModel
                            dataModel.stateToken = stateCode
                            let vc = JRLNewMobileNoVC.controller(dataModel)
                            weakSelf.navigationController?.pushViewController(vc, animated: true)
                            return
                        }
                    } else if status == "FAILURE", let message = responseData[LOGINWSKeys.kMesssage] as? String{
                        if responseCode == "BE1426002"{
                            weakSelf.navigationController?.popToRootViewController(animated: true)
                        }else{
                            weakSelf.showError(text: message)
                        }
                    }
                }
                else {
                    weakSelf.showError(text: "jr_login_server_error".localized)
                }
            }
        }
    }
}
