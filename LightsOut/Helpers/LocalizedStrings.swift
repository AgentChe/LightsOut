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

enum LocalizedAlertboxStrings {
    static let done = NSLocalizedString("Done", comment: "")
    static let cancel = NSLocalizedString("Cancel", comment: "")
    static let next = NSLocalizedString("Next", comment: "")
    static let delete = NSLocalizedString("Delete", comment: "")
    static let error = NSLocalizedString("Error", comment: "")
    static let create = NSLocalizedString("Create", comment: "")
    static let join = NSLocalizedString("Join", comment: "")
    static let ok = NSLocalizedString("OK", comment: "")
    static let chooseAction = NSLocalizedString("Choose Action", comment: "")
    static let saveToOnline = NSLocalizedString("Save to Online Rankings", comment: "")
    static let getPro = NSLocalizedString("Get PRO", comment: "")
    static let getProDesc = NSLocalizedString("You can access the friends league if you will be a PRO", comment: "")
}

enum LocalizedStrings {
    static let yourRecords = NSLocalizedString("Your Records", comment: "")
    static let onlineRankings = NSLocalizedString("Online Rankings", comment: "")
    static let addLeague = NSLocalizedString("Add a league", comment: "")
    static let addLeagueDesc = NSLocalizedString("You can create a league or join a league", comment: "")
    static let seconds = NSLocalizedString("seconds", comment: "")
    static let avarageReaction = NSLocalizedString("You avarage reaction time:", comment: "")
    static let tapAndHold = NSLocalizedString("Tap and hold to start!", comment: "")
    static let tapAndHoldDescr = NSLocalizedString("When all lights off, release as quickly as you can.", comment: "")
    static let noLife = NSLocalizedString("You have no life.", comment: "")
    static let waitLightsOut = NSLocalizedString("Wait until all lights OUT!", comment: "")
    static let waitLightsON = NSLocalizedString("Wait until all lights ON!", comment: "")
    static let yourReactionTime = NSLocalizedString("Your reaction time:", comment: "")
    static let fail = NSLocalizedString("Fail try again!", comment: "")
    static let release = NSLocalizedString("Release", comment: "")
    static let gameSettings = NSLocalizedString("Game Settings", comment: "")
    static let aboutGame = NSLocalizedString("About", comment: "")
    static let proCell = NSLocalizedString("You are a pro", comment: "")
    static let proCellSub = NSLocalizedString("You have unlimited life and access friend leagues. No ads.", comment: "")
    static let becomeProCell = NSLocalizedString("Become a PRO!", comment: "")
    static let becomeProCellSub = NSLocalizedString("Remove ads and access friends leagues", comment: "")
    static let statisticsCell = NSLocalizedString("Statistics", comment: "")
    static let statisticsCellSub = NSLocalizedString("Your reaction time records and progression", comment: "")
    static let soundEffectCell = NSLocalizedString("Sound Effect", comment: "")
    static let soundEffectOn = NSLocalizedString("On", comment: "")
    static let soundEffectOff = NSLocalizedString("Off", comment: "")
    static let aboutGameCell = NSLocalizedString("About Game", comment: "")
    static let rateCell = NSLocalizedString("Rate on the App Store", comment: "")
    static let contactCell = NSLocalizedString("Contact / Feedback", comment: "")
    
    
}
