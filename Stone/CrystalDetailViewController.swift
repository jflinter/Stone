//
//  CrystalDetailViewController.swift
//  Stone
//
//  Created by Jack Flintermann on 11/22/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import AlamofireImage

class CrystalDetailViewController: UIViewController, UIScrollViewDelegate {
    
    let viewModel: CrystalDetailViewModel
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Resource.Image.Icon__close.image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        button.tintColor = UIColor.stoneLightBlue
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.borderColor = UIColor.stoneDarkBlue.CGColor
        button.layer.borderWidth = 0
        button.sizeToFit()
        button.frame = UIEdgeInsetsInsetRect(button.frame, UIEdgeInsetsMake(-8, -8, -8, -8))
        button.layer.cornerRadius = button.frame.size.width / 2
        button.clipsToBounds = true
        button.backgroundColor = UIColor.whiteColor()
        return button
    }()
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let contentContainer = UIView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.stoneDarkBlue
        label.font = UIFont(name: "Brown-RegularAlt", size: 20)
        label.textAlignment = .Center
        return label
    }()
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.stoneDarkBlue
        label.font = UIFont(name: "Brown-RegularItalic", size: 14)
        label.textAlignment = .Center
        return label
    }()
    
    let vibesView: CrystalVibesView
    
    let textView = UITextView()
    
    init(viewModel: CrystalDetailViewModel) {
        self.viewModel = viewModel
        self.vibesView = CrystalVibesView(availableVibes: viewModel.vibes)
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.closeButton)
        self.closeButton.addTarget(self, action: #selector(CrystalDetailViewController.dismiss), forControlEvents: .TouchUpInside)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.delegate = self
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        self.scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = self.viewModel.bootstrapImage
        self.imageView.frame = CGRectMake(0, 10, self.view.bounds.width, 300)
        self.scrollView.addSubview(imageView)
        
        self.contentContainer.backgroundColor = UIColor.clearColor()
        self.scrollView.addSubview(self.contentContainer)
        
        self.titleLabel.text = self.viewModel.name
        self.contentContainer.addSubview(self.titleLabel)
        
        self.subtitleLabel.text = self.viewModel.subtitle
        self.contentContainer.addSubview(self.subtitleLabel)
        
        self.contentContainer.addSubview(self.vibesView)
        
        self.textView.backgroundColor = UIColor.clearColor()
        self.textView.textColor = UIColor.stoneDarkBlue
        self.textView.scrollEnabled = false
        self.textView.editable = false
        self.textView.showsVerticalScrollIndicator = false
        self.textView.attributedText = self.viewModel.descriptionText
        self.contentContainer.addSubview(textView)
        
        self.view.bringSubviewToFront(self.closeButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.closeButton.frame = CGRectMake(35, 35, self.closeButton.bounds.size.width, self.closeButton.bounds.size.height)
        self.scrollView.frame = self.view.bounds
        self.imageView.frame = CGRectMake(0, 30, self.view.bounds.width, 300)
        if let url = self.viewModel.imageURLForSize(CGRectIntegral(self.imageView.bounds).size) {
            
            self.imageView.af_setImageWithURL(url, placeholderImage: nil, filter: nil, imageTransition: .CrossDissolve(0.4), runImageTransitionIfCached: false, completion: nil)
        }
        
        var contentFrame = CGRectMake(35, CGRectGetMaxY(self.imageView.frame) - 15, self.view.bounds.size.width - 70, 0)
        self.titleLabel.frame = CGRectMake(0, 0, contentFrame.size.width, 40)
        self.subtitleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), contentFrame.size.width, 40)
        
        let rows =  ceil(CGFloat(self.viewModel.vibes.count) / 3)
        self.vibesView.frame = CGRectMake(0, CGRectGetMaxY(self.subtitleLabel.frame) + 8, contentFrame.size.width, rows * 60)
        
        let textSize = self.textView.sizeThatFits(CGSizeMake(contentFrame.size.width, CGFloat.max))
        self.textView.frame = CGRectMake(0, CGRectGetMaxY(self.vibesView.frame), textSize.width, textSize.height)
        
        contentFrame.size.height = CGRectGetMaxY(self.textView.frame)
        self.contentContainer.frame = contentFrame
        
        
        
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.contentContainer.frame) + 30)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.setScrollIndicatorColor(UIColor.stoneDarkOrange)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return !self.scrolledToTop
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Fade
    }
    
    var scrolledToTop: Bool = true
    var closeButtonHidden: Bool = true
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let scalingImage = scrollView.contentOffset.y <= 0
        scrollView.showsVerticalScrollIndicator = !scalingImage
        if scalingImage {
            let scaleFactor: CGFloat = 4
            let delta = -scrollView.contentOffset.y * scaleFactor / scrollView.bounds.size.height
            let deltaY = delta * self.imageView.bounds.size.height / 8
            self.imageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1 + delta, 1 + delta), 0, -deltaY)
        } else {
            self.scrollView.setScrollIndicatorColor(UIColor.stoneDarkOrange)
            self.imageView.transform = CGAffineTransformIdentity
        }
        
        
        let scrolledToTop = scrollView.contentOffset.y <= 1
        if (scrolledToTop == self.scrolledToTop) {
            return
        }
        self.scrolledToTop = scrolledToTop
        UIView.animateWithDuration(0.1) { 
            self.setNeedsStatusBarAppearanceUpdate()
        }
        let destinationBorderWidth: CGFloat = (scrolledToTop || closeButtonHidden) ? 0 : 1
        let widthAnimation = CABasicAnimation(keyPath: "borderWidth")
        widthAnimation.duration = 0.1
        self.closeButton.layer.borderWidth = destinationBorderWidth
        self.closeButton.layer.addAnimation(widthAnimation, forKey: nil)
    }
    
}
