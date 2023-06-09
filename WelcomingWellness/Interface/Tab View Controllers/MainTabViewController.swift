/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The main tab view controller used in the app.
*/

import UIKit
import HealthKit

/// The tab view controller for the app. The controller will load the last viewed view controller on `viewDidLoad`.
class MainTabViewController: UITabBarController {
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setUpTabViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setUpTabViewController() {
        let viewControllers = [
            createProfileViewController(),
            createDashboardScoreViewController(),
            createExerciseViewController(),
            createSleepViewController(),
            createDietViewController()
        ]
        
        self.viewControllers = viewControllers.map {
            UINavigationController(rootViewController: $0)
        }
        
        delegate = self
        selectedIndex = getLastViewedViewControllerIndex()
    }
    
    private func createProfileViewController() -> UIViewController {
        let viewController = WelcomeViewController()
        
        viewController.tabBarItem = UITabBarItem(title: "Profile",
                                                 image: UIImage(systemName: "circle"),
                                                 selectedImage: UIImage(systemName: "circle.fill"))
        return viewController
    }
    
    private func createDashboardScoreViewController() -> UIViewController {
        let dataTypeIdentifier = HKQuantityTypeIdentifier.stepCount.rawValue
        //let viewController = WeeklyQuantitySampleTableViewController(dataTypeIdentifier: dataTypeIdentifier)
        
        let viewController = DashboardViewController()
        viewController.tabBarItem = UITabBarItem(title: "Dashboard",
                                                 image: UIImage(systemName: "triangle"),
                                                 selectedImage: UIImage(systemName: "triangle.fill"))
        return viewController
    }
    
    private func createExerciseViewController() -> UIViewController {
//        let viewController = MobilityChartDataViewController()
        let dataTypeIdentifier = HKQuantityTypeIdentifier.stepCount.rawValue
//        let viewController = WeeklyQuantitySampleTableViewController(dataTypeIdentifier: dataTypeIdentifier)
        let viewController = ExerciseViewController()
        
        viewController.tabBarItem = UITabBarItem(title: "Exercise",
                                                 image: UIImage(systemName: "square"),
                                                 selectedImage: UIImage(systemName: "square.fill"))
        return viewController
    }
    
    private func createSleepViewController() -> UIViewController {
        let viewController = SleepViewController()
        
        viewController.tabBarItem = UITabBarItem(title: "Sleep",
                                                 image: UIImage(systemName: "star"),
                                                 selectedImage: UIImage(systemName: "star.fill"))
        return viewController
    }
    
    private func createDietViewController() -> UIViewController {
        let viewController = WeeklyReportTableViewController()
        
        viewController.tabBarItem = UITabBarItem(title: "Diet",
                                                 image: UIImage(systemName: "star"),
                                                 selectedImage: UIImage(systemName: "heart.fill"))
        return viewController
    }
    
    // MARK: - View Persistence
    
    private static let lastViewControllerViewed = "LastViewControllerViewed"
    private var userDefaults = UserDefaults.standard
    
    private func getLastViewedViewControllerIndex() -> Int {
        if let index = userDefaults.object(forKey: Self.lastViewControllerViewed) as? Int {
            return index
        }
        
        return 0 // Default to first view controller.
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        
        setLastViewedViewControllerIndex(index)
    }
    
    private func setLastViewedViewControllerIndex(_ index: Int) {
        userDefaults.set(index, forKey: Self.lastViewControllerViewed)
    }
}

