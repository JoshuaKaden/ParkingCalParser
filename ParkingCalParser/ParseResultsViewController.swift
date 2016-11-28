//
//  ParseResultsViewController.swift
//  ParkingCalParser
//
//  Created by Kaden, Joshua on 11/28/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import UIKit

final class ParseResultsViewController: UIViewController {

    let chooser = UISegmentedControl(items: ["Table", "JSON"])
    let results: ParseResults
    
    init(results: ParseResults) {
        self.results = results
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        chooser.addTarget(self, action: #selector(chooserDidChange(_:)), for: .valueChanged)
        view.addSubview(chooser)
    }

    func chooserDidChange(_ sender: UISegmentedControl) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        chooser.y = 80
        chooser.centerHorizontallyInSuperview()
    }
}
