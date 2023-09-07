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
            self.player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    init(audioName: String, player: AVAudioPlayer? = nil, loop: Bool) {
        musicConfigure(audioName: audioName)
        player?.numberOfLoops = loop ? -1 : 1
    }
    
    init() {
    }
    
}
