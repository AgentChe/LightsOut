//
//  AppDelegate.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit
import FirebaseCore
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
//        defaults.set(true, forKey: Keys.adsFree)
        FirebaseApp.configure()
        
        let isItOpenBefore = defaults.bool(forKey: Constants.Keys.isItFirstOpen)
        
        if !isItOpenBefore {
            print("DEBUG: IT IS FIRST")
            defaults.set(5, forKey: Constants.Keys.lifeCount)
            defaults.set(true, forKey: Constants.Keys.isItFirstOpen)
            //UserDefaults.standard.set(true, forKey: Keys.adsFree)
            let adsFreeStatus = defaults.bool(forKey: Constants.Keys.adsFree)
            print("DEBUG: ads free have bought before: \(adsFreeStatus)")
            if adsFreeStatus {
                defaults.set(true, forKey: Constants.Keys.getPro)
            }
        } else {
            print("DEBUG: IT was opened before")
        }
        
        
        DatabaseManager.shared.connectDatabase { error in
            
            if let error = error {
                //Show error alert with database connection
                print("DEBUG: error from database connection \(error.localizedDescription)")
            } else {
                //Create table if is not
                print("connection basarilir")
                DatabaseManager.shared.createTableIfWasNotCreated { error in
                    guard let error = error else { return }
                    //Show error alert with table creation
                    print("DEBUG: error from database creation \(error.localizedDescription)")
                }
            }
        
            
            
        }
        
        SKPaymentQueue.default().add(IAPManager.shared)
        IAPManager.shared.fetchProduct()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

