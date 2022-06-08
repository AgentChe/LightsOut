//
//  Constants.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 27.05.2022.
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
}

enum Keys {
    static let records = "records"
    static let playCountKey = "playCountKey"
    static let lastVersionPromptedForReviewKey = "lastVersionPromptedForReviewKey"
    static let adsFree = "adsFree"
    static let getPro = "getPro"
    static let soundSettings = "soundSettings"
}
