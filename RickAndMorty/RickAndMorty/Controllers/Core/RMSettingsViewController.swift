import UIKit
import SwiftUI
import SafariServices
import StoreKit


// Controllers to search and show the Various App Options and Settings
final class RMSettingsViewController: UIViewController {
    
    // Making it Mutable by using the var Keyword
    private var settingsSwiftUIController:UIHostingController<RMSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Getting the backgroundColor to be systemBackground Color Here
        view.backgroundColor = .systemBackground
        title = "Settings"
        // INVOKING the Function addSwiftUIController() Here
        addSwiftUIController()
    }
    
    // Create private func addSwiftUIController
    private func addSwiftUIController(){
        let settingsSwiftUIController =
        UIHostingController(
            rootView:RMSettingsView(
                viewModel:RMSettingsViewViewModel(
                    cellViewModels:RMSettingsOption.allCases.compactMap({
                        return RMSettingsCellViewModel(type:$0) {[weak self] option in
                            self?.handleTap(option:option)
                }
              })
            )
        )
    )
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        // Adding the addSubview() Method here
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        self.settingsSwiftUIController = settingsSwiftUIController
        
    }
    
    // private func handleTop Functionality
    // option Variable is actually RMSettingsOption Here
    private func handleTap(option:RMSettingsOption){
        guard Thread.current.isMainThread else {
            return
        }
        if let url = option.targetUrl{
            // Open the Website URL using Safari Browser
            let vc = SFSafariViewController(url:url)
            present(vc,animated:true)
        } else if option == .rateApp {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
      
    }
}
