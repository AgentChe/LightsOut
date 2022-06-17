//
//  LOError.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation

enum LOError: String, Error, Codable {
    
    case unableToConnectDatabase, unableToCreateDatabase, unableToSaveNewRecord, unableToGetAllRecords, unableToDelete, cantGetSingleUserFromDB, updateErrorInLocalDb, cantCalculateAvarageForChart,wrongLeaguePassword, cantFoundLeague, cantJoinLeague, checkYourPassword, alreadyInLeague, createLeagueError, checkYourInternet, pleaseReopenApp, cantGetYourLeagues, cantGetRecordsInLeague
    
    var localizedDescription: String {
        switch self {
        case .unableToConnectDatabase:
            return LocalizedErrorMessages.unableToConnectDatabase
        case .unableToCreateDatabase:
            return LocalizedErrorMessages.unableToCreateDatabase
//        case .dbWasCreatedSuccessfully:
//            return "Database was created successfuly"
//        case .dbAlreadyCreated:
//            return "Database was already created."
        case .unableToSaveNewRecord:
            return LocalizedErrorMessages.unableToSaveNewRecord
        case .unableToGetAllRecords:
            return LocalizedErrorMessages.unableToGetAllRecords
        case .unableToDelete:
            return LocalizedErrorMessages.unableToDelete
        case .cantGetSingleUserFromDB:
            return LocalizedErrorMessages.cantGetSingleRecordFromDB
        case .updateErrorInLocalDb:
            return LocalizedErrorMessages.updateErrorInLocalDB
        case .cantCalculateAvarageForChart:
            return LocalizedErrorMessages.cantCalculateAvarageForChart
        case .wrongLeaguePassword:
            return LocalizedErrorMessages.wrongLeaguePassword
        case .cantFoundLeague:
            return LocalizedErrorMessages.cantFoundLeague
        case .cantJoinLeague:
            return LocalizedErrorMessages.cantJoinLeague
        case .checkYourPassword:
            return LocalizedErrorMessages.checkYourPassword
        case .alreadyInLeague:
            return LocalizedErrorMessages.alreadyInLeague
        case .createLeagueError:
            return LocalizedErrorMessages.cantCreateLeague
        case .checkYourInternet:
            return LocalizedErrorMessages.checkYourInternet
        case .pleaseReopenApp:
            return LocalizedErrorMessages.pleaseReopenApp
        case .cantGetYourLeagues:
            return LocalizedErrorMessages.cantGetYourLeagues
        case .cantGetRecordsInLeague:
            return LocalizedErrorMessages.cantGetRecordsInLeague
        }
    }
}
