//
//  ViewController
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import UIKit
import FirebaseAnalytics
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import LocalAuthentication

class MainViewController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var biometricsBtn: UIButton!
    @IBOutlet weak var paswordView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var loginGoogleBtn: GIDSignInButton!
    @IBOutlet weak var eyeBtn: UIButton!
    
    // MARK: INJECTIONS
    let loader = Loader()
    var delay = 0.0
    var isHidePass = true
    let configurationImage = UIImage.SymbolConfiguration(pointSize: 14)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        
        self.setupInputs()
        
        
    }
    
    func setupInputs(){
        
        let borderColor = UIColor.lightGray.cgColor
        
        //Shadow inputs
        emailView.layer.borderWidth = 0.5
        emailView.layer.borderColor = borderColor
        emailView.layer.cornerRadius = 10
        
        paswordView.layer.borderWidth = 0.5
        paswordView.layer.borderColor = borderColor
        paswordView.layer.cornerRadius = 10
        
        emailTxt.layer.cornerRadius = 10
        
        passwordTxt.layer.cornerRadius = 10
        
        loginBtn.layer.cornerRadius = 10
        
        loginGoogleBtn.layer.cornerRadius = 20
        
        self.eyeBtn.setImage(UIImage(systemName: "eye.fill", withConfiguration: configurationImage), for: .normal)
        
        if UserDefaults.standard.string(forKey: UserDefaultEnum.logedBefore.rawValue) != nil {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                self.biometricsBtn.isHidden = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome" {
            guard segue.destination is HomeTableViewController else {return}
        } else if segue.identifier == "register" {
            guard segue.destination is RegisterViewController else {return}
        }
    }
    
    @IBAction func loginWithEmail(_ sender: Any) {
        loader.show(in: self)
        // Validations
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
        
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                self?.showAlert(message: "\(error.localizedDescription)", title: "Error al loguear")
            }
            strongSelf.goHome()
        }
        
    }
    
    func showAlert(message:String, title: String){
        CommonUtils.alert(message: message, title: title, origin: self, delay: 0)
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        loader.show(in: self)
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            Analytics.logEvent("Login con Google", parameters: ["user":"\(user)"])
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken:
                                                            user.accessToken.tokenString)
            Auth.auth().signIn(with: credential)
            self.goHome()
        }
    }
    
    @IBAction func register(_ sender: Any) {
        self.performSegue(withIdentifier: "register", sender: self)
    }
    
    func goHome(){
        loader.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.performSegue(withIdentifier: "goToHome", sender: self)
        })
    }
    
    @IBAction func loginWithBiometrics(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Por favor, autentica con Face ID para continuar."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    })
                } else {
                    if let error = error as? LAError {
                        CommonUtils.alert(message: error.localizedDescription, title: "Error", origin: self, delay: 0)
                    }
                }
            }
        }
    }
    @IBAction func showHidePass(_ sender: Any) {
        self.isHidePass.toggle()
        if self.isHidePass {
            self.eyeBtn.setImage(UIImage(systemName: "eye.fill", withConfiguration: configurationImage), for: .normal)
        } else{
            self.eyeBtn.setImage(UIImage(systemName: "eye.slash.fill", withConfiguration: configurationImage), for: .normal)
        }
        self.passwordTxt.isSecureTextEntry = self.isHidePass
    }
}

