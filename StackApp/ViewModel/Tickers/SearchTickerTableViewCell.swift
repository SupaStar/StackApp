//
//  SearchTickerTableViewCell
//  StackApp
//
//  Created by Obed Martinez on 15/10/23
//



import UIKit

class SearchTickerTableViewCell: UITableViewCell {

    @IBOutlet weak var limitButton: UIButton!
    @IBOutlet weak var searchTxt: UISearchBar!
    
    private var debounceTimer: Timer?
    private var options: [OptionPaginateEnum] = [.ten, .twenty, .fifty, .hundred]
    var originVC: HomeTableViewController?
    var limit: Int = OptionPaginateEnum.hundred.rawValue
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.searchTxt.delegate = self
        
        self.loadFilterOptions()
    }

    func changeLimit(action: UIAction){
        if let selectedOption = OptionPaginateEnum(rawValue: Int(action.title) ?? 0) {
            let value = selectedOption.rawValue
            if let origin = originVC {
                origin.limit = value
                origin.offset = 0
                guard origin.tickers.count > value else { return }
                origin.tickers = Array(origin.tickers.prefix(value))
                origin.tableView.reloadData()
                self.limit = value
            }
        }
    }
    
    func loadFilterOptions() {
        var optionsArray = [UIAction]()
        for option in options {
            let action = UIAction(title: "\(option.rawValue)", state: .off, handler: self.changeLimit)
            
            optionsArray.append(action)
        }
        optionsArray.last?.state = .on
        let optionsMenu = UIMenu(title: "", options: .displayInline, children: optionsArray)
        limitButton.menu = optionsMenu
        limitButton.changesSelectionAsPrimaryAction = true
        limitButton.showsMenuAsPrimaryAction = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func searchWithDelay() {
        var search: String?
        if searchTxt.text != "" {
            search = searchTxt.text
        }
        originVC?.search = search
        originVC?.loadTickers(refresh: true)
    }
}
extension SearchTickerTableViewCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounceTimer?.invalidate()

        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.searchWithDelay()
        }
    }
}

