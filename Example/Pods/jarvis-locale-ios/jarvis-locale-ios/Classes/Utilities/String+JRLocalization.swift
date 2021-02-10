//
//  String+JRLocalization.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 01/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

