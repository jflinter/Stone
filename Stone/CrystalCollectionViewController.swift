//
//  CrystalCollectionViewController.swift
//  Stone
//
//  Created by Jack Flintermann on 10/25/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import Dwifft
import ReactiveKit
import Analytics
import OneSignal

private let reuseIdentifier = "Cell"

class CrystalCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIViewControllerTransitioningDelegate {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.accessibilityIdentifier = "crystal collection view"
        return collectionView
    }()
    
    var diffCalculator: SingleSectionCollectionViewDiffCalculator<CrystalCellViewModel>?
    let crystalStore: CrystalStore
    
    let searchView = UIView()
    let searchHairline = UIView()
    
    let searchSegmentedControl: HMSegmentedControl = {
        let segmentedControl = HMSegmentedControl(sectionTitles: ["VIBE ", "NAME "])!
        segmentedControl.titleTextAttributes = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Brown-Light", size: 14) ?? UIFont.systemFont(ofSize: 14),
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.stoneLightBlue,
        ]
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.segmentWidthStyle = .fixed
        segmentedControl.selectionIndicatorHeight = 3
        segmentedControl.segmentEdgeInset = UIEdgeInsets.zero
        segmentedControl.selectionIndicatorColor = UIColor.stoneLightOrange
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.gray
        segmentedControl.accessibilityIdentifier = "search segmented control"
        segmentedControl.subviews.enumerated().forEach({ (index: Int, element: UIView) in
            element.accessibilityIdentifier = "search segmented control subview \(index)"
        })
        return segmentedControl
    }()
    
    lazy var searchButton: UIBarButtonItem = {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(CrystalCollectionViewController.toggleSearch))
        searchButton.tintColor = UIColor.stoneLightBlue
        return searchButton
    }()
    
    lazy var cancelSearchButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(Resource.Image.Icon__close.image?.withRenderingMode(.alwaysTemplate), for: UIControl.State())
        button.tintColor = UIColor.stoneLightBlue
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 0)
        button.sizeToFit()
        button.frame = button.frame.inset(by: UIEdgeInsets.init(top: -8, left: -8, bottom: -8, right: -8))
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(CrystalCollectionViewController.toggleSearch), for: .touchUpInside)
        let searchButton = UIBarButtonItem(customView: button)
        searchButton.tintColor = UIColor.stoneLightBlue
        return searchButton
    }()
    
    let vibesView: VibesView
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.accessibilityIdentifier = "crystal search bar"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.stoneLightBlue,
            NSAttributedString.Key.font.rawValue: UIFont(name: "Brown-Light", size: 16) ?? UIFont.systemFont(ofSize: 16),
        ])
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.layer.borderColor = UIColor.stoneDarkOrange.cgColor
        textFieldInsideSearchBar?.layer.borderWidth = 1
        textFieldInsideSearchBar?.layer.cornerRadius = 10
        textFieldInsideSearchBar?.clearButtonMode = .never
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = UIColor.stoneLightBlue
        return searchBar
    }()
    var searchVisible: Bool = false {
        didSet {
            self.navigationItem.setRightBarButton(self.searchVisible ? self.cancelSearchButton : self.searchButton, animated: true)
            if searchVisible {
                self.searchView.isHidden = false
            }
            else {
                self.crystalStore.selectedVibe.value = nil
                self.crystalStore.searchQuery.value = ""
            }
            UIView.animate(withDuration: self.visible ? 0.3 : 0, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { completed in
                guard completed else { return }
                let showSearch = self.searchSegmentedControl.selectedSegmentIndex == 1
                if self.searchVisible {
                    if showSearch {
                        self.searchBar.becomeFirstResponder()
                    }
                } else {
                    self.vibesView.resetSelection()
                    if self.searchBar.isFirstResponder {
                        self.searchBar.resignFirstResponder()
                        self.searchBar.text = ""
                    }
                    self.searchView.isHidden = true
                }
            }) 
        }
    }
    
    init(crystalStore: CrystalStore) {
        self.crystalStore = crystalStore
        self.vibesView = VibesView(crystalStore: crystalStore)
        super.init(nibName: nil, bundle: nil)
        self.searchBar.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.edgesForExtendedLayout = UIRectEdge()
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = false
        NotificationCenter.default.addObserver(self, selector: #selector(CrystalCollectionViewController.keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue ?? CGRect.zero
        let intersection = keyboardFrame.intersection(self.view.frame)
        
        var inset = self.collectionView.contentInset
        inset.bottom = intersection.size.height
        
        self.collectionView.contentInset = inset
        self.collectionView.scrollIndicatorInsets = inset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.searchView)
        self.searchView.backgroundColor = UIColor.white
        self.searchView.addSubview(self.searchSegmentedControl)
        self.searchView.addSubview(self.searchBar)
        self.searchHairline.backgroundColor = UIColor.stoneDarkBlue
        self.view.addSubview(self.searchHairline)
        self.searchBar.alpha = 0
        self.vibesView.alpha = 1
        self.searchView.addSubview(self.vibesView)
        
        self.searchSegmentedControl.addTarget(self, action: #selector(CrystalCollectionViewController.segmentedControlChanged(_:)), for: .valueChanged)
        
        let imageView = UIImageView(image: Resource.Image.Stone_Logo_Icon.image)
        imageView.contentMode = .center
        self.navigationItem.titleView = imageView
        
        self.navigationItem.rightBarButtonItem = self.searchButton
            
        
        self.diffCalculator = SingleSectionCollectionViewDiffCalculator(collectionView: collectionView)
        let _ = crystalStore.visibleCrystals.observeNext { crystals in
            if (self.visible) {
                self.diffCalculator?.items = crystals.map(CrystalCellViewModel.init)
                self.updateCellParallax()
            } else {
                UIView.performWithoutAnimation({
                    self.diffCalculator?.items = crystals.map(CrystalCellViewModel.init)
                    self.updateCellParallax()
                })
            }
        }
        let _ = crystalStore.selectedVibe.observeNext { vibe in
            if vibe != nil {
                self.searchVisible = true
                self.vibesSelected = true
            }
        }
        let _ = crystalStore.fetchCrystals()
        
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CrystalCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        self.searchVisible = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = self.searchVisible ? self.cancelSearchButton : self.searchButton
    }
    
    var visible: Bool = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.visible = true
        self.vibesView.collectionView.setScrollIndicatorColor(UIColor.stoneDarkOrange)
        self.collectionView.setScrollIndicatorColor(UIColor.stoneDarkOrange)
        
        let key = "STNPromptedForPushNotificationsAt"
        let promptedAt = UserDefaults.standard.object(forKey: key) as? Date
        if promptedAt == nil {
            let alertController = UIAlertController(title: nil, message: "Would you like us to let you know when we update STONE with more dazzling crystals?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "No thanks.", style: .default, handler: { _ in
                UserDefaults.standard.set(Date(), forKey: key)
            }))
            alertController.addAction(UIAlertAction(title: "Please do.", style: UIAlertAction.Style.default, handler: { _ in
                UserDefaults.standard.set(Date(), forKey: key)
                OneSignal.defaultClient().registerForPushNotifications()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.visible = false
    }
    
    var vibesSelected = false {
        didSet {
            self.searchSegmentedControl.setSelectedSegmentIndex(vibesSelected ? 0 : 1, animated: self.visible)
            let showSearch = !self.vibesSelected
            if showSearch {
                self.crystalStore.selectedVibe.value = nil
                self.vibesView.resetSelection()
            } else {
                self.crystalStore.searchQuery.value = ""
                self.searchBar.resignFirstResponder()
            }
            UIView.animate(withDuration: self.visible ? 0.2 : 0, animations: {
                self.searchBar.alpha = showSearch ? 1 : 0
                self.vibesView.alpha = showSearch ? 0 : 1
                }, completion: { completed in
                    if showSearch {
                        self.searchBar.becomeFirstResponder()
                    } else {
                        self.searchBar.text = ""
                    }
            })
        }
    }
    @objc func segmentedControlChanged(_ segmentedControl: UISegmentedControl) {
        self.vibesSelected = segmentedControl.selectedSegmentIndex == 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateCellParallax()
    }
    
    func updateCellParallax() {
        for cell in self.collectionView.visibleCells {
            guard let cell = cell as? CrystalCollectionViewCell else { return }
            let distanceFromBottom = self.collectionView.frame.size.height - cell.convert(cell.bounds, to: nil).maxY
            let percentage = distanceFromBottom / self.collectionView.frame.size.height
            let transformed = percentage / 0.5
            let fraction = max(min(transformed + 0.7, 1), 0)
            cell.transform = CGAffineTransform(scaleX: fraction, y: fraction)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height: CGFloat = 120
        let searchY = self.searchVisible ? 0 : -height
        
        self.searchView.frame = CGRect(x: 0, y: searchY, width: self.view.bounds.size.width, height: height)
        
        let segmentedControlWidth = CGFloat(175)
        self.searchSegmentedControl.frame = CGRect(
            x: searchView.frame.size.width / 2 - segmentedControlWidth/2,
            y: 10,
            width: segmentedControlWidth,
            height: 30
        )
        self.searchSegmentedControl.layer.cornerRadius = self.searchSegmentedControl.frame.size.height / 2
        self.searchSegmentedControl.clipsToBounds = true
        let searchBarX = CGFloat(10)
        self.searchBar.frame = CGRect(
            x: searchBarX,
            y: 60,
            width: searchView.frame.size.width - (searchBarX * 2),
            height: 30
        )
        self.searchHairline.frame = CGRect(x: 0, y: self.searchView.frame.maxY + 0.5, width: self.searchView.bounds.size.width, height: 0.5)
        
        self.vibesView.frame = CGRect(x: 0, y: 40, width: self.searchView.bounds.width, height: 80)
        
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3 + 20)
        
        self.collectionView.frame = self.view.bounds
        var oldContentOffset = self.collectionView.contentOffset
        var inset = self.collectionView.contentInset
        inset.top = self.searchVisible ? self.searchView.frame.maxY : 0
        self.collectionView.contentInset = inset
        self.collectionView.scrollIndicatorInsets = inset
        if oldContentOffset.y == 0 {
            oldContentOffset.y -= inset.top
            self.collectionView.contentOffset = oldContentOffset
        }
    }
    
    func viewModelAt(_ indexPath: IndexPath) -> CrystalCellViewModel? {
        return self.diffCalculator?.items[indexPath.item]
    }
        
    @objc func toggleSearch() {
        self.searchVisible = !self.searchVisible
    }
    
    // MARK: UISearchBarDelegate
    @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.crystalStore.searchQuery.value = searchText
    }
    
    // MARK: UICollectionViewDataSource
    
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diffCalculator?.items.count ?? 0
    }

    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CrystalCollectionViewCell
        if let viewModel = viewModelAt(indexPath) {
            cell.viewModel = viewModel
        }
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CrystalCollectionViewCell,
            let image = cell.imageView.image, let cellViewModel = viewModelAt(indexPath) else { return }
        let viewModel = CrystalDetailViewModel(crystal: cellViewModel.crystal, bootstrapImage: image)
        let detail = CrystalDetailViewController(viewModel: viewModel, store: self.crystalStore)
        detail.transitioningDelegate = self
        SEGAnalytics.shared().track("Viewed Crystal", properties: ["name": cellViewModel.crystal.name])
        self.present(detail, animated: true, completion: nil)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    var animator: CrystalDetailAnimator? = nil
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator = CrystalDetailAnimator(collectionViewController: self)
        return self.animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator?.presenting = false
        return self.animator
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
