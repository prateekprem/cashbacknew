//
//  Ext_UIAlertViewController.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

// tag : type of button, index : collection view cell index
public typealias AlertBtnCompletion = (_ indx: Int) -> ()

extension UIAlertController {
    
    public class func show(title:String, message: String, onController: UIViewController) {
        UIAlertController.showWith(title: title, body: message, btnTitles: ["OK"],
                                   onController: onController, isSheetStyle: false, block: nil)
    }
    
    /*! @method : show alert with their title and body.  pass the block and btntitles with same count*/
    public class func showWith(title: String, body: String, btnTitles: [String],
                        onController: UIViewController, completion: AlertBtnCompletion?) {
        UIAlertController.showWith(title: title, body: body, btnTitles: btnTitles,
                                   onController: onController, isSheetStyle: false, block: completion)
    }
    
    public class func showWith(title: String, body: String, btnTitles: [String],
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
