//
//  CrystalDetailViewController.swift
//  Stone
//
//  Created by Jack Flintermann on 11/22/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import AlamofireImage

class CrystalDetailViewController: UIViewController {
    
    let viewModel: CrystalDetailViewModel
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let textView = UITextView()
    
    init(viewModel: CrystalDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
        self.scrollView.alwaysBounceVertical = true
        self.view.addSubview(self.scrollView)
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = self.viewModel.bootstrapImage
        self.scrollView.addSubview(imageView)
        self.textView.scrollEnabled = false
        self.textView.editable = false
        self.textView.font = UIFont.systemFontOfSize(18)
        self.textView.showsVerticalScrollIndicator = false
        self.scrollView.addSubview(textView)
        self.textView.text = self.viewModel.descriptionText
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.bounds
        self.imageView.frame = CGRectMake(0, 10, self.view.bounds.width, 300)
        if let url = self.viewModel.imageURLForSize(self.imageView.frame.size) {
            self.imageView.af_setImageWithURL(url, imageTransition: .CrossDissolve(0.4))
        }
        let textSize = self.textView.sizeThatFits(CGSizeMake(self.view.bounds.size.width - 40, CGFloat.max))
        self.textView.frame = CGRectMake(20, 300, textSize.width, textSize.height)
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.textView.frame) + 30)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
