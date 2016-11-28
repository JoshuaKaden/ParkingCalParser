//
//  ParseViewController.swift
//  ParkingCalParser
//
//  Created by Joshua Kaden on 11/22/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import UIKit

final class ParseViewController: UIViewController {

    private var isParsing = false
    private let parseButton = UIButton()
    private var parseResults: ParseResults?
    private let resultsButton = UIButton()
    private let resultsLabel = UILabel()
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let urlContainerView = UIView()
    private let urlLabel = UILabel()
    private let urlTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        urlLabel.text = NSLocalizedString("URL of iCal file", comment: "")
        urlContainerView.addSubview(urlLabel)
        
        urlTextField.text = "http://www.nyc.gov/html/dot/downloads/misc/2016-alternate-side.ics"
        urlContainerView.addSubview(urlTextField)
        
        urlContainerView.backgroundColor = UIColor.lightGray
        view.addSubview(urlContainerView)
        
        parseButton.addTarget(self, action: #selector(didTapParseButton(_:)), for: .touchUpInside)
        parseButton.setTitle(NSLocalizedString("Parse", comment: ""), for: .normal)
        parseButton.setTitleColor(UIColor.blue, for: .normal)
        view.addSubview(parseButton)
        
        view.addSubview(spinner)
        view.sendSubview(toBack: spinner)
        
        resultsLabel.backgroundColor = UIColor.lightGray
        resultsLabel.isHidden = true
        resultsLabel.lineBreakMode = .byWordWrapping
        resultsLabel.numberOfLines = 0
        view.addSubview(resultsLabel)
        
        resultsButton.addTarget(self, action: #selector(didTapResultsButton(_:)), for: .touchUpInside)
        resultsButton.isHidden = true
        resultsButton.setTitle(NSLocalizedString("View Results", comment: ""), for: .normal)
        resultsButton.setTitleColor(UIColor.blue, for: .normal)
        view.addSubview(resultsButton)
    }

    func didTapParseButton(_ sender: UIButton) {
        if isParsing { return }
        guard let urlString = urlTextField.text, let url = URL(string: urlString) else { return }
        
        isParsing = true
        parseResults = nil
        
        parseButton.isHidden = true
        resultsButton.isHidden = true
        resultsLabel.isHidden = true
        spinner.startAnimating()
        
        let parser = ParkingCalendarParser(url: url)
        parser.parse() {
            [weak self] result in
            
            switch result {
            case let .success(results):
                self?.resultsLabel.text = NSLocalizedString("The parse was successful.", comment: "")
                self?.handle(results: results)
            case let .error(error):
                self?.resultsLabel.text = NSLocalizedString("Error.", comment: "")
                print(error)
            }
            
            self?.isParsing = false
            self?.spinner.stopAnimating()
            self?.parseButton.isHidden = false
            if let _ = self?.parseResults { self?.resultsButton.isHidden = false }
            self?.resultsLabel.isHidden = false
            self?.view.setNeedsLayout()
        }
    }
    
    func didTapResultsButton(_ sender: UIButton) {
        guard let parseResults = parseResults else { return }
        let vc = ParseResultsViewController(results: parseResults)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handle(results: ParseResults) {
        parseResults = results
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let sideMargin = CGFloat(24)
        let padding = CGFloat(16)
        let baseHeight = CGFloat(40)
        
        urlLabel.sizeToFit()
        
        urlContainerView.height = baseHeight + urlLabel.height
        urlContainerView.width = view.width - (sideMargin * 2)
        urlContainerView.centerHorizontallyInSuperview()
        urlContainerView.y = 80
        
        urlLabel.origin = CGPoint.zero
        
        urlTextField.height = baseHeight
        urlTextField.width = urlContainerView.width
        urlTextField.origin = CGPoint(x: 0, y: urlLabel.maxY)
        
        parseButton.backgroundColor = UIColor.lightGray
        parseButton.size = CGSize(width: view.width / 2, height: baseHeight)
        parseButton.y = urlContainerView.maxY + padding
        parseButton.centerHorizontallyInSuperview()
        
        spinner.frame = parseButton.frame
        
        resultsLabel.sizeToFit()
        resultsLabel.centerHorizontallyInSuperview()
        resultsLabel.y = parseButton.maxY + padding
        
        resultsButton.backgroundColor = UIColor.lightGray
        resultsButton.size = CGSize(width: view.width, height: baseHeight)
        resultsButton.y = resultsLabel.maxY + padding
    }
    
}
