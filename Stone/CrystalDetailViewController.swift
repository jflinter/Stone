//
//  CrystalDetailViewController.swift
//  Stone
//
//  Created by Jack Flintermann on 11/22/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import AlamofireImage
import Stripe

class CrystalDetailViewController: UIViewController {
    
    let viewModel: CrystalDetailViewModel
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let textView = UITextView()
    let paymentButton = UIButton(type: UIButtonType.System)
    let colorBackdropView: CrystalBackdropView
    
    init(viewModel: CrystalDetailViewModel) {
        self.viewModel = viewModel
        self.colorBackdropView = CrystalBackdropView(colors: [viewModel.bootstrapImage.primaryColor, viewModel.bootstrapImage.secondaryColor, viewModel.bootstrapImage.detailColor])
        self.colorBackdropView.hidden = true
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(CrystalDetailViewController.dismiss))
        self.navigationItem.leftBarButtonItem?.tintColor = self.viewModel.bootstrapImage.primaryColor
        self.scrollView.alwaysBounceVertical = true
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.colorBackdropView)
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = self.viewModel.bootstrapImage.image
        self.scrollView.addSubview(imageView)
        
        self.textView.hidden = true
        self.textView.backgroundColor = UIColor.clearColor()
        self.textView.scrollEnabled = false
        self.textView.editable = false
        self.textView.font = UIFont.systemFontOfSize(18)
        self.textView.showsVerticalScrollIndicator = false
        self.scrollView.addSubview(textView)
        self.textView.text = self.viewModel.descriptionText
        self.paymentButton.setTitle("Buy", forState: .Normal)
        self.paymentButton.sizeToFit()
        self.scrollView.addSubview(self.paymentButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.bounds
        self.imageView.frame = CGRectMake(0, 10, self.view.bounds.width, 300)
        self.colorBackdropView.frame = self.imageView.frame
        if let url = self.viewModel.imageURLForSize(CGRectIntegral(self.imageView.frame).size) {
            self.imageView.af_setImageWithURL(url, placeholderImage: nil, filter: BackgroundRemovingImageFilter(url: nil), imageTransition: .CrossDissolve(0.4), runImageTransitionIfCached: false, completion: nil)
        }
        let textSize = self.textView.sizeThatFits(CGSizeMake(self.view.bounds.size.width - 40, CGFloat.max))
        self.textView.frame = CGRectMake(20, 300, textSize.width, textSize.height)
        self.paymentButton.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame), self.view.bounds.size.width, 44)
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.paymentButton.frame) + 30)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
