//
//  LightsOutVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit
import StoreKit

class LightsOutVC: UIViewController {
    
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
            print("DEBUG: Lifecount changed")
            defaults.set(lifeCount, forKey: Constants.Keys.lifeCount)
            lifeView.updateLifeLabel(with: lifeCount)
            isLifeTimeOn = defaults.bool(forKey: Constants.Keys.isTimerOn)
            lifeFillDate = defaults.double(forKey: Constants.Keys.lifeFillDate)
            if lifeCount <= 0 {
                DispatchQueue.main.async {
                    self.instructionView.changeLabel(with: LocalizedStrings.noLife)
                    self.instructionView.isHidden = false
                }
                
                
                print("DEBUG: Lifecount is 0 so you cant play")
                if !isLifeTimeOn {
                    print("Life timer acildi")
                    isLifeTimeOn = true
                    lifeZeroDate = Date().timeIntervalSince1970
                    lifeFillDate = Date().timeIntervalSince1970 + 60
                    defaults.set(lifeFillDate, forKey: Constants.Keys.lifeFillDate)
                    lifeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTestTimer), userInfo: nil, repeats: true)
                } else {
                    print("Life timer Zaten acik")
                    lifeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTestTimer), userInfo: nil, repeats: true)
                    if Date().timeIntervalSince1970 >= lifeFillDate {
                        print("Can eklenebilir zaman dolmus")
                        addOneToLifeCount()
                        isLifeTimeOn = false
                        lifeTimer?.invalidate()
                    }
                    
                }
            }
        }
    }
    
    
    var removedAdsButtonTapped = false
    var isPro: Bool? {
        didSet {
            if isPro == false && oldValue == nil {
                print("DEBUG: Pro Olunmadi")
//                requestIDFA()
            } else if isPro == true {
                getProButton.isHidden = true
                getProButton.isEnabled = false
                lifeView.isHidden = true
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anonymousLogin()
        
        touchArea.touchAreaDelegate = self
        lifeView.lifeViewDelegate = self
        lights = [light0,light1,light2,light3,light4]
        
        lifeCount = defaults.integer(forKey: Constants.Keys.lifeCount)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removedAdsButtonTapped = false
        isPro = isPurchased()
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

    
    func anonymousLogin() {
        FirebaseManager.shared.authAnonymous { uid, error in
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
        
        if lightsCountForStartSequence == 5 {
            instructionView.changeLabel(with: LocalizedStrings.waitLightsOut)
            lightsCountForStartSequence = 0
            oneSecLightTimer?.invalidate()
            lightsOut()
        }
    }
    
    func lightsOut() {
        let randomTime = Double.random(in: 1...3)
        print("DEBUG: \(randomTime)")
        randomLightsOutTimer = Timer.scheduledTimer(withTimeInterval: randomTime, repeats: false, block: { [self] _ in
            for light in self.lights {
                light.turnDefault()
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
        print("DEBUG: \(count)")
        switch count {
        case 14:
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        case _ where count%100 == 0 :
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
//        case _ where count % 4 == 0:
//            showInterstitialAd()
        default:
            break;
        }
    }
    
    
}

extension LightsOutVC: LOTouchAreaDelegate {
    func startGame() {
        PersistenceManager.shared.playCount()
        instructionView.isHidden = false
        instructionView.changeLabel(with: LocalizedStrings.waitLightsON)
        lightsUpInOrder()
    }
    
    func endGame() {
        let generator = UINotificationFeedbackGenerator()
        
        if reactionTimeCounter <= 0 {
            // If user release BEFORE all lights out
            if !isPro! {
                lifeCount -= 1
                lifeView.lifeUpOrDownAnimation(lifeCase: .down)
                defaults.set(lifeCount, forKey: Constants.Keys.lifeCount)
                print("DEBUG: Lifecount down \(lifeCount)")
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
        print("DEBUG: Add life Button Tapped")
        if !isPro! {
            lifeCount += 1
            lifeView.lifeUpOrDownAnimation(lifeCase: .up)
        }

    }
    
    
}
