//
//  BuyHintViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/14/23.
//

import UIKit
import StoreKit
import BetterSegmentedControl
import UIImageViewAlignedSwift



class StoreViewController: UIViewController {

    @IBOutlet weak var hintCollectionView: UICollectionView!
    @IBOutlet weak var customHintSagementControl: BetterSegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageViewAligned!
    
    
    private let layout = PagingCollectionViewLayout()
    private let hintView = HintPopupView()
    private var hintSelected: HintType = .answer
    private var products = [SKProduct]()
    private var hints = [HintCustomCellModel]()
    private var filterProducts = [SKProduct]()
    private var selectHintProduct: HintProduct?

    private let rewardedInterstitialAd = RewardedInterstitialAd()
    private let storeKitHelper = StoreKitHelper()
    private var adsUsed = false

    // MARK: - Body
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundImage.animateBackgroundImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hintView.delegate = self
        
        setupCollectionView()
        setupSagementControl()

        storeKitHelper.fetchProduct()
        storeKitHelper.delegate = self

        rewardedInterstitialAd.adsLoads(controller: self)
        rewardedInterstitialAd.delegate = self
        
    }

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func hintSagementChanged(_ sender: BetterSegmentedControl) {
        switch sender.index {
        case 0: 
            hintSelected = .answer
        case 1:
            hintSelected = .halfhalf
        default:
            hintSelected = .answer
        }
        
        setupCollectionData()
        hintCollectionView.reloadData()
    }
    
    @IBAction func swapGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right, .down:
            self.dismiss(animated: true)
        default:
            return
        }
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
    
    func setupCollectionData() {
        filterProducts = []
        
        if hintSelected == .answer {
            storeKitHelper.products.forEach { product in
                if Constant.product.productID.answerProductsID.contains(product.productIdentifier) {
                    filterProducts.append(product)
                }
            }
        } else if hintSelected == .halfhalf {
            storeKitHelper.products.forEach { product in
                if Constant.product.productID.halfProductsID.contains(product.productIdentifier) {
                    filterProducts.append(product)
                }
            }
        }
        
        filterProducts.sort{($0.price.compare($1.price) == ComparisonResult.orderedAscending)}

    }
    
    func findLeftAndRightInset(viewWidth: CGFloat) -> CGFloat {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let lrInset = (screenWidth - viewWidth) / 2
        
        return lrInset
    }
    
    func setupSagementControl() {
        customHintSagementControl.segments = LabelSegment.segments(withTitles: ["ជំនួយ៖ \(HintType.answer.rawValue)", "ជំនួយ៖ \(HintType.halfhalf.rawValue)"],
                                                         normalBackgroundColor: Constant.color.getClearColor(),
                                                         normalTextColor: Constant.color.getTextColor(),
                                                         selectedBackgroundColor: Constant.color.getPrimaryColor(),
                                                         selectedTextColor: UIColor.white)

    }
    
    
}

// MARK: - Delegate

extension StoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let product = filterProducts[indexPath.row]
        let tmpHintProduct = HintProduct(product: product)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HintCustomCell", for: indexPath) as! HintCustomCell
        
        print("product: ", product.productIdentifier)
        
        let data = HintCustomCellModel(type: tmpHintProduct.getHintType() ?? hintSelected,
                                       title: product.localizedTitle,
                                       amount: tmpHintProduct.getAmount(),
                                       price: tmpHintProduct.getPrice(),
                                       priceBackground: Constant.product.color[indexPath.row],
                                       enable: tmpHintProduct.isFree() && self.adsUsed ? false : true
        )
        cell.cellConfiguration(data: data)

            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectHintProduct = HintProduct(product: filterProducts[indexPath.row])
        guard let hint = selectHintProduct else {return}
        
        
        print("selectProduct: \(String(describing: hint.getTitle())), amount: \(String(describing: hint.getAmount())), type: \(String(describing: hint.getHintType()?.rawValue))")
        
        
        if !Constant.product.productID.freeProductsID.contains(filterProducts[indexPath.row].productIdentifier)  {
            
            let payment = SKPayment(product: hint.getProduct())
            SKPaymentQueue.default().add(payment)
            
        } else {
            rewardedInterstitialAd.displayAds(controller: self)
        }
     }
    

    
    func increaseHint(hintProduct: HintProduct) {
        hintView.setup(data: hintProduct.getHintView())
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: hintView, width: 314, height: 276)
    }
}

extension StoreViewController: HintPopupViewDelegate {
    func dismissHintView(_ view: UIView) {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
    }
    
    
}
 
// MARK: Product
extension StoreViewController: StoreKitHelperDelegate {
    func productRequest(response: SKProductsResponse) {
        print("Count: ", response.products)
        setupCollectionData()
        self.hintCollectionView.reloadData()
    }
    
    func paymentTransactionObserver(transaction: SKPaymentTransaction, transactionState: SKPaymentTransactionState) {
        switch transactionState{

        case .purchasing:
            print("purchasing")
        case .purchased:
            print("purchased")
            if let hint = selectHintProduct {
                increaseHint(hintProduct: hint)
            }
            SKPaymentQueue.default().finishTransaction(transaction)
        case .failed:
            print("failed")
            SKPaymentQueue.default().finishTransaction(transaction)

        case .restored:
            print("restored")

        case .deferred:
            print("deferred")

        @unknown default:
            return
        }
    }

}


// MARK: InterstitialAds

extension StoreViewController: RewardedInterstitialAdDelegate {
    func errorConnection() {
    }
    
    func adLoaded(status: Bool) {
        if status {
            adsUsed = true
        }
    }
    
    func adError(error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func dismissScreen() {
        guard let hint = selectHintProduct else { return }

        if adsUsed {
            increaseHint(hintProduct: hint)
            hintCollectionView.reloadData()
        }
    }
    
    

    

}
