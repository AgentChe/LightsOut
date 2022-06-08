//
//  LOError.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation

enum LOError: String, Error, Codable {
    
    case unableToConnectDatabase, unableToCreateDatabase, dbWasCreatedSuccessfully, dbAlreadyCreated, unableToSaveNewRecord, unableToGetAllRecords, unableToDelete, cantGetSingleUserFromDB, updateErrorInLocalDb, cantCalculateAvarageForChart,wrongLeaguePassword, cantFoundLeague, cantJoinLeague, checkYourPassword, alreadyInLeague, createLeagueError
    
    var localizedDescription: String {
        switch self {
        case .unableToConnectDatabase:
            return "Cant be connected to database."
        case .unableToCreateDatabase:
            return "Cant create database."
        case .dbWasCreatedSuccessfully:
            return "Database was created successfuly"
        case .dbAlreadyCreated:
            return "Database was already created."
        case .unableToSaveNewRecord:
            return "New record cant be saved"
        case .unableToGetAllRecords:
            return "Cant be get all records from database"
        case .unableToDelete:
            return "Cant be deleated record from database"
        case .cantGetSingleUserFromDB:
            return "Cant get single record from database"
        case .updateErrorInLocalDb:
            return "Cant update record in local db"
        case .cantCalculateAvarageForChart:
            return "Cant calculate avarage for chart"
        case .wrongLeaguePassword:
            return "Wrong league password"
        case .cantFoundLeague:
            return "Cant found league"
        case .cantJoinLeague:
            return "Something went wrong Cant join league"
        case .checkYourPassword:
            return "Check your password"
        case .alreadyInLeague:
            return "You have already in lig"
        case .createLeagueError:
            return "Cant create league"
        }
    }
}
