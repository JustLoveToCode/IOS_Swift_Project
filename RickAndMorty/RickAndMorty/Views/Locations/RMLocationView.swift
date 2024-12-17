import UIKit

// Create protocol RMLocationViewDelegate which is AnyObject Here
protocol RMLocationViewDelegate:AnyObject{
    func rmLocationView(_ locationView:RMLocationView, didSelect location:RMLocation)
}

// Create the RMLocationView of type UIView Here
final class RMLocationView: UIView {
    
    // Using public weak var delegate of type RMLocationViewDelegate?
    public weak var delegate: RMLocationViewDelegate?
    
    
    // Create the viewModel of type RMLocationViewViewModel
    private var viewModel:RMLocationViewViewModel?{
        // Using the didSet Method Here
        didSet{
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration:0.3){
            // This mean the tableView is 100% Visible Here
                self.tableView.alpha = 1
            }
            viewModel?.registerDidFinishPaginationBlock {[weak self] in
                // Using the DispatchQueue.main.async Here
                DispatchQueue.main.async {
                    // Loading Indicator will Be Bygone
                    self?.tableView.tableFooterView = nil
                    // Reloading the Data Here, Reloading the Data
                    // to show More Data Here
                    self?.tableView.reloadData()
                }
            }
        }
    }
    // Create the tableView of type UITableView Here
    private let tableView:UITableView = {
        let table = UITableView(frame:.zero, style:.grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.alpha = 0
        table.isHidden = true
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier:RMLocationTableViewCell.cellIdentifier)
        return table
    }()
    // Create the spinner of type UIActivityIndicatorView Here
    private let spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = false
        return spinner
    }()

    override init(frame:CGRect){
        super.init(frame:frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        addSubviews(tableView,spinner)
        spinner.startAnimating()
        addConstraints()
        configureTable()
        
     
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    private func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func addConstraints(){
    // Create the NSLayoutConstraint Properties Here
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant:100),
            spinner.widthAnchor.constraint(equalToConstant:100),
            spinner.centerXAnchor.constraint(equalTo:centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo:centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo:bottomAnchor),
            tableView.leftAnchor.constraint(equalTo:leftAnchor),
            tableView.rightAnchor.constraint(equalTo:rightAnchor)
            
            
        ])
    }
    
    public func configure(with viewModel:RMLocationViewViewModel){
        self.viewModel = viewModel
    }

}

extension RMLocationView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let locationModel = viewModel?.location(at: indexPath.row) else{
            return
        }
        // Notify the Controller of Selection
        delegate?.rmLocationView(self, didSelect:locationModel)
        
    }
}

// Using the extension RMLocationView and extend UITableViewDataSource Here
extension RMLocationView:UITableViewDataSource{
    
    // Using numberOfRowsInSection Properties
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int{
        return viewModel?.cellViewModels.count ?? 0
    }
    
    // Using cellForRowAt Properties
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        
        guard let cellViewModels = viewModel?.cellViewModels else{
            fatalError()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else {
            fatalError()
        }
        
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with:cellViewModel)
        return cell
    }
}


// Using extension RMLocationView of type UIScrollViewDelegate Here
extension RMLocationView:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView:UIScrollView){
            guard let viewModel = viewModel,
                  viewModel.shouldShowLoadMoreIndicator,!viewModel.isLoadingMoreLocations,!viewModel.cellViewModels.isEmpty
                else {
                return
            }
            // The Timer will wait 0.2s before Executing the Code
            // Using the Timer.scheduledTimer HERE
            Timer.scheduledTimer(withTimeInterval:0.2, repeats: false) {[weak self] t in
                let offset = scrollView.contentOffset.y
                let totalContentHeight = scrollView.contentSize.height
                let totalScrollViewFixedHeight = scrollView.frame.size.height
                
                if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120){
                    self?.showLoadingIndicator()
                    // Using DispatchQueue.main.async Method Here
                    DispatchQueue.main.asyncAfter(deadline:.now()+0.1, execute:{
                        viewModel.fetchAdditionalLocations()
                    })
                        
                    }
                t.invalidate()
            }
        }
    // Create private func showLoadingIndicator() Here
    private func showLoadingIndicator(){
        // Using RMTableLoadingFooterView Here
        let footer = RMTableLoadingFooterView(frame:CGRect(x:0, y: 0, width: frame.size.width, height: 100))
        tableView.tableFooterView = footer
    }
      
}

