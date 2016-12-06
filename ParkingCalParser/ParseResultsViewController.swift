//
//  ParseResultsViewController.swift
//  ParkingCalParser
//
//  Created by Kaden, Joshua on 11/28/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import UIKit

final class ParseResultsViewController: UIViewController {

    fileprivate lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM d"
        return formatter
    }()
    private let chooser = UISegmentedControl(items: ["Table", "JSON"])
    private let containerView = UIView()
    fileprivate lazy var monthlyEvents: [[ParkingCalendarEvent]] = { return self.results.splitByMonth() }()
    private let results: ParseResults
    private let tableView = UITableView()
    private let textView = UITextView()
    
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
        tableView.rowHeight = 80
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
    
    fileprivate func buildSummaryCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: SummaryCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "ParseResultsSummaryCell") as? SummaryCell {
            cell = dequeuedCell
        } else {
            cell = SummaryCell(style: .default, reuseIdentifier: "ParseResultsSummaryCell")
        }
        
        let event = monthlyEvents[indexPath.section][indexPath.row / 2]
        cell.summary = event.fullMessage
        
        return cell
    }
}

// MARK: - UITableViewDataSource

extension ParseResultsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 > 0 {
            return buildSummaryCell(tableView: tableView, indexPath: indexPath)
        }
        
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "ParseResultsCell") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .value2, reuseIdentifier: "ParseResultsCell")
        }
        
        let event = monthlyEvents[indexPath.section][indexPath.row / 2]
        cell.textLabel?.text = dayFormatter.string(from: event.date)
        cell.detailTextLabel?.text = event.message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthlyEvents[section].count * 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dayFormatter.standaloneMonthSymbols[section]
    }
}
