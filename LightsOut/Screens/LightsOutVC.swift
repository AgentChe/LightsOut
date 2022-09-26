//
//  LightsOutVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit
import StoreKit
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds
import Network

class LightsOutVC: LODataLoadingVC {
    
    let monitor = NWPathMonitor()
    
    @IBOutlet weak var light0: LOSingleLightView!
    @IBOutlet weak var light1: LOSingleLightView!
    @IBOutlet weak var light2: LOSingleLightView!
    @IBOutlet weak var light3: LOSingleLightView!
    @IBOutlet weak var light4: LOSingleLightView!
    
    var lights: [LOSingleLightView]!
    
    @IBOutlet var getProButton: UIButton!
    @IBOutlet weak var lifeView: LOLifeView!
    @IBOutlet weak var touchArea: LOTouchAreaView!
    @IBOutlet weak var instructionView: LOInstructionView!
    @IBOutlet var lifeCountDownLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    var userUid: String?
    let userCalendar = Calendar.current
    var lifeFillDate = 0.0
    var lifeTimer: Timer?
    var lifeZeroDate: Double?
    
    var oneSecLightTimer: Timer?
    var randomLightsOutTimer: Timer?
    var reactionCounterTimer: Timer?
    var isLifeTimeOn: Bool = false {
        didSet {
            defaults.set(isLifeTimeOn, forKey: Constants.Keys.isTimerOn)
        }
    }
    var reactionTimeCounter = 0.0
    var lightsCountForStartSequence = 0
    var lifeCount: Int = 0 {
        didSet{
            defaults.set(lifeCount, forKey: Constants.Keys.lifeCount)
            lifeView.updateLifeLabel(with: lifeCount)
            isLifeTimeOn = defaults.bool(forKey: Constants.Keys.isTimerOn)
            lifeFillDate = defaults.double(forKey: Constants.Keys.lifeFillDate)
            if lifeCount <= 0 {
                DispatchQueue.main.async {
                    self.instructionView.changeLabel(with: LocalizedStrings.noLife)
                    self.instructionView.isHidden = false
                }
                
                if !isLifeTimeOn {
                    isLifeTimeOn = true
                    lifeZeroDate = Date().timeIntervalSince1970
                    lifeFillDate = Date().timeIntervalSince1970 + 60
                    defaults.set(lifeFillDate, forKey: Constants.Keys.lifeFillDate)
                    lifeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTestTimer), userInfo: nil, repeats: true)
                } else {
                    lifeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTestTimer), userInfo: nil, repeats: true)
                    if Date().timeIntervalSince1970 >= lifeFillDate {
                        addOneToLifeCount()
                        isLifeTimeOn = false
                        lifeTimer?.invalidate()
                    }
                    
                }
            }
        }
    }
    
    var isSoundOn: Bool = false
    
    var removedAdsButtonTapped = false
    var isPro: Bool? {
        didSet {
            if isPro == false && oldValue == nil {
                requestIDFA()

            } else if isPro == true {
                getProButton.isHidden = true
                getProButton.isEnabled = false
                lifeView.isHidden = true
            }
            
        }
    }
    
    var showedRewardedAds = false
    var didEarnLife = false
    private var interstitial: GADInterstitialAd?
    private var rewardedAd: GADRewardedAd? {
        didSet {
            rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anonymousLogin()
        
        touchArea.touchAreaDelegate = self
        lifeView.lifeViewDelegate = self
        lights = [light0,light1,light2,light3,light4]

        lifeCount = defaults.integer(forKey: Constants.Keys.lifeCount)
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removedAdsButtonTapped = false
        isPro = isPurchased()
        isSoundOn = UserDefaults.standard.bool(forKey: Constants.Keys.soundSettings)
    }
    
    func checkConnectionAndShowAlertAndReturn(withMessage message: LOError) {
        if monitor.currentPath.status == .unsatisfied {
            presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: message.localizedDescription)
        }
    }
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: Constants.Keys.getPro)
        return purchaseStatus ? true : false
    }
    
    func addOneToLifeCount() {
        lifeCount += 1
        lifeView.lifeUpOrDownAnimation(lifeCase: .up)
        DispatchQueue.main.async {
            self.instructionView.changeLabel(with: "")
            self.instructionView.isHidden = true
        }
    }
    
    @objc func updateTestTimer() {
        let currentDate = Date().timeIntervalSince1970
        let timeLeft = userCalendar.dateComponents([.minute, .second], from: Date(timeIntervalSince1970: currentDate), to: Date(timeIntervalSince1970: lifeFillDate))
        lifeCountDownLabel.text =  "\(timeLeft.minute!)m \(timeLeft.second!)s"
        if currentDate >= lifeFillDate {
            isLifeTimeOn = false
            lifeTimer?.invalidate()
            addOneToLifeCount()
            lifeCountDownLabel.text = ""
        }
    }
    
    func requestIDFA() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//                self.createAndLoadInterstitial()
                //self.createAndloadRewardedAd()
            })
        })
    }
    
    func createAndLoadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: Constants.AdMobKeys.interstitial,
                               request: request,
                               completionHandler: { [self] ad, error in
            if error != nil {
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    func showInterstitialAd() {
        if interstitial != nil && !isPro! {
            interstitial?.present(fromRootViewController: self)
        }
    }
    
    func createAndloadRewardedAd() {
        showLoadingView()
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: Constants.AdMobKeys.rewarded,
                           request: request,
                           completionHandler: { [self] ad, error in
            dismissLoadingView()
            if error != nil {
                self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: LocalizedErrorMessages.unableToComplete)
                return
            }
            rewardedAd = ad
            
                ad?.present(fromRootViewController: self) {
                let reward = ad?.adReward
                    if reward?.amount.doubleValue ?? 0.0 > 0 {
                    self.didEarnLife = true
                }
                
            }
        })
        
        
    }
    
//    func showRewarded() {
//        if let ad = rewardedAd {
//            ad.present(fromRootViewController: self) {
//                let reward = ad.adReward
//                if reward.amount.doubleValue > 0 {
//                    self.didEarnLife = true
//                }
//            }
//        } else {
//            self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: LocalizedErrorMessages.unableToComplete)
//        }
//    }
    
    func anonymousLogin() {
        FirebaseManager.shared.authAnonymous { [weak self] uid, error in
            guard let self = self else { return }
            guard let error = error else {
                self.userUid = uid
                return
            }
            self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
        }
    }
    
    func lightsUpInOrder() {
        oneSecLightTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(lightsRed), userInfo: nil, repeats: true)
    }
    
    @objc func lightsRed() {
        lights[lightsCountForStartSequence].turnRed()
        lightsCountForStartSequence += 1
        if isSoundOn {
            LOAudioPlayer.shared.playsound(soundType: .lights)
        }
        
        if lightsCountForStartSequence == 5 {
            instructionView.changeLabel(with: LocalizedStrings.waitLightsOut)
            lightsCountForStartSequence = 0
            oneSecLightTimer?.invalidate()
            lightsOut()
        }
    }
    
    func lightsOut() {
        let randomTime = Double.random(in: 1...5)
        randomLightsOutTimer = Timer.scheduledTimer(withTimeInterval: randomTime, repeats: false, block: { [self] _ in
            for light in self.lights {
                light.turnDefault()
            }
            
            if isSoundOn {
                LOAudioPlayer.shared.playsound(soundType: .start)
            }
            self.reactionCounterTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            instructionView.changeLabel(with: LocalizedStrings.release)
        })
    }
    
    @objc func updateTimer() {
        reactionTimeCounter += 0.001
    }
    
    func rateRequest() {
        let count = UserDefaults.standard.integer(forKey: Constants.Keys.playCountKey)
        switch count {
        case 14:
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        case _ where count%100 == 0 :
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        case _ where count % 6 == 0:
            showInterstitialAd()
        default:
            break;
        }
    }
    
    
    func createInterstitialAdGameStart() {
        let count = UserDefaults.standard.integer(forKey: Constants.Keys.playCountKey)
        print("DEBUG: \(count)")
        if count % 6 == 0 {
            createAndLoadInterstitial()
        }
        
    }
    
}

extension LightsOutVC: LOTouchAreaDelegate {
    func startGame() {
        PersistenceManager.shared.playCount()
        instructionView.isHidden = false
        instructionView.changeLabel(with: LocalizedStrings.waitLightsON)
        lightsUpInOrder()
        createInterstitialAdGameStart()
    }
    
    func endGame() {
        let generator = UINotificationFeedbackGenerator()
        
        if reactionTimeCounter <= 0 {
            // If user release BEFORE all lights out
            if !isPro! {
                lifeCount -= 1
                lifeView.lifeUpOrDownAnimation(lifeCase: .down)
                defaults.set(lifeCount, forKey: Constants.Keys.lifeCount)
            }
            
            instructionView.changeLabel(with: LocalizedStrings.fail)
            generator.notificationOccurred(.error)
            
        } else {
            // If user release AFTER all lights out
            instructionView.changeLabel(with: "\(LocalizedStrings.yourReactionTime) \(reactionTimeCounter.convertThreePointString())")
            let timeStamp = Double(Date().timeIntervalSince1970)
            guard let userUid = userUid else { return }
            let newRecord = RecordModel(userUid: userUid, timeStamp: timeStamp, recordTime: reactionTimeCounter.convertThreePointString(), recordUid: UUID().uuidString)
            DatabaseManager.shared.addNewRecordToSqliteDb(record: newRecord) { error in
                guard let error = error else { return }
                self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
            }
            generator.notificationOccurred(.success)
        }
        
        //Reset Game Commands
        for light in self.lights {
            light.turnDefault()
        }
        reactionCounterTimer?.invalidate()
        randomLightsOutTimer?.invalidate()
        oneSecLightTimer?.invalidate()
        reactionTimeCounter = 0.0
        lightsCountForStartSequence = 0
        
        
        rateRequest()
    }
}

extension LightsOutVC: LOLifeViewDelegate {
    func didTapAddLifeButton() {
        checkConnectionAndShowAlertAndReturn(withMessage: .checkYourInternet)
        if !isPro! {

            let ac = UIAlertController(title: LocalizedAlertboxStrings.addLife, message: LocalizedAlertboxStrings.addLifeDesc, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.watchAdsButton, style: .default, handler: { action in
                self.showedRewardedAds = true
                self.createAndloadRewardedAd()
            }))
            
            ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.getProButton, style: .default, handler: { action in
                self.performSegue(withIdentifier: Constants.Segues.goToGetPro, sender: self)
            }))
            
            ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.cancel, style: .cancel))
            
            present(ac, animated: true)
        }
        
    }
    
    
}

extension LightsOutVC: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("DEBUG: BOOOO")
        if showedRewardedAds {
            showedRewardedAds = false
//            createAndloadRewardedAd()
            if didEarnLife {
                print("DEBUG: zzaaaaa")
                lifeCount += 1
                lifeView.lifeUpOrDownAnimation(lifeCase: .up)
                didEarnLife = false
            }
//        } else {
//            createAndLoadInterstitial()
        }
        
    }
}
