//
//  LocalizedStrings.swift
//  LightsOut
//
//  Created by Murat Baykor on 10.06.2022.
//

import Foundation

enum LocalizedErrorMessages {
    static let somethingWentWrong = NSLocalizedString("Something went wrong", comment: "")
    static let unableToComplete = NSLocalizedString("Unable to complete your request. Please try again.", comment: "")
    static let unableToConnectDatabase = NSLocalizedString("The app could not connected to database. Please reopen the app.", comment: "")
    static let unableToCreateDatabase = NSLocalizedString("The database could not be created. Please reopen the app.", comment: "")
    static let unableToSaveNewRecord = NSLocalizedString("The new records could not be saved.", comment: "")
    static let unableToGetAllRecords = NSLocalizedString("All records could not be got from database. Please try again.", comment: "")
    static let unableToDelete = NSLocalizedString("The record could not be deleated from database.", comment: "")
    static let cantGetSingleRecordFromDB = NSLocalizedString("The record could not be got from database.", comment: "")
    static let updateErrorInLocalDB = NSLocalizedString("The record could not be updated in database.", comment: "")
    static let cantCalculateAvarageForChart = NSLocalizedString("The avarege reaction time could not be calculated for chart.", comment: "")
    static let wrongLeaguePassword = NSLocalizedString("The password is wrong. Please check it and try again.", comment: "")
    static let cantFoundLeague = NSLocalizedString("The league could not be found. Please check league number and try again.", comment: "")
    static let cantJoinLeague = NSLocalizedString("You could not join this league. Please try again.", comment: "")
    static let checkYourPassword = NSLocalizedString("Check your password.", comment: "")
    static let alreadyInLeague = NSLocalizedString("You are already in this league.", comment: "")
    static let cantCreateLeague = NSLocalizedString("The league could not be created. Please try againg", comment: "")
}
