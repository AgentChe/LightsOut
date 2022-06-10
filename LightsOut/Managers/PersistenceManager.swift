//
//  PersistenceManager.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation

struct PersistenceManager {
    
    static let shared = PersistenceManager()
    
    
    func playCount() {
        var count = UserDefaults.standard.integer(forKey: Constants.Keys.playCountKey )
        count += 1
        UserDefaults.standard.set(count, forKey: Constants.Keys.playCountKey)
    }
}
