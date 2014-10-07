//
//  FilterViewController.swift
//  yelp
//
//  Created by Erin Chuang on 9/21/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit

@objc protocol FilterDelegate {
    func filtersUpdated(filterViewController: FilterViewController)
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var filters : [[String:AnyObject]]!
    var isExpanded : [Int: Bool]! = [Int: Bool]()
    var selectedStates: Dictionary<Int, Int> = [:]
    var switchStates: Dictionary<Int, Bool> = [:]
    var currentTime = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate:FilterDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filters = [
            /*
            ["section":"Price", "rowCount":1, "viewType":"segmented","config":[
                ["label":"$"],
                ["label":"$$"],
                ["label":"$$$"],
                ["label":"$$$$"]
            ]],
            */
            ["section":"Most Popular", "rowCount":4, "viewType":"switch", "config":[
                ["label":"Open Now"],
                ["label":"Hot & New"],
                ["label":"Offering a Deal"],
                ["label":"Delivery"]
            ]],
            ["section":"Distance", "rowCount":5, "viewType":"switch", "config":[
                ["label":"Auto"],
                ["label":"0.5 km"],
                ["label":"2 km"],
                ["label":"5 km"],
                ["label":"15 km"]
            ]],
            ["section":"Sort by", "rowCount":3, "viewType":"switch", "config":[
                ["label":"Best Match"],
                ["label":"Highest Rated"],
                ["label":"Most Reviewed"]
            ]],
            ["section":"General Features", "rowCount":5, "viewType":"switch", "config":[
                ["label":"Take-out"],
                ["label":"Good for Groups"],
                ["label":"Takes Reservations"],
                ["label":"Accepts Credit Cards"],
                ["label":"Waiter Service"]
            ]]
        ]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 44
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        currentTime = formatter.stringFromDate(date)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var filter = self.filters[section]
        var rows = filter["rowCount"] as AnyObject! as Int
        switch section {
        /*
        case 0:
            return rows
        */
        case 0:
            return rows
        case 1:
            if let expanded = isExpanded[section] {
                return rows
            } else {
                return 1
            }
        case 2:
            if let expanded = isExpanded[section] {
                return rows
            } else {
                return 1
            }
        case 3:
            if let expanded = isExpanded[section] {
                return rows
            } else {
                return 3
            }
        default:
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as FilterCell
        var section = indexPath.section
        var row = indexPath.row
        var filter = self.filters[section]
        var viewType = filter["viewType"] as AnyObject! as String
        var config = filter["config"] as AnyObject! as [[String:String]]
        switch viewType {
        case "switch":
            cell.filterTitle.text = config[row]["label"] as String!
            if (section == 0 && row == 0) {
                cell.timeLabel.text = currentTime
                cell.timeLabel.hidden = false
            } else {
                cell.timeLabel.hidden = true
            }
            self.renderSwitch(cell, config: config, cellIndexPath: indexPath)
            break
        case "segmented":
            cell.filterTitle.text = ""
            cell.timeLabel.hidden = true
            self.renderSegmented(cell, config: config, cellIndexPath: indexPath)
            break
        default:
            println("Error: viewType not supported")
        }
        return cell
    }
    
    func renderSegmented(cell: FilterCell, config: [[String:String]], cellIndexPath: NSIndexPath) -> Void {
        var items : [String] = [String]()
        for item in config {
            items.append(item["label"]!)
        }
        var segmented = UISegmentedControl(items: items)
        segmented.frame = CGRect(x: 10, y: 10, width: 300, height: 30)
        segmented.multipleTouchEnabled = true
        cell.accessoryView = segmented
    }
    
    func renderSwitch(cell: FilterCell, config: [[String:String]], cellIndexPath: NSIndexPath) -> Void {
        var itemSwitch = UISwitch(frame: CGRectZero)
        itemSwitch.tag = cellIndexPath.section * 100 + cellIndexPath.row
        itemSwitch.addTarget(self, action: "onSwitch:", forControlEvents: UIControlEvents.ValueChanged)
        cell.accessoryView = itemSwitch
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 15))
        var headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 320, height: 15))
        var filter = self.filters[section]
        headerLabel.text = filter["section"] as AnyObject! as NSString
        headerLabel.textColor = UIColor.grayColor()
        headerLabel.font = UIFont(name: headerLabel.font.fontName, size: 14)
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
/*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
*/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let expanded = isExpanded[indexPath.section] {
            isExpanded[indexPath.section] = !expanded
        } else {
            isExpanded[indexPath.section] = true
        }
        tableView.reloadData()
        */
        if (isExpanded[indexPath.section] != nil) {
            isExpanded[indexPath.section] = !isExpanded[indexPath.section]!
        } else {
            isExpanded[indexPath.section] = false
            var cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as FilterCell
            
            var filter = self.filters[indexPath.section]
            var config = filter["config"] as AnyObject! as [[String:String]]
            cell.filterTitle.text = config[indexPath.row]["label"] as String!
        }
        
        selectedStates[indexPath.section] = indexPath.row
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    @IBAction func onCancelFilter(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onFilterSet(sender: UIBarButtonItem) {
        if (delegate != nil) {
            delegate!.filtersUpdated(self)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onSwitch(sender: UISwitch) {
        //println(switchStates)
        if (sender.on) {
            switchStates[sender.tag] = true
        } else {
            switchStates[sender.tag] = false
        }
        println(switchStates)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
