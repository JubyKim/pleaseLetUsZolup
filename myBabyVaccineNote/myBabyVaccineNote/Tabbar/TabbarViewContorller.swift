//
//  TabbarViewContorller.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/10/13.
//

import Foundation
import UIKit

class TabbarViewContorller : UITabBarController {
  var defaultIndex = 0 {
    didSet {
      self.selectedIndex = defaultIndex
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    print("TabbarViewContorller - viewdidload")
    self.view.backgroundColor = .white
    self.selectedIndex = defaultIndex
    self.tabBar.layer.borderWidth = 0.6
    
    self.tabBar.layer.borderColor = .none
  }

}
extension TabbarViewContorller : UITabBarControllerDelegate {
//  override func viewDidLayoutSubviews() {
//      super.viewDidLayoutSubviews()
//      tabBar.frame.size.height = 95
//      tabBar.frame.origin.y = view.frame.height - 95
//  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let tab1NavigationController =  UINavigationController()
    tab1NavigationController.viewControllers = [HomeViewController()]
    
    let tab2NavigationController = UINavigationController()
    tab2NavigationController.viewControllers = [HistoryViewController()]
    
    let tab3NavigationController = UINavigationController()
    tab3NavigationController.viewControllers = [ScheduleViewController()]
    
    let tab4NavigationController = UINavigationController()
    tab4NavigationController.viewControllers = [MyPageViewController()]
    
    let vc = [tab1NavigationController, tab2NavigationController, tab3NavigationController, tab4NavigationController]
    self.setViewControllers(vc, animated: true)

    let tabBar: UITabBar = self.tabBar
    tabBar.backgroundColor = UIColor.clear
    tabBar.barStyle = UIBarStyle.default
    tabBar.barTintColor = UIColor.white
    
    let imageNames = ["tabbarHomeIcon", "tabbarHistoryIcon", "tabbarScheduleIcon", "tabbarMyPageIcon"]
    let imageSelectedNames = ["tabHomeAct", "tabSearchAct", "tabCommunityAct", "tabMyAct"]

    for (ind, value) in (tabBar.items?.enumerated())! {
      let tabBarItem: UITabBarItem = value as UITabBarItem
      tabBarItem.title = nil
      tabBarItem.image = UIImage(named: imageNames[ind])?.withRenderingMode(.alwaysOriginal)
      tabBarItem.selectedImage = UIImage(named: imageSelectedNames[ind])?.withRenderingMode(.alwaysOriginal)
      tabBarItem.accessibilityIdentifier = imageNames[ind]
      tabBarItem.imageInsets.top = 15
      tabBarItem.imageInsets.bottom = -15
    }
  }
}

