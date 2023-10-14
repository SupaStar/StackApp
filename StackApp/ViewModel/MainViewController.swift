//
//  ViewController
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import UIKit
import FirebaseAnalytics

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = UIScreen.main.bounds.size.width
//        let priceChartView = ChartView(frame: CGRect(x: 20, y: 50, width: screenWidth - 50, height: 400))
//        priceChartView.y = [100.0, 105.0, 110.0, 120.0, 115.0, 125.0, 1000.0, 100.0, 105.0, 110.0, 120.0, 115.0, 125.0, 1000.0,100.0, 105.0, 110.0, 120.0, 115.0, 125.0, 1000.0, 100.0, 105.0, 110.0, 120.0, 115.0, 125.0, 1000.0, 100.0, 105.0, 110.0, 120.0, 115.0, 125.0, 1000.0]
//        priceChartView.x = ["10-01", "10-02", "10-03", "10-04", "10-05", "10-06","10-01", "10-02", "10-03", "10-04", "10-05", "10-06","10-01", "10-02", "10-03", "10-04", "10-05", "10-06","10-01", "10-02", "10-03", "10-04", "10-05", "10-06","10-01", "10-02", "10-03", "10-04", "10-05", "10-06"]
//        view.addSubview(priceChartView)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome" {
            guard segue.destination is HomeTableViewController else {return}
        }
    }
    
    @IBAction func goHome(_ sender: Any) {
        Analytics.logEvent("Inicio", parameters: ["idDevice":"\(getDeviceUUID())"])
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
}

