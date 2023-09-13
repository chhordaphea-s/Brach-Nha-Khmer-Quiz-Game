//
//  AnswerView.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 5/9/23.
//

import Foundation

struct AnswerView{
    let title : String
    let index : Int
    let correctAnswer : String
    
    init(index: Int, title: String, correctAnswer: String) {
        self.title = title
        self.index = index
        self.correctAnswer = correctAnswer
    }
}
