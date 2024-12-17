import UIKit

final class RMTableLoadingFooterView: UIView {
    
    // Creating the spinner of type UIActivityIndicatorView Here
    private let spinner:UIActivityIndicatorView = {
        // Creating the UIActivityIndicatorView Here
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override init(frame:CGRect){
        super.init(frame:frame)
        addSubview(spinner)
        spinner.startAnimating()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    // Using private func addConstraints() Here
    private func addConstraints(){
        // Using the NSLayoutConstraint.activate Here
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant:55),
            spinner.heightAnchor.constraint(equalToConstant:55),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
    
        ])
    }
}
