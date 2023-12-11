//
//  AVAudioPlayerManager_MMP.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 17.11.2023.
//

import SwiftUI
import AVKit

final class AVAudioPlayerController_MMP: NSObject, ObservableObject {

    var mainPlayer: AVAudioPlayer?

    override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Logger.error_MMP(error)
        }
    }

    func playNewTrack(with data: Data) {
        do {
            mainPlayer = try AVAudioPlayer(data: data)
            mainPlayer?.prepareToPlay()
            mainPlayer?.play()
        } catch {
            Logger.error_MMP(error)
        }
    }

    func stopSound() {
        if !mainPlayer.isNil {
            mainPlayer?.stop()
            mainPlayer = nil
        }
    }

    func stopSession_MMP() {
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)

        stopSound()
    }
}
