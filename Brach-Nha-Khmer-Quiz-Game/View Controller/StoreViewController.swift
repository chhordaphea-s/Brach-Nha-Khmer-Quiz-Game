//
//  BuyHintViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/14/23.
//

import UIKit
import BetterSegmentedControl



class StoreViewController: UIViewController {

    @IBOutlet weak var hintCollectionView: UICollectionView!
    @IBOutlet weak var customHintSagementControl: BetterSegmentedControl!
    
    let layout = PagingCollectionViewLayout()
    
    var backDirection: UIViewController? = nil

    
    
    
    
    // MARK: - Body
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
//        setupSagementControl()

    }
    
    @IBAction func restoreButtonPressed(_ sender: UIButton) {
        print("Restore Button Pressed ....")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        backButton()
    }
    

    
    // MARK: - Function
    
    func setupCollectionView() {
        hintCollectionView.delegate = self
        hintCollectionView.dataSource = self
        
        let lrIns = findLeftAndRightInset(viewWidth: 222)
        
        layout.itemSize = CGSize(width: 222, height: 340)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: lrIns, bottom: 0, right: lrIns)
        layout.scrollDirection = .horizontal
        
        hintCollectionView.collectionViewLayout = layout
        
        hintCollectionView.backgroundColor = .clear

        hintCollectionView.register(UINib.init(nibName: "HintCustomCell", bundle: nil), forCellWithReuseIdentifier: "HintCustomCell")
    }
    
    func findLeftAndRightInset(viewWidth: CGFloat) -> CGFloat {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let lrInset = (screenWidth - viewWidth) / 2
        
        return lrInset
    }
    
    func backButton() {
        var controller = UIViewController()
        
        guard let bd = backDirection else { return }
        
        print("ID", bd.restorationIdentifier)
        
        if bd.restorationIdentifier == "MainViewController" {
            controller = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        } else if bd.restorationIdentifier == "GameChoosingViewController" {
            controller = storyboard?.instantiateViewController(withIdentifier: "GameChoosingViewController") as! GameChoosingViewController
        } else {
            return
        }
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
    }
    
    
    func setupSagementControl() {
        customHintSagementControl.segments = LabelSegment.segments(withTitles: ["ជំនួយ៖ ប្រាប់ចម្លើយ", "ជំនួយ៖ ៥០:៥០"],
                                                         normalBackgroundColor: Constant.color.getClearColor(),
                                                         normalTextColor: Constant.color.getTextColor(),
                                                         selectedBackgroundColor: Constant.color.getPrimaryColor(),
                                                         selectedTextColor: UIColor.white)

    }
    
    
}

extension StoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HintCustomCell", for: indexPath) as! HintCustomCell
        
        
        
        return cell
    }
}
 
