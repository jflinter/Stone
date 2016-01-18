//
//  Order+ApplePay.swift
//  Stone
//
//  Created by Jack Flintermann on 12/21/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation
import PassKit
import Stripe

extension LineItem {
    var summaryItem: PKPaymentSummaryItem {
        return PKPaymentSummaryItem(label: self.name, amount: NSDecimalNumber(mantissa: UInt64(self.amount), exponent: -2, isNegative: false))
    }
}

extension Order {
    var paymentRequest: PKPaymentRequest? {
        let paymentRequest = Stripe.paymentRequestWithMerchantIdentifier("merchant.com.stonecrystals")
        let totalAmount = self.lineItems.reduce(0) { return $0 + $1.amount }
        paymentRequest?.paymentSummaryItems = self.lineItems.map({ $0.summaryItem }) + [PKPaymentSummaryItem(label: "Stone", amount: NSDecimalNumber(mantissa: UInt64(totalAmount), exponent: -2, isNegative: false))]
        return paymentRequest
    }
}
