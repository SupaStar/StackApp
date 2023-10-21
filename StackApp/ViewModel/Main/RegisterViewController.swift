//
//  RegisterViewController
//  StackApp
//
//  Created by Obed Martinez on 14/10/23
//



import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordConfirmTxt: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordConfirmView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var showHidePasswordBtn: UIButton!
    @IBOutlet weak var showHidePasswordConfirmBtn: UIButton!
    
    // MARK: INJECTIONS
    let loader = Loader()
    let configurationImage = UIImage.SymbolConfiguration(pointSize: 14)
    var isHidePass = true
    var isHidePassConfirm = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        
        self.setupInputs()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupInputs(){
        
        let borderColor = UIColor.lightGray.cgColor
        emailView.layer.borderWidth = 0.5
        emailView.layer.borderColor = borderColor
        emailView.layer.cornerRadius = 10
        
        passwordView.layer.borderWidth = 0.5
        passwordView.layer.borderColor = borderColor
        passwordView.layer.cornerRadius = 10
        
        passwordConfirmView.layer.borderWidth = 0.5
        passwordConfirmView.layer.borderColor = borderColor
        passwordConfirmView.layer.cornerRadius = 10
        
        self.showHidePasswordBtn.setImage(UIImage(systemName: "eye.fill", withConfiguration: configurationImage), for: .normal)
        
        self.showHidePasswordConfirmBtn.setImage(UIImage(systemName: "eye.fill", withConfiguration: configurationImage), for: .normal)
        
        self.emailTxt.layer.cornerRadius = 10
        
        self.passwordTxt.layer.cornerRadius = 10
    }
    
    @IBAction func register(_ sender: Any) {
        guard let email = emailTxt.text, let password = passwordTxt.text else {
            CommonUtils.alert(message: "All fields are required.", title: "Warning", origin: self, delay: 0)
            return
        }
        if email == "" || password == "" {
            CommonUtils.alert(message: "All fields are required.", title: "Warning", origin: self, delay: 0)
            return
        }
        if !email.isValidEmail(){
            CommonUtils.alert(message: "The email is not valid.", title: "Warning", origin: self, delay: 0)
            return
        }
        
        if passwordTxt.text != passwordConfirmTxt.text {
            CommonUtils.alert(message: "Passwords do not match.", title: "Warning", origin: self, delay: 0)
            return
        }
        loader.show(in: self)
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            guard error == nil else {
                CommonUtils.alert(message: "\(error!.localizedDescription)", title: "Error", origin: self, delay: 0)
                return
            }
            self.loader.hide()
            self.closeView()
        }
    }
    func closeView(){
        let alert = UIAlertController(title: "Success", message: "User created successfully, please log in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showHidePassword(_ sender: Any) {
        self.isHidePass.toggle()
        let imageName = self.isHidePass ? "eye.fill" : "eye.slash.fill"
        self.showHidePasswordBtn.setImage(UIImage(systemName: imageName, withConfiguration: configurationImage), for: .normal)
        self.passwordTxt.isSecureTextEntry = self.isHidePass
    }
    
    @IBAction func showHidePasswordConfirm(_ sender: Any) {
        self.isHidePassConfirm.toggle()
        let imageName = self.isHidePassConfirm ? "eye.fill" : "eye.slash.fill"
        self.showHidePasswordConfirmBtn.setImage(UIImage(systemName: imageName, withConfiguration: configurationImage), for: .normal)
        self.passwordConfirmTxt.isSecureTextEntry = self.isHidePassConfirm
    }
}
