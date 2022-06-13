//
//  LOAudioPlayer.swift
//  LightsOut
//
//  Created by Murat Baykor on 13.06.2022.
//

import AVFoundation

enum SoundType {
    case lights, start
}

class LOAudioPlayer {
    static let shared = LOAudioPlayer()
    
    private var audio: AVPlayer!
    
    private let lightsSoundUrl = Bundle.main.url(forResource: "beep2", withExtension: "wav")
    private let startSoundUrl = Bundle.main.url(forResource: "start", withExtension: "wav")
    
    func playsound(soundType: SoundType) {
        switch soundType {
        case .lights:
            audio = AVPlayer.init(url: lightsSoundUrl!)
        case .start:
            audio = AVPlayer.init(url: startSoundUrl!)
        }
        
        audio.play()
    }
}

