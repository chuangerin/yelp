//
//  ViewController.swift
//  yelp
//
//  Created by Erin Chuang on 9/20/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterDelegate {
    var client: YelpClient!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var restros : [NSDictionary] = []
    var centerLoc : CLLocation = CLLocation()
    var popFilter = "0"
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        self.textField.text = "Thai"
        self.refresh(["term": "Thai", "location": "San Francisco"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restros.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("RestroCell") as RestroCell
        
        var restro = restros[indexPath.row]
        
        var imageUrl = restro["image_url"] as String
        cell.restroImage.setImageWithURL(NSURL(string: imageUrl))
        cell.restroNameLabel.text = restro["name"] as? String
        var ratingImgUrl = restro["rating_img_url_small"] as String
        cell.ratingImg.setImageWithURL(NSURL(string: ratingImgUrl))
        cell.reviewsLabel.text = String(restro["review_count"] as Int) + " Reviews"
        var location = restro["location"] as NSDictionary
        var address = location["address"] as [String]
        var city = location["city"] as String
        cell.addressLabel.text = address[0] + ", " + city
        var categories = restro["categories"] as [[String]]
        var categoryList = ""
        for category in categories {
            if (categoryList != "") {
                categoryList += ", "
            }
            categoryList += category[0]
        }
        cell.categoryLabel.text = categoryList
        if let loc=location["coordinate"] as? NSDictionary {
            var lat = loc["latitude"] as Double
            var long = loc["longitude"] as Double
            var coord = CLLocation(latitude: lat, longitude: long)
            var distance = coord.distanceFromLocation(self.centerLoc)
            var distanceInMile = Double(distance) / 1609.34
            cell.distanceLabel.text = String(format: "%.2f mi", distanceInMile)
        } else {
            cell.distanceLabel.text = ""
        }
        cell.priceLabel.text = ""

        return cell
    }
    
    func refresh(params: [String:String]) {
        client.searchWithTerm(params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            var jsonData: NSData! = NSJSONSerialization.dataWithJSONObject(response, options: NSJSONWritingOptions(0), error: nil)
            var object = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as NSDictionary
            self.restros = object["businesses"] as [NSDictionary]
            var region = object["region"] as NSDictionary
            var center = region["center"] as NSDictionary
            var lat = center["latitude"] as Double
            var long = center["longitude"] as Double
            self.centerLoc = CLLocation(latitude: lat, longitude: long)
            self.tableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    @IBAction func onClick(sender: UIBarButtonItem) {
        var term = self.textField.text as String
        if (term != "") {
            refresh([
                "term": term,
                "location": "San Francisco",
                "deals_filter": self.popFilter
            ])
        } else {
            refresh([
                "location": "San Francisco",
                "deals_filter": self.popFilter
            ])
        }
    }
    
    func filtersUpdated(filterViewController: FilterViewController) {
        let openFilter = filterViewController.switchStates[0] != nil && filterViewController.switchStates[0]!
        let hotFilter = filterViewController.switchStates[1] != nil && filterViewController.switchStates[1]!
        let dealFilter = filterViewController.switchStates[2] != nil && filterViewController.switchStates[2]!
        let deliveryFilter = filterViewController.switchStates[3] != nil && filterViewController.switchStates[3]!
        println(openFilter)
        println(hotFilter)
        println(dealFilter)
        println(deliveryFilter)
        self.popFilter = dealFilter ? "1" : "0"
        self.onClick(UIBarButtonItem())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "filterSegue") {
            let filterVC:FilterViewController = segue.destinationViewController as FilterViewController
            filterVC.delegate = self
        }
    }
}

