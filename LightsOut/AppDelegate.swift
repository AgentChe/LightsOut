//
//  AppDelegate.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        FirebaseApp.configure()
        
        let isItOpenBefore = defaults.bool(forKey: "isItFirstOpen")
        
        if !isItOpenBefore {
            print("DEBUG: IT IS FIRST")
            defaults.set(5, forKey: "lifeCount")
            defaults.set(true, forKey: "isItFirstOpen")
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

