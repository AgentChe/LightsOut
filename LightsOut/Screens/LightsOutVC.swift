//
//  LightsOutVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 16.05.2022.
//

import UIKit

class LightsOutVC: UIViewController {
    
    @IBOutlet weak var light0: LOSingleLightView!
    @IBOutlet weak var light1: LOSingleLightView!
    @IBOutlet weak var light2: LOSingleLightView!
    @IBOutlet weak var light3: LOSingleLightView!
    @IBOutlet weak var light4: LOSingleLightView!
    
    var lights: [LOSingleLightView]!
    
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
            defaults.set(isLifeTimeOn, forKey: "isTimerOn")
        }
    }
    var reactionTimeCounter = 0.0
    var lightsCountForStartSequence = 0
    var lifeCount: Int = 0 {
        didSet{
            print("DEBUG: Lifecount changed")
            defaults.set(lifeCount, forKey: "lifeCount")
            lifeView.updateLifeLabel(with: lifeCount)
            isLifeTimeOn = defaults.bool(forKey: "isTimerOn")
            lifeFillDate = defaults.double(forKey: "lifeFillDate")
            if lifeCount <= 0 {
                DispatchQueue.main.async {
                    self.instructionView.changeLabel(with: "You have no life.")
                    self.instructionView.isHidden = false
                }
                
                
                print("DEBUG: Lifecount is 0 so you cant play")
                if !isLifeTimeOn {
                    print("Life timer acildi")
                    isLifeTimeOn = true
                    lifeZeroDate = Date().timeIntervalSince1970
                    lifeFillDate = Date().timeIntervalSince1970 + 60
                    defaults.set(lifeFillDate, forKey: "lifeFillDate")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anonymousLogin()
        
        touchArea.touchAreaDelegate = self
        lifeView.lifeViewDelegate = self
        lights = [light0,light1,light2,light3,light4]
        
        lifeCount = defaults.integer(forKey: "lifeCount")
        
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
            print("DEBUG: \(error)")
        }
    }
    
    func lightsUpInOrder() {
        oneSecLightTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(lightsRed), userInfo: nil, repeats: true)
    }
    
    @objc func lightsRed() {
        lights[lightsCountForStartSequence].turnRed()
        lightsCountForStartSequence += 1
        
        if lightsCountForStartSequence == 5 {
            instructionView.changeLabel(with: "Wait until all lights OUT!")
            lightsCountForStartSequence = 0
            oneSecLightTimer?.invalidate()
            lightsOut()
        }
    }
    
    func lightsOut() {
        let randomTime = Double.random(in: 1...6)
        randomLightsOutTimer = Timer.scheduledTimer(withTimeInterval: randomTime, repeats: false, block: { [self] _ in
            for light in self.lights {
                light.turnDefault()
            }
            self.reactionCounterTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            instructionView.changeLabel(with: "Release!")
        })
    }
    
    @objc func updateTimer() {
        reactionTimeCounter += 0.001
    }
    
    
}

extension LightsOutVC: LOTouchAreaDelegate {
    func startGame() {
        instructionView.isHidden = false
        instructionView.changeLabel(with: "Wait until all lights ON!")
        lightsUpInOrder()
    }
    
    func endGame() {
        let generator = UINotificationFeedbackGenerator()
        
        if reactionTimeCounter <= 0 {
            // If user release BEFORE all lights out
            lifeCount -= 1
            lifeView.lifeUpOrDownAnimation(lifeCase: .down)
            defaults.set(lifeCount, forKey: "lifeCount")
            print("DEBUG: Lifecount down \(lifeCount)")
            
            instructionView.changeLabel(with: "Fail try again!")
            generator.notificationOccurred(.error)
            
        } else {
            // If user release AFTER all lights out
            instructionView.changeLabel(with: "Your reaction time: \(reactionTimeCounter.convertThreePointString())")
            let timeStamp = Double(Date().timeIntervalSince1970)
            guard let userUid = userUid else {
                print("DEBUG: USER UID IS NIL")
                return
            }
            let newRecord = RecordModel(userUid: userUid, timeStamp: timeStamp, recordTime: reactionTimeCounter.convertThreePointString(), recordUid: UUID().uuidString)
            //DatabaseManager.shared.saveNewRecord(with: newRecord)
            DatabaseManager.shared.addNewRecordToSqliteDb(record: newRecord) { error in
                guard let error = error else { return }
                print("DEBUG: Error to save \(error)")
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
        
    }
}

extension LightsOutVC: LOLifeViewDelegate {
    func didTapAddLifeButton() {
        print("DEBUG: Add life Button Tapped")
        lifeCount += 1
        lifeView.lifeUpOrDownAnimation(lifeCase: .up)
    }
    
    
}
