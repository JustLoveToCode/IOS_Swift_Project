

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "RMFooterLoadingCollectionReusableView"
    
    // Creating the spinner which is of the UIActivityIndicatorView Here
    private let spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // Creating the override init here
    override init(frame:CGRect){
        super.init(frame:frame)
        // This is the System Background Color
        backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraints()
    }
    // Using the required keyword here
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
        
    }
    // Create private func addConstraints Here
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo:centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo:centerYAnchor),
        ])
    }
    // Create private func startAnimating Here
    public func startAnimating(){
        spinner.startAnimating()
        
    }
        
}
