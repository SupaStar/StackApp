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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        
        self.setupInputs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupInputs(){
        
        let borderColor = UIColor.lightGray.cgColor
        
        self.emailTxt.layer.borderWidth = 1.0
        self.emailTxt.layer.borderColor = borderColor
        self.emailTxt.layer.cornerRadius = 10
        
        self.passwordTxt.layer.borderWidth = 1.0
        self.passwordTxt.layer.borderColor = borderColor
        self.passwordTxt.layer.cornerRadius = 10
    }
    
    @IBAction func register(_ sender: Any) {
        self.closeView()
        return
        guard let email = emailTxt.text, let password = passwordTxt.text else {
            CommonUtils.alert(message: "Todos los campos son requeridos.", title: "Advertencia", origin: self, delay: 0)
            return
        }
        if email == "" || password == "" {
            CommonUtils.alert(message: "Todos los campos son requeridos.", title: "Advertencia", origin: self, delay: 0)
            return
        }
        if !email.isValidEmail(){
            CommonUtils.alert(message: "El email no es valido.", title: "Advertencia", origin: self, delay: 0)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            guard error == nil else {
                CommonUtils.alert(message: "\(error!.localizedDescription)", title: "Error", origin: self, delay: 0)
                return
            }
            self.closeView()
        }
    }
    func closeView(){
        let alert = UIAlertController(title: "Exito", message: "Usuario creado con exito, inicia sesion.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
