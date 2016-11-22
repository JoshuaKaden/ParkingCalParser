//
//  ViewController.swift
//  ParkingCalParser
//
//  Created by Joshua Kaden on 11/22/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    private let startButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.addTarget(self, action: #selector(didTapStartButton(_:)), for: .touchUpInside)
        startButton.setTitle(NSLocalizedString("Start", comment: ""), for: .normal)
        view.addSubview(startButton)
    }

    func didTapStartButton(_ sender: UIButton) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startButton.frame = view.bounds
    }
}
