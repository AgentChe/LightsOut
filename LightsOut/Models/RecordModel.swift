//
//  RecordModel.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation

struct RecordModel: Codable, Hashable, Identifiable {
    var id: Int?
    let userUid: String
    let timeStamp: Double
    let recordTime: String
    var name: String?
    var recordUid: String
    var isSaved: Bool = false
    var isOnline: Bool = false
    
}
