import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    // Creating the cellIdentifier RMEpisodeInfoCollectionViewCell Here
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
    
    // Create the titleLabel called UILabel Here
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize:20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Create the valueLabel called UILabel Here
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize:20, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Using the override init to actually override the method here
    override init(frame:CGRect){
        super.init(frame:frame)
        contentView.backgroundColor = .secondarySystemBackground
        // Adding the addSubviews for the titleLabel and valueLabel Here:
        contentView.addSubviews(titleLabel, valueLabel)
        setUpLayer()
        
        addConstraints()
    }
    
    required init?(coder:NSCoder){
        fatalError()
    }
    // Create the private func setUpLayer
    private func setUpLayer(){
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        
    }
    // Create the private func addConstraints
    private func addConstraints(){
        NSLayoutConstraint.activate([
            // Create the constraint Here for the titleLabel
            titleLabel.topAnchor.constraint(equalTo:contentView.topAnchor, constant:4),
            titleLabel.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:10),
            titleLabel.bottomAnchor.constraint(equalTo:contentView.bottomAnchor, constant:-4),
            
            // Create the constraint Here for the valueLabel
            valueLabel.topAnchor.constraint(equalTo:contentView.topAnchor, constant:4),
            valueLabel.rightAnchor.constraint(equalTo:contentView.rightAnchor, constant:-10),
            valueLabel.bottomAnchor.constraint(equalTo:contentView.bottomAnchor, constant:-4),
            
            // Create the constraint Here for the titleLabel and the valueLabel
            titleLabel.widthAnchor.constraint(equalTo:contentView.widthAnchor, multiplier:0.47),
            valueLabel.widthAnchor.constraint(equalTo:contentView.widthAnchor, multiplier:0.47)
            
        ])
    }
    
    // Create the func prepareForReuse Here
    override func prepareForReuse(){
        super.prepareForReuse()
        // Reset the valueLabel and titleLabel Here
        titleLabel.text = nil
        valueLabel.text = nil
    }
    // Create the func configure here
    func configure(with viewModel:RMEpisodeInfoCollectionViewCellViewModel){
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}
