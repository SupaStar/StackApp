//
//  CommonUtils
//  StackApp
//
//  Created by Obed Martinez on 12/10/23
//



import Foundation
import UIKit

final class CommonUtils {
    
    private init() {}
    
    static func alert(message: String, title: String, origin: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
        }
        alertController.addAction(OKAction)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            origin.present(alertController, animated: true, completion:nil)
        })
    }
}
