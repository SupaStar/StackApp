//
//  ViewController
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome" {
            guard segue.destination is HomeTableViewController else {return}
        }
    }

    @IBAction func goHome(_ sender: Any) {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
}

