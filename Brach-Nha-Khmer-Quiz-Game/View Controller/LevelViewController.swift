//
//  LevelViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 24/8/23.
//

import UIKit
import UIImageViewAlignedSwift

class LevelViewController: UIViewController {

    @IBOutlet weak var backgoundImage: UIImageViewAligned!
    @IBOutlet weak var levelCollectionView: UICollectionView!
    @IBOutlet weak var titleGame: UILabel!
    
    var game: Game? = nil
    
    private let answerHintView = HintPopupView()
    private let databaseHelper = DatabaseHelper()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgoundImage.animateBackgroundImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGameTitle()
        
        levelCollectionView.dataSource = self
        levelCollectionView.delegate = self
        levelCollectionView.backgroundColor = .clear
        
        levelCollectionView.register(UINib.init(nibName: "LevelCustomCell", bundle: nil), forCellWithReuseIdentifier: "LevelCustomCell")
    }
    
    // MARK: - Action

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.gotoViewControllerWithoutParam(newController: GameChoosingViewController())
    }
    
    @IBAction func swipGasture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            self.gotoViewControllerWithoutParam(newController: GameChoosingViewController())
        default:
            return
        }
    }
    
    
    // MARK: - Function
    func switchToReadingQuestionScreen(levelData: Level) {
        guard let game = game else { return }
        let userData = databaseHelper.fetchData()
        guard let answerHint = userData.hint?.answerHint?.number else { return }
        guard let halfHint = userData.hint?.halfHint?.number else { return }

        
        
        let gamePlay = GamePlay(gameKey: game.key,
                                startPlayTime: Date(),
                                level: levelData,
                                answerHint: HintButton(type: .answer, num: answerHint, enable: true),
                                halfhalfHint: HintButton(type: .halfhalf, num: halfHint, enable: true),
                                highestScore: userData.game?.getGameByKey(key: game.key)?.getLevelGameFromLevelNum(levelNum: levelData.level)?.score ?? 0)

        self.gotoReadingQuestionViewController(data: gamePlay)
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
    
    func isLevelUnlocked(level: Level) -> Bool {
        guard let game = game else { return false }
        let userCompletedLevel = databaseHelper.getLevelCompleted(gameKey: game.key)
        
        var enable = false
        userCompletedLevel?.forEach({ levelCompleted in
            if level.level == levelCompleted.level {
                enable = true
            }
        })
        
        if !enable {
            if level.level == (userCompletedLevel?.last?.level ?? 0) + 1 {
                enable = true
            }
        }
        
        return enable
        
    }
    
    func getStarOfLevel(level: Level) -> Int{
        guard let game = game else { return 0 }
        let userCompletedLevel = databaseHelper.getLevelCompleted(gameKey: game.key)
        
        var star = 0
        userCompletedLevel?.forEach({ levelCompleted in
            if level.level == levelCompleted.level {
                star = levelCompleted.star
            }
        })
        return star
    }

}

    // MARK: - Delegate

extension LevelViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game?.levels.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCustomCell", for: indexPath) as! LevelCustomCell
        
        guard let level = game?.levels[indexPath.row] else { return cell }
        
        let tmpData = LevelViewModel(color1: setupColorLevelForEachGame()[0],
                                     color2: setupColorLevelForEachGame()[1],
                                     levelNum: level.level,
                                     star: getStarOfLevel(level: level),
                                     enable: isLevelUnlocked(level: level)
        )
        
        cell.cellConfiguration(data: tmpData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let levelData = game?.levels[indexPath.row] else { return }
        if isLevelUnlocked(level: levelData) {
            switchToReadingQuestionScreen(levelData: levelData)
        }
    }
    
}

