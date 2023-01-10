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
    enum SectionCounts {
        static let leagueVC = 3
        static let settingsVC = 3
    }
    
    enum ItemCounts {
        static let leagueVCSection0 = 2
        static let leagueVCSection1 = UserDefaults.standard.bool(forKey: Constants.Keys.getPro) ? 0 : 1
        static let settingsVCSection0 = 2
        static let settingsVCSection1 = 1
        static let settingsVCSection2 = 4
    }
    
    
    //static let sectionCount = 3
    static let globalPadding: CGFloat = 20
    
    enum NotificationKeys {
        static let updateLeagueInfo = "com.foytingo.updateLeagueInfo"
        static let goLeagueNotificationKey = "com.foytingo.goLeagueNotificationKey"
        static let deleteActionInfo = "com.foytingo.deleteActionInfo"
    }
    
    enum Screens {
        static let yourLeagueVC = "YourLeagueVC"
        static let localRecordsVC = "LocalRecordsVC"
        static let onlineRecordsVC = "OnlineRankingsVC"
    }
    
    enum CellReuseID {
        static let fullSizeCell = "LOFullSizeCell"
        static let squareCell = "LOSquareCell"
        static let localRecordCell = "LOLocalRecordCell"
        static let onlineRecordCell = "LOOnlineRecordCell"
        static let bannerCell = "LOBannerCell"
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
        static let goToYourLeague = "goToYourLeague"
    }
    
    enum AdMobKeys {
        static let interstitial = "ca-app-pub-3477689894846816/4448806502"
        static let banner = "ca-app-pub-3477689894846816/9988019748"
        static let rewarded = "ca-app-pub-3477689894846816/8196479825"
    }
}


