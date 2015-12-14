//
//  MemeTextEditDelegate.swift
//  MeMeEditor
//
//  Created by Samir Marin on 2015-12-08.
//  Copyright © 2015 Samir Marin. All rights reserved.
//

import Foundation
import UIKit

class MemeTextEditDelegate: NSObject, UITextFieldDelegate{
    
    var isItDefaultTextTop: Bool!
    var isItDefaultTextBottom: Bool!
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if let isDefualt = isItDefaultTextTop{
            if(isDefualt && textField.text == "TOP"){
                textField.text = ""
                isItDefaultTextTop = false
            }
        }
        if let isDefault = isItDefaultTextBottom{
            if(isDefault && textField.text == "BOTTOM"){
                textField.text = ""
                isItDefaultTextBottom = false
            }
        }
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
