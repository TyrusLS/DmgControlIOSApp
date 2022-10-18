//
//  LoginViewController.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 02.03.22.
//

import UIKit
import KeychainWrapper
import CoreData
import CoreMedia

class ViewController: UIViewController, UITextFieldDelegate{
    
    var iconClick = false
    let imageicon = UIImageView()
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet var LoginView: UIView!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var LoginScrollView: UIScrollView!
    
    let LoadData = LoadUserData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpHideTextButton()
        
        self.hideKeyboardWhenTappedAround()
        
        self.usernameInput.delegate = self
        self.passwordInput.delegate = self
        
        usernameInput.returnKeyType = UIReturnKeyType.next
        passwordInput.returnKeyType = UIReturnKeyType.done
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
    }
    
  
    
    func setUpHideTextButton(){
        imageicon.image = UIImage(systemName: "eye.slash.fill")
        let imageView = UIView()
        imageView.addSubview(imageicon)
        
        imageView.frame = CGRect(x: 0, y: 0, width: UIImage(systemName: "eye.slash.fill")!.size.width+5,
                                 height: UIImage(systemName: "eye.slash.fill")!.size.height+5)
        //imageView.backgroundColor = .blue
        imageicon.frame = CGRect(x: -10, y: 0, width: UIImage(systemName: "eye.slash.fill")!.size.width+5,
                                 height: UIImage(systemName: "eye.slash.fill")!.size.height+5)
        //imageicon.backgroundColor = .red
        passwordInput.rightView = imageView
        passwordInput.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if !iconClick
        {
            imageicon.image =  UIImage(systemName: "eye.fill")
            passwordInput.isSecureTextEntry = false
            iconClick = true
        }else{
            imageicon.image = UIImage(systemName: "eye.slash.fill")
            passwordInput.isSecureTextEntry = true
            iconClick = false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameInput {
               textField.resignFirstResponder()
               passwordInput.becomeFirstResponder()
            } else if textField == passwordInput {
                passwordInput.resignFirstResponder()
                SendLoginData(LoginBtn as Any)
            }
           return true
          }
    
    //on Button click function
    @IBAction func SendLoginData(_ sender: Any) {
        let username = usernameInput.text?.trimmingCharacters(in: .whitespaces)
        let password = passwordInput.text?.trimmingCharacters(in: .whitespaces)
        
        //check if string is clear
        if(username==""||password==""){
            showToast(message: "da ist nichts?", seconds:  1.5 )
        }else{
            var found : Bool = false
            LoadData.forEach { LoadData in
                if(LoadData.password == password && LoadData.username == username){
                    // check if logged in
                    //Open up the new Qr-Code scanner controller
                    do {
                        guard let username = username?.data(using: .utf8) else {return}
                        guard let password = password?.data(using: .utf8) else {return}
                        try KeychainWrapper.set(value: username, account: "username")
                        try KeychainWrapper.set(value: password, account: "password")
                    } catch{
                        print(error)
                    }
                    found = true
                    
                    
                    
                    let qr = storyboard?.instantiateViewController(withIdentifier: "devicescan") as! UINavigationController
                    UIApplication.shared.keyWindow?.rootViewController = qr
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                    
                    return
                }
            }
            if (!found){
                showToast(message: "Die eingetragenen Daten waren nicht Korrekt", seconds:  1.5 )
            }
        }
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        
        LoginScrollView.contentInset = contentInsets
        LoginScrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        LoginScrollView.contentInset = contentInsets
        LoginScrollView.scrollIndicatorInsets = contentInsets
    }

    
}
//hide keyboard with a touch outside of the keyboard

//show error message via AllertController
extension UIViewController {
  func showToast(message: String, seconds: Double) {
    let alert = UIAlertController(title: nil, message: message,
      preferredStyle: .alert)
    alert.view.backgroundColor = UIColor.black
    alert.view.alpha = 0.6
    alert.view.layer.cornerRadius = 15
    present(alert, animated: true)
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + seconds) {
          alert.dismiss(animated: true)}
  }
}
//placeholer function to make it look good for sure
extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
extension UIViewController{
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer) {
            view.endEditing(true)}
}









