//
//  FetchGameData.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/9/23.
//

import Foundation

func loadGameData(filename fileName: String = "GameData") -> GameData? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(GameData .self, from: data)

            return jsonData
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}






//func loadJson(filename fileName: String) -> [Person]? {
//    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
//        do {
//            let data = try Data(contentsOf: url)
//            let decoder = JSONDecoder()
//            let jsonData = try decoder.decode(ResponseData.self, from: data)
//            return jsonData.person
//        } catch {
//            print("error:\(error)")
//        }
//    }
//    return nil
//}
