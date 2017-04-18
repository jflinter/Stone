//
//  CrystalDetailViewController.swift
//  Stone
//
//  Created by Jack Flintermann on 11/22/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import AlamofireImage

class CrystalDetailViewController: UIViewController, UIScrollViewDelegate, CrystalVibesViewDelegate {
    
    let viewModel: CrystalDetailViewModel
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Resource.Image.Icon__close.image?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        button.tintColor = UIColor.stoneLightBlue
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.borderColor = UIColor.stoneDarkBlue.cgColor
        button.layer.borderWidth = 0
        button.sizeToFit()
        button.frame = UIEdgeInsetsInsetRect(button.frame, UIEdgeInsetsMake(-8, -8, -8, -8))
        button.layer.cornerRadius = button.frame.size.width / 2
        button.clipsToBounds = true
        button.backgroundColor = UIColor.white
        return button
    }()
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let contentContainer = UIView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.stoneDarkBlue
        label.font = UIFont(name: "Brown-RegularAlt", size: 20)
        label.textAlignment = .center
        return label
    }()
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.stoneDarkBlue
        label.font = UIFont(name: "Brown-RegularItalic", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    let vibesView: CrystalVibesView
    
    let textView = UITextView()
    let crystalStore: CrystalStore
    
    init(viewModel: CrystalDetailViewModel, store: CrystalStore) {
        self.viewModel = viewModel
        self.vibesView = CrystalVibesView(availableVibes: viewModel.vibes)
        self.crystalStore = store
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.name
        self.vibesView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.closeButton)
        self.closeButton.addTarget(self, action: #selector(CrystalDetailViewController.dismissMe), for: .touchUpInside)
        
        self.view.backgroundColor = UIColor.white
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.delegate = self
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        self.scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = self.viewModel.bootstrapImage
        self.imageView.frame = CGRect(x: 0, y: 10, width: self.view.bounds.width, height: 300)
        self.scrollView.addSubview(imageView)
        
        self.contentContainer.backgroundColor = UIColor.clear
        self.scrollView.addSubview(self.contentContainer)
        
        self.titleLabel.text = self.viewModel.name
        self.contentContainer.addSubview(self.titleLabel)
        
        self.subtitleLabel.text = self.viewModel.subtitle
        self.contentContainer.addSubview(self.subtitleLabel)
        
        self.contentContainer.addSubview(self.vibesView)
        
        self.textView.backgroundColor = UIColor.clear
        self.textView.textColor = UIColor.stoneDarkBlue
        self.textView.isScrollEnabled = false
        self.textView.isEditable = false
        self.textView.showsVerticalScrollIndicator = false
        self.textView.attributedText = self.viewModel.descriptionText
        self.contentContainer.addSubview(textView)
        
        self.view.bringSubview(toFront: self.closeButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.closeButton.frame = CGRect(x: 35, y: 35, width: self.closeButton.bounds.size.width, height: self.closeButton.bounds.size.height)
        self.scrollView.frame = self.view.bounds
        self.imageView.frame = CGRect(x: 0, y: 30, width: self.view.bounds.width, height: 300)
        if let url = self.viewModel.imageURLForSize(self.imageView.bounds.integral.size) {
            self.imageView.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: false, completion: nil)
        }
        
        var contentFrame = CGRect(x: 35, y: self.imageView.frame.maxY - 15, width: self.view.bounds.size.width - 70, height: 0)
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: contentFrame.size.width, height: 40)
        self.subtitleLabel.frame = CGRect(x: 0, y: self.titleLabel.frame.maxY, width: contentFrame.size.width, height: 40)
        
        let rows =  ceil(CGFloat(self.viewModel.vibes.count) / 3)
        self.vibesView.frame = CGRect(x: 0, y: self.subtitleLabel.frame.maxY + 8, width: contentFrame.size.width, height: rows * 60)
        
        let textSize = self.textView.sizeThatFits(CGSize(width: contentFrame.size.width, height: CGFloat.greatestFiniteMagnitude))
        self.textView.frame = CGRect(x: 0, y: self.vibesView.frame.maxY, width: textSize.width, height: textSize.height)
        
        contentFrame.size.height = self.textView.frame.maxY
        self.contentContainer.frame = contentFrame
        
        
        
        self.scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.contentContainer.frame.maxY + 30)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.setScrollIndicatorColor(UIColor.stoneDarkOrange)
    }
    
    func dismissMe() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden : Bool {
        return !self.scrolledToTop
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .fade
    }
    
    var scrolledToTop: Bool = true
    var closeButtonHidden: Bool = true
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scalingImage = scrollView.contentOffset.y <= 0
        scrollView.showsVerticalScrollIndicator = !scalingImage
        if scalingImage {
            let scaleFactor: CGFloat = 4
            let delta = -scrollView.contentOffset.y * scaleFactor / scrollView.bounds.size.height
            let deltaY = delta * self.imageView.bounds.size.height / 8
            self.imageView.transform = CGAffineTransform(scaleX: 1 + delta, y: 1 + delta).translatedBy(x: 0, y: -deltaY)
        } else {
            self.scrollView.setScrollIndicatorColor(UIColor.stoneDarkOrange)
            self.imageView.transform = CGAffineTransform.identity
        }
        
        
        let scrolledToTop = scrollView.contentOffset.y <= 1
        if (scrolledToTop == self.scrolledToTop) {
            return
        }
        self.scrolledToTop = scrolledToTop
        UIView.animate(withDuration: 0.1, animations: { 
            self.setNeedsStatusBarAppearanceUpdate()
        }) 
        let destinationBorderWidth: CGFloat = (scrolledToTop || closeButtonHidden) ? 0 : 1
        let widthAnimation = CABasicAnimation(keyPath: "borderWidth")
        widthAnimation.duration = 0.1
        self.closeButton.layer.borderWidth = destinationBorderWidth
        self.closeButton.layer.add(widthAnimation, forKey: nil)
    }
    
    func crystalVibesViewDidSelectVibe(_ vibe: Vibe) {
        self.crystalStore.selectedVibe.value = vibe
        self.dismissMe()
    }
    
}
