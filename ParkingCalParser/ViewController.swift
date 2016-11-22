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
        
        title = NSLocalizedString("NYC Parking Calendar Parser", comment: "")
        
        view.backgroundColor = UIColor.lightGray
        
        startButton.addTarget(self, action: #selector(didTapStartButton(_:)), for: .touchUpInside)
        startButton.setTitle(NSLocalizedString("Start", comment: ""), for: .normal)
        startButton.setTitleColor(UIColor.blue, for: .normal)
        view.addSubview(startButton)
    }

    func didTapStartButton(_ sender: UIButton) {
        let vc = ParseViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startButton.frame = view.bounds
    }
}
