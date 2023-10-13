//
//  TickerTableViewCell
//  StackApp
//
//  Created by Obed Martinez on 12/10/23
//



import UIKit

class TickerTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var symbolLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var closeLbl: UILabel!
    @IBOutlet weak var stockAcronymLbl: UILabel!
    @IBOutlet weak var stockCountyLbl: UILabel!
    
    // MARK: Variables
    var ticker: TickerModel? {
        didSet {
            symbolLbl.text = ticker?.symbol
            nameLbl.text = ticker?.name
            stockAcronymLbl.text = ticker?.stock_exchange.acronym
            stockCountyLbl.text = ticker?.stock_exchange.country
            if let closes = ticker?.closes {
                self.closeLbl.text = "\(closes)"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
