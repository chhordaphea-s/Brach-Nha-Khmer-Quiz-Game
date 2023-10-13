//
//  AudioHelper.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/3/23.
//

import Foundation
import AVFoundation

class AudioHelper {

    var player: AVAudioPlayer?

    func musicConfigure(audioName: String, ext: String = "mp3") {
        guard let path = Bundle.main.path(forResource: audioName, ofType:ext) else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            if audioName == "failed" {
                self.player?.volume = 2
            }
            if soundEffect {
                self.player?.play()
            }
   
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    init(audioName: String, player: AVAudioPlayer? = nil, loop: Bool = false) {
        musicConfigure(audioName: audioName)
        player?.numberOfLoops = loop ? -1 : 0
    }
    
    init() { }
    
    func play() {
        self.player?.play()
    }
    
    func pause() {
        self.player?.pause()
    }
    
    func setVolumn(volumn: Float) {
        self.player?.volume = volumn
    }
    
}
