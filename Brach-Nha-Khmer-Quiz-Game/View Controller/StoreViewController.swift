//
//  BuyHintViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/14/23.
//

import UIKit
import StoreKit
import BetterSegmentedControl
import GoogleMobileAds



class StoreViewController: UIViewController {

    @IBOutlet weak var hintCollectionView: UICollectionView!
    @IBOutlet weak var customHintSagementControl: BetterSegmentedControl!
    
    var backDirection: UIViewController? = nil

    let layout = PagingCollectionViewLayout()
    let hintView = HintPopupView()
    var hintSelected: HintType = .answer
    var products = [SKProduct]()
    var hints = [HintCustomCellModel]()
    var filterProducts = [SKProduct]()
    var selectHintProduct: HintProduct?
    
//    var insterstitialAds = InterstitialAdsHelper()

    private var interstitial: GADInterstitialAd?
    var adsUsed = false

    // MARK: - Body
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        
        hintView.delegate = self
        
        setupCollectionView()
        setupSagementControl()

        fetchProduct()

//        insterstitialAds.adsLoads()
//        insterstitialAds.delegate = self
        
        adsLoads()
    }
    
    @IBAction func restoreButtonPressed(_ sender: UIButton) {
        print("Restore Button Pressed ....")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        backButton()
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
            products.forEach { product in
                if Constant.product.productID.answerProductsID.contains(product.productIdentifier) {
                    filterProducts.append(product)
                }
            }
        } else if hintSelected == .halfhalf {
            products.forEach { product in
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
    
    func backButton() {
        var controller = UIViewController()
        
        guard let bd = backDirection else { return }
               
        if bd.restorationIdentifier == "MainViewController" {
            controller = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        } else if bd.restorationIdentifier == "GameChoosingViewController" {
            controller = storyboard?.instantiateViewController(withIdentifier: "GameChoosingViewController") as! GameChoosingViewController
        }
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
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
            displayAds(controller: self)
        }
     }
    

    
    func increaseHint(hintProduct: HintProduct) {
        hintView.setup(data: hintProduct.getHintView())
        
        buttonSoudEffect = AudioHelper(audioName: "correct", loop: false)
        buttonSoudEffect.player?.play()
    
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: hintView, width: 314, height: 276)
    }
}

extension StoreViewController: HintPopupViewDelegate {
    func dismissHintView(_ view: UIView) {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
    }
    
    
}
 
// MARK: Product
extension StoreViewController: SKProductsRequestDelegate {
    
    func fetchProduct() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.sync {
            print("Count: ", response.products)
            self.products = response.products
            setupCollectionData()
            self.hintCollectionView.reloadData()
        }
    }
}

extension StoreViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState{
                
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                if let hint = selectHintProduct {
                    increaseHint(hintProduct: hint)
                }
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("failed")
                SKPaymentQueue.default().finishTransaction($0)

            case .restored:
                print("restored")

            case .deferred:
                print("deferred")

            @unknown default:
                return
            }
        })
    }
    
    
}

// MARK: InterstitialAds

extension StoreViewController {
    
    func adsLoads() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
        
    }
    
    func displayAds(controller: UIViewController) {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: controller)
        } else {
            print("Ad wasn't ready")

        }
    }
}


extension StoreViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
        print("Error: ", error)
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        
        guard let hint = selectHintProduct else { return }
        
        increaseHint(hintProduct: hint)
        adsUsed = true
        hintCollectionView.reloadData()
    }
}
