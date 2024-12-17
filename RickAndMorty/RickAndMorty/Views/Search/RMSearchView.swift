import UIKit

// Create protocol of RMSearchViewDelegate of AnyObject Here
protocol RMSearchViewDelegate:AnyObject {
    func rmSearchView(_ searchView:RMSearchView, didSelectOption option:RMSearchInputViewViewModel.DynamicOption)
    
    func rmSearchView(_ searchView:RMSearchView, didSelectLocation location:RMLocation)
    func rmSearchView(_ searchView:RMSearchView, didSelectCharacter character:RMCharacter)
    func rmSearchView(_ searchView:RMSearchView, didSelectEpisode character:RMEpisode)
}

// Create the class RMSearchView of type UIView Here
final class RMSearchView: UIView {
    
    // Creating a delegate var here of type RMSearchViewDelegate
    weak var delegate: RMSearchViewDelegate?
    
    // Create the viewModel Variable of type RMSearchViewViewModel Instances Here
    private let viewModel:RMSearchViewViewModel
    
    // Mark - Subviews
    
    // SearchInputView(bar, selection buttons)
    private let searchInputView = RMSearchInputView()
    
    // Creating the noResultsView Here
    private let noResultsView = RMNoSearchResultsView()
    
    // Create the resultsView Here
    private let resultsView = RMSearchResultsView()
    
    
    
    
    // Mark - Init
    // Using the init method here
    init(frame: CGRect, viewModel:RMSearchViewViewModel){
        self.viewModel = viewModel
        super.init(frame:frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        // The Ordering that you add the View Does Not Matter
        addSubviews(resultsView,noResultsView,searchInputView)
        // Using the addConstraints() Method Here
        addConstraints()
        searchInputView.configure(with:RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        setUpHandlers(viewModel: viewModel)
        resultsView.delegate = self
    }
    
   
    private func setUpHandlers(viewModel: RMSearchViewViewModel){
        viewModel.registerOptionChangeBlock {tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        viewModel.registerSearchResultHandler {[weak self] result in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: result)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoResultsHandler{[weak self] in
            DispatchQueue.main.async{
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
    
    // Using the required init Method here
    required init?(coder:NSCoder){
        fatalError()
    }
    
    // Create the private func addConstraints() Here
    private func addConstraints(){
        // Using the activate Keyword Here on the NSLayoutConstraint method
        NSLayoutConstraint.activate([
            // Constraints for noResultsView
            noResultsView.widthAnchor.constraint(equalToConstant:150),
            noResultsView.heightAnchor.constraint(equalToConstant:150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo:centerYAnchor),
            
            // Constraints for resultsView
            resultsView.topAnchor.constraint(equalTo:searchInputView.bottomAnchor),
            resultsView.leftAnchor.constraint(equalTo:leftAnchor),
            resultsView.rightAnchor.constraint(equalTo:rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo:bottomAnchor),
            
            // Constraints for SearchInputView
            searchInputView.topAnchor.constraint(equalTo:topAnchor),
            searchInputView.leftAnchor.constraint(equalTo:leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo:rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant:viewModel.config.type == .episode ? 55 : 110)
            
            
        ])
    }
    
    // Create the public func presentKeyboard Here
    public func presentKeyboard(){
        searchInputView.presentKeyboard()
    }

}

// Mark - CollectionView
extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


// Mark - RMSearchInputViewDelegate
extension RMSearchView:RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView:RMSearchInputView,didSelectOption option:RMSearchInputViewViewModel.DynamicOption){
        delegate?.rmSearchView(self, didSelectOption:option)
    }
    
    func rmSearchInputView(_ inputView:RMSearchInputView, didChangeSearchText text:String){
        viewModel.set(query:text)
    }
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView:RMSearchInputView){
        viewModel.executeSearch()
    }
}

extension RMSearchView:RMSearchResultsViewDelegate{
    
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
        
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectLocation:locationModel)
    }
    
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapEpisodeAt index:Int){
        guard let episodeModel = viewModel.episodeSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectEpisode:episodeModel)
    }
    
    
    
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapCharacterAt index:Int){
        guard let characterModel = viewModel.characterSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectCharacter:characterModel)
        
    }
}

