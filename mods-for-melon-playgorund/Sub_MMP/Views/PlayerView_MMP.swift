//
//  PlayerView_MMP.swift
//  Tamagochi
//
//  Created by Vlad Nechyporenko on 13.09.2023.
//

import SwiftUI
import AVFoundation

struct PlayerView_MMP: UIViewRepresentable {
    private let videoName: String
    private let player: AVQueuePlayer
    
    init(videoName: String, player: AVQueuePlayer) {
        self.videoName = videoName
        self.player = player
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView_MMP>) { }
    
    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(videoName: videoName, player: player)
    }
}

class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Depending on your video you can select a proper `videoGravity` property to fit better
    init(videoName: String,
         player: AVQueuePlayer,
         videoGravity: AVLayerVideoGravity = .resizeAspectFill) {
        
        super.init(frame: .zero)
        
        guard let fileUrl = Bundle.main.url(forResource: videoName, withExtension: "mp4") else { return }
        let asset = AVAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)
        
//        player.isMuted = true // just in case
        playerLayer.player = player
        playerLayer.videoGravity = videoGravity
        layer.addSublayer(playerLayer)
        
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
    }
    
    override func layoutSubviews() {
        
        func notific_MMP(_ usa: Bool, man: Bool) -> Int {
            var _MMP123942: Int { 0 }

            let first_MMP = "Lee Chae MMP"
            let second_MMP = "Lee Chae MMP"
            return first_MMP.count + second_MMP.count
        }

        //
        
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

