//
//  LevelViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 24/8/23.
//

import UIKit

class LevelViewController: UIViewController {

    @IBOutlet weak var levelCollectionView: UICollectionView!
    
    let sampleData = [
        LevelViewModel(star: 3, levelNum: 1),
        LevelViewModel(star: 1, levelNum: 2),
        LevelViewModel(star: 2, levelNum: 3),
        LevelViewModel(star: 3, levelNum: 4),
        LevelViewModel(star: 3, levelNum: 5),
        LevelViewModel(star: 3, levelNum: 6),
        LevelViewModel(star: 3, levelNum: 7),
        LevelViewModel(star: 3, levelNum: 8),
        LevelViewModel(star: 3, levelNum: 9),
        LevelViewModel(star: 3, levelNum: 10),
        LevelViewModel(star: 3, levelNum: 11),
        LevelViewModel(star: 3, levelNum: 12),
        LevelViewModel(star: 3, levelNum: 13),
        LevelViewModel(star: 3, levelNum: 14),
        LevelViewModel(star: 3, levelNum: 15),
        LevelViewModel(star: 3, levelNum: 16),
        LevelViewModel(star: 3, levelNum: 17),
        LevelViewModel(star: 3, levelNum: 18),
        LevelViewModel(star: 3, levelNum: 19),
        LevelViewModel(star: 0, levelNum: 20)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        levelCollectionView.dataSource = self
        levelCollectionView.delegate = self
        levelCollectionView.backgroundColor = .clear
        
        levelCollectionView.register(UINib.init(nibName: "LevelCustomCell", bundle: nil), forCellWithReuseIdentifier: "LevelCustomCell")
    }
    
    func switchToAnotherScreen(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "AnswerViewController") as! AnswerViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    

    
}

extension LevelViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCustomCell", for: indexPath) as! LevelCustomCell
        
        cell.levelGradientColor()
        
        cell.cellConfiguration(data: sampleData[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(sampleData[indexPath.row].levelNum)
        switchToAnotherScreen()
    }
    
    
    
}
