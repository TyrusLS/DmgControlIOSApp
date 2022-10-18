//
//  EditDetailViewController.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 16.03.22.
//

import UIKit
import CoreData

class EditDetailViewController: UIViewController {
    

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    var casing : String! = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var equipmentData: EquipmentData!
    let placeholder = "Weitere Details..."
    
    public var label: String!
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        inputTextView.becomeFirstResponder()
        inputTextView.delegate = self
        inputTextView.text = placeholder
        inputTextView.textColor = .lightGray
        let newPosition = inputTextView.beginningOfDocument
        inputTextView.selectedTextRange = inputTextView.textRange(from: newPosition, to: newPosition)

        if(equipmentData.sturzschaden?.checked ?? false && (equipmentData.sturzschaden?.details != ""&&equipmentData.sturzschaden?.details != nil && equipmentData.sturzschaden?.details != " ")){
            
            inputTextView.text = equipmentData.sturzschaden?.details ?? ""
            inputTextView.textColor = .black
            let endPosition = inputTextView.endOfDocument
            inputTextView.selectedTextRange = inputTextView.textRange(from: endPosition, to: endPosition)
            
        }else
        if(equipmentData.sonstigerschaden?.checked ?? false && (equipmentData.sonstigerschaden?.details != ""&&equipmentData.sonstigerschaden?.details != nil && equipmentData.sonstigerschaden?.details != " ")){
        
            inputTextView.text = equipmentData.sonstigerschaden?.details ?? ""
            inputTextView.textColor = .black
            let endPosition = inputTextView.endOfDocument
            inputTextView.selectedTextRange = inputTextView.textRange(from: endPosition, to: endPosition)
        }
        super.viewDidLoad()
    }
  
    
    
    
    @objc internal func keyboardWillHide(_ notification : Notification?) -> Void {
        let kBHeight = getKeyboardHeight(notification: notification!)
        textViewHeight.constant = kBHeight
    }
    @objc internal func keyboardWillShow(_ notification : Notification?) -> Void {
        let kBHeight = getKeyboardHeight(notification: notification!)
        textViewHeight.constant = kBHeight
        }
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]as? NSValue)?.cgRectValue.height else{return 0}
        return keyboardHeight
    }
    
    @IBAction func CompleteDamageInput(_ sender: Any) {
        switch(casing){
        case "sturz":
            do{
                if(inputTextView.text != placeholder){
                equipmentData.sturzschaden?.details = inputTextView.text}else {
                equipmentData.sturzschaden?.details = ""
                }
                try context.save()}catch{}
            break;
        case "sonstige":
            do{
                if(inputTextView.text != placeholder){
                equipmentData.sonstigerschaden?.details = inputTextView.text}else {
                equipmentData.sonstigerschaden?.details = ""
                }
                try context.save()}catch{}
            break;
        default:
            break;
            
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    func scrollTextViewToCursor(textView: UITextView) {
        let caret = textView.caretRect(for: textView.selectedTextRange!.start)
        textView.scrollRectToVisible(caret, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        scrollTextViewToCursor(textView: inputTextView)
    }
    
}

extension EditDetailViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText: NSString = inputTextView.text! as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        if updatedText.isEmpty {
            inputTextView.text = placeholder
            inputTextView.textColor = .lightGray
            let newPosition = inputTextView.beginningOfDocument
            inputTextView.selectedTextRange = inputTextView.textRange(from: newPosition, to: newPosition)
            return false
        }
        else if inputTextView.textColor == .lightGray && !text.isEmpty {
            inputTextView.text = nil
            inputTextView.textColor = .black
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == .lightGray {
                let newPosition = inputTextView.beginningOfDocument
                inputTextView.selectedTextRange = inputTextView.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
}



