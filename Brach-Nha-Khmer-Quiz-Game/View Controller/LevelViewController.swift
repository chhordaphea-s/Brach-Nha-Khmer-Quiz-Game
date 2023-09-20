//
//  LevelViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 24/8/23.
//

import UIKit

class LevelViewController: UIViewController {

    @IBOutlet weak var levelCollectionView: UICollectionView!
    @IBOutlet weak var titleGame: UILabel!
    
    var game: Game? = nil
    
    let answerHintView = HintPopupView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGameTitle()
        
        levelCollectionView.dataSource = self
        levelCollectionView.delegate = self
        levelCollectionView.backgroundColor = .clear
        
        levelCollectionView.register(UINib.init(nibName: "LevelCustomCell", bundle: nil), forCellWithReuseIdentifier: "LevelCustomCell")
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        backToLevelScreen()
    }
    
    func switchToReadingQuestionScreen(levelData: Level) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ReadingQuestionViewController") as! ReadingQuestionViewController
        
        controller.gamePlay = GamePlay(gameKey: game?.key ?? "",
                                       level: levelData,
                                       question: 1,
                                       score: 0,
                                       fail: 0,
                                       timings: 0,
                                       answerHint: HintButton(type: .answer, num: answerHint, enable: true),
                                       halfhalfHint: HintButton(type: .halfhalf, num: halfHint, enable: true),
                                       star: 0,
                                       highestScore: 0)
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
    }
    
    func configGameTitle() {
        titleGame.text = game?.title
    }
    
    func setupColorLevelForEachGame () -> [CGColor] {
        switch game?.key {
        case "riddle":
            return [UIColor(rgb: 0x2FD85C).cgColor, UIColor(rgb: 0x379C73).cgColor]
        case "proverb":
            return [UIColor(rgb: 0x2FB9D8).cgColor, UIColor(rgb: 0x37659C).cgColor]
        case "generalknowledge":
            return [UIColor(rgb: 0xD72DC0).cgColor, UIColor(rgb: 0x920EA6).cgColor]
        default:
            return [UIColor(rgb: 0x2FD85C).cgColor, UIColor(rgb: 0x379C73).cgColor]
        }
    }
    
    func backToLevelScreen(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "GameChoosingViewController") as! GameChoosingViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
        
    }
    
    
    func popUpAnswerHintView() {

        let width: Float = 324
        let height: Float = 276
        
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: answerHintView, width: width, height: height)
        
        NSLayoutConstraint.activate([
            answerHintView.widthAnchor.constraint(equalToConstant: CGFloat(width)),
            answerHintView.heightAnchor.constraint(equalToConstant: CGFloat(height)),
            answerHintView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            answerHintView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

}

extension LevelViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game?.levels.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCustomCell", for: indexPath) as! LevelCustomCell
        
        let tmpData = LevelViewModel(color1: setupColorLevelForEachGame()[0],
                                  color2: setupColorLevelForEachGame()[1],
                                  levelNum: game?.levels[indexPath.row].level ?? 0,
                                  star: 1)
        
        cell.cellConfiguration(data: tmpData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let levelData = game?.levels[indexPath.row] else { return }
        print(levelData)
        switchToReadingQuestionScreen(levelData: levelData)
    
    }
    
}

