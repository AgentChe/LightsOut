//
//  LeagueModel.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation

struct LeagueModel: Codable {
    let leagueId: Int
    let leagueName: String
    let leaguePassword: Int
    let creatorUid: String
    let participantCount: Int
    let participantsUids: [String]
    let recordsInLeagues: [OnlineRecordModel]?
    
    enum CodingKeys: String, CodingKey {
            case leagueId
            case leagueName
            case leaguePassword
            case creatorUid
            case participantCount
            case participantsUids
            case recordsInLeagues
        }
}
