//
//  MusicManager.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/3/23.
//

import Foundation

let userdefault = UserDefaults.standard

let backgroundMusic = AudioHelper(audioName: "background", player: nil, loop: true)
var buttonSoudEffect = AudioHelper()

var soundEffect: Bool {
    return userdefault.bool(forKey: Constant.userdefault.soundEffect)
}
var vibrate: Bool = true

