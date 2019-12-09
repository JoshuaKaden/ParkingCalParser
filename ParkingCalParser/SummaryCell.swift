//
//  SummaryCell.swift
//  ParkingCalParser
//
//  Created by Kaden, Joshua on 12/6/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import UIKit

final class SummaryCell: UITableViewCell {

    var summary: String? {
        get { return summaryLabel.text }
        set { summaryLabel.text = newValue }
    }
    private let summaryLabel = UILabel()
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let _ = newWindow else { return }
        
        summaryLabel.lineBreakMode = .byWordWrapping
        summaryLabel.numberOfLines = 5
        contentView.addSubview(summaryLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        summaryLabel.frame = contentView.bounds
    }
}
