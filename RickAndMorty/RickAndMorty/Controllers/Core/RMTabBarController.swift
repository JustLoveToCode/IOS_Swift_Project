//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Y.k on 20/11/24.
//

import UIKit

// Controller to House Tabs and Root Tab Controllers
class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        
        
    }
    
    private func setUpTabs(){
        // Invoking the Different Classes Here
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodesVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()
        
        // Creating the largeTitleDisplayMode to be .automatic here
        characterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        
        let nav1 = UINavigationController(rootViewController:characterVC)
        let nav2 = UINavigationController(rootViewController:locationVC)
        let nav3 = UINavigationController(rootViewController:episodesVC)
        let nav4 = UINavigationController(rootViewController:settingsVC)
        
        // Create the Visual For the Bottom Tab Itself which have the title and the image
        nav1.tabBarItem = UITabBarItem(title: "Character", image:UIImage(systemName:"person"), tag:1)
        nav2.tabBarItem = UITabBarItem(title: "Locations", image:UIImage(systemName:"globe"), tag:2)
        nav3.tabBarItem = UITabBarItem(title: "Episodes", image:UIImage(systemName:"tv"), tag:3)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image:UIImage(systemName:"gear"), tag:4)
                                                                      
        
        for nav in [nav1,nav2,nav3,nav4]{
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([
            nav1,nav2,nav3,nav4
        ],
        animated:true)
    }
}

