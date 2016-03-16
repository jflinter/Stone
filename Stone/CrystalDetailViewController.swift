//
//  CrystalDetailViewController.swift
//  Stone
//
//  Created by Jack Flintermann on 11/22/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit
import AlamofireImage
import PassKit
import Stripe

class CrystalDetailViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    let viewModel: CrystalDetailViewModel
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let textView = UITextView()
    let paymentButton = UIButton(type: UIButtonType.System)
    
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
        self.view.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
        self.scrollView.alwaysBounceVertical = true
        self.view.addSubview(self.scrollView)
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = self.viewModel.bootstrapImage
        self.scrollView.addSubview(imageView)
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
        self.paymentButton.addTarget(self, action: "buyCrystal", forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.bounds
        self.imageView.frame = CGRectMake(0, 10, self.view.bounds.width, 300)
        if let url = self.viewModel.imageURLForSize(CGRectIntegral(self.imageView.frame).size) {
            self.imageView.af_setImageWithURL(url, placeholderImage: nil, filter: BackgroundRemovingImageFilter(), imageTransition: .CrossDissolve(0.4), runImageTransitionIfCached: false, completion: nil)
        }
        let textSize = self.textView.sizeThatFits(CGSizeMake(self.view.bounds.size.width - 40, CGFloat.max))
        self.textView.frame = CGRectMake(20, 300, textSize.width, textSize.height)
        self.paymentButton.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame), self.view.bounds.size.width, 44)
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.paymentButton.frame) + 30)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buyCrystal() {
        Checkout.createOrder(self.viewModel.skus).onSuccess { order in
            guard let paymentRequest = order.paymentRequest else { return }
            let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentVC.delegate = self
            self.presentViewController(paymentVC, animated: true, completion: nil)
        }.onFailure { error in
            print(error.description)
        }
    }
    
    // MARK: PKPaymentAuthorizationViewControllerDelegate
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        let client = STPAPIClient(publishableKey: "pk_test_iweIKQXjUpKF9Pp7LCJMO4hF")
        client.createTokenWithPayment(payment) { token, error in
            if let token = token {
                print(token.tokenId)
                completion(.Success)
            } else {
                completion(.Failure)
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
