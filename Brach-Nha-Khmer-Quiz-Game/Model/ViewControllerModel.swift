//
//  ViewControllerModel.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/29/23.
//

import UIKit

struct ViewControllerModel {
    let controller: UIViewController
    let storyboardID: String
    
    init(controller: UIViewController, storyboardID: String? = nil) {
        self.controller = controller
        
        if let storyboardID = storyboardID {
            self.storyboardID = storyboardID
        } else {
            self.storyboardID = "\(controller.self)"
        }
    }
    

}

//
//enum viewController {
//    case AnswerController,
//         GameChoosingViewController,
//         LevelViewController,
//         MainViewController,
//         ReadingQuestionViewController,
//         StoreViewController,
//         WinOrLoseViewController,
//         DummyViewController
//}
