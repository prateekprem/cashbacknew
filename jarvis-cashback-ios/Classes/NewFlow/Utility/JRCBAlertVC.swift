//
//  JRCBAlertVC.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 29/04/20.
//

import UIKit

// tag : type of button, index : collection view cell index
typealias JRCBAlertBtnCompletion = (_ indx: Int) -> ()

extension UIAlertController {
    
    public class func cbShow(title:String, message: String, onController: UIViewController) {
        UIAlertController.cbShowWith(title: title, body: message, btnTitles: ["OK"],
                                   onController: onController, isSheetStyle: false, block: nil)
    }
    
    /*! @method : show alert with their title and body.  pass the block and btntitles with same count*/
    class func cbShowWith(title: String, body: String, btnTitles: [String],
                        onController: UIViewController, completion: AlertBtnCompletion?) {
        UIAlertController.cbShowWith(title: title, body: body, btnTitles: btnTitles,
                                   onController: onController, isSheetStyle: false, block: completion)
    }
    
    class func cbShowWith(title: String, body: String, btnTitles: [String],
                        onController: UIViewController, isSheetStyle: Bool,
                        block: AlertBtnCompletion?) {
        
        let alert = UIAlertController(title: title, message: body, preferredStyle: isSheetStyle ? .actionSheet : .alert)
        for bTtl in btnTitles {
            let anAct = UIAlertAction(title: bTtl, style: .default, handler: { (action: UIAlertAction) in
                if block != nil {
                    if let indx = btnTitles.firstIndex(of: bTtl){
                        block!(indx)
                    }else{
                        block!(0)
                    }
                }
            })
            
            alert.addAction(anAct)
        }
        onController.present(alert, animated: true){}
    }

}
