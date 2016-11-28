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
    let containerView = UIView()
    let results: ParseResults
    let tableView = UITableView()
    let textView = UITextView()
    
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
        chooser.selectedSegmentIndex = 0
        view.addSubview(chooser)
        
        view.addSubview(containerView)
        
        tableView.dataSource = self
        containerView.addSubview(tableView)
        
        textView.isHidden = true
        containerView.addSubview(textView)
    }

    func chooserDidChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tableView.isHidden = false
            textView.isHidden = true
            tableView.reloadData()
        } else {
            tableView.isHidden = true
            textView.isHidden = false
            textView.text = results.asJSON()
            
            print(textView.text)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        chooser.y = 80
        chooser.centerHorizontallyInSuperview()
        
        containerView.y = chooser.maxY + 8
        containerView.width = view.width
        containerView.height = view.height - containerView.y
        
        tableView.frame = containerView.bounds
        textView.frame = containerView.bounds
    }
}

// MARK: - UITableViewDataSource

extension ParseResultsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "ParseResultsCell") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .value2, reuseIdentifier: "ParseResultsCell")
        }
        
        let event = results.events[indexPath.row]
        cell.textLabel?.text = event.dateString
        cell.detailTextLabel?.text = event.message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.events.count
    }
}
