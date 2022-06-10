//
//  Constants.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

enum PaymentErrors {
    case cantMakePayment, loadError, paymentError, restoreError
}

struct Constants {
    static let sectionCount = 3
    static let globalPadding: CGFloat = 20
    
    static let createLeagueNotificationKey = "com.foytingo.createLeagueNotificationKey"
    static let joinLeagueNotificationKey = "com.foytingo.joinLeagueNotificationKey"
    static let goLeagueNotificationKey = "com.foytingo.goLeagueNotificationKey"
    static let leagueWasDeletedNotificationKey = "com.foytingo.leagueWasDeletedNotificationKey"
    
    enum CellReuseID {
        static let fullSizeCell = "LOLongSizeCell"
        static let squareCell = "LOSquareCell"
        static let localRecordCell = "LOLocalRecordCell"
        static let onlineRecordCell = "LOOnlineRecordCell"
    }
    
    enum HeaderReuseID {
        static let localRecordsHeader = "LOLocalRecordsHeaderView"
        static let leaguesHeader = "LOLeaguesHeaderView"
        static let leagueCategoryHeader = "categoryLeagueHeaderView"
        static let yourLeagueHeader = "YourLeagueHeaderView"
    }
    
    
    enum Keys {
        static let records = "records"
        static let playCountKey = "playCountKey"
        static let lastVersionPromptedForReviewKey = "lastVersionPromptedForReviewKey"
        static let adsFree = "adsFree"
        static let getPro = "getPro"
        static let soundSettings = "soundSettings"
        static let avarageReactionTime = "avarageReactionTime"
        static let lifeCount = "lifeCount"
        static let isItFirstOpen = "isItFirstOpen"
        static let isTimerOn = "isTimerOn"
        static let lifeFillDate = "lifeFillDate"
        static let isDbCreated = "isDbCreated"
    }
    
    enum Segues {
        static let goToAlert = "goToAlert"
        static let goToConfirmation = "goToConfirmationJoin"
        static let goToJoinLoading = "goToJoinLoading"
        static let goToLoading = "goToLoading"
        static let goToCreateLeague = "goToCreateLeague"
        static let goToJoinLeague = "goToJoinLeague"
        static let goToGetPro = "goToGetPro"
        static let goToAddName = "goToAddName"
        static let goToStatistics = "goToStatistics"
        static let goToContacts = "goToContact"
        static let goToAboutGame = "goToAboutGame"
        static let goToAddRecordsToLeague = "goToAddRecordsToLeague"
    }
    
}


