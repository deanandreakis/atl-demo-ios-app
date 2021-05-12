//
//  NavigationViewController.swift
//  atlantademo
//
//  Created by Dean Andreakis on 9/18/17.
//  Copyright © 2017 gisi. All rights reserved.
//

import UIKit
import ArcGIS
import AtriusCore
import AtriusRoute
import CoreData

class NavigationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, TripCustomCellDelegate, AGSGeoViewTouchDelegate, ZoneInfoClassDelegate {

    @IBOutlet weak var aMapView: AGSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var beginButtonYConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonYConstraint: NSLayoutConstraint!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButtonYConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonYConstraint: NSLayoutConstraint!
    
    let routeDataClass = RouteDataClass()
    let simulateLocation = SimulateLocation()
    
    private var graphicsOverlay = AGSGraphicsOverlay()
    private var locationOverlay = AGSGraphicsOverlay()
    var mobileMapPackage: AGSMobileMapPackage!
    var directionsOn: Bool = false
    var routeSimulatorTimer = Timer()  //the timer we will use to simulate a route between two locations
    var simCoordinates: Array<ATRCoordinate> = [ATRCoordinate]()
    var walkTime: Float = 0 // in seconds
    
    let zoneInfoController = ZoneInfoClass()
    var zoneInfo: [String: Any] = [:];
    var stopInfo: [String: Any] = [:];
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        zoneInfoController.delegate = self;
        
        let myNotification = Notification.Name(rawValue:"RouteGenerated")
        NotificationCenter.default.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotification)
        let routeArray: Array = [ATLANTA_GATE_T8_X,ATLANTA_GATE_T8_Y,ATLANTA_GATE_T2_X,ATLANTA_GATE_T2_Y]
        routeDataClass.requestRoute(routeArray)
        
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue: "CoordinateUpdated"), object:nil, queue:nil, using:coordinateNotification)
        
        if let mapFileURL = Bundle.main.url(forResource: "ATL_TGATE2018", withExtension: "mmpk") {
            self.mobileMapPackage = AGSMobileMapPackage(fileURL: mapFileURL)
        }
        
        self.mobileMapPackage.load {[weak self] (error) -> Void in guard error == nil else {
            print(error!.localizedDescription)
            return
            }
            let myMap : AGSMap = (self?.mobileMapPackage.maps[0])!
            //self?.aMapView.map = AGSMap(basemapType: .imageryWithLabels, latitude: 33.640411, longitude: -84.419853, levelOfDetail: 1000)
            let viewpoint = AGSViewpoint(latitude: 33.638408, longitude: -84.442327, scale: 2500)
            //self?.aMapView.setViewpoint(viewpoint)
            myMap.initialViewpoint = viewpoint
            self?.aMapView.map = myMap
            
            //add self as the touch delegate for the map view
            self?.aMapView.touchDelegate = self
            
            //add graphics overlay to the map view
            self?.aMapView.graphicsOverlays.add(self!.graphicsOverlay)
            self?.aMapView.graphicsOverlays.add(self!.locationOverlay)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        previousButton.isHidden = true
        nextButton.isHidden = true
        previousButtonYConstraint.constant = 38
        nextButtonYConstraint.constant = 38
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = false
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.register(UINib (nibName: "TripCustomCell", bundle: nil), forCellReuseIdentifier: "tripCell")
        tableView.register(UINib (nibName: "TripRouteCell", bundle: nil), forCellReuseIdentifier: "tripRouteCell")
        self.tableView.rowHeight = 38;
    }
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification: Route Generated")
        
        guard let userInfo = notification.userInfo,
            let segments  = userInfo["segments"] as? Array<ATRRouteSegment> else {
                print("No userInfo found in notification")
                return
        }
        stopInfo.removeAll()
        simCoordinates.removeAll()
        let stops = userInfo["stops"] as? Array<ATRPoint>
        if let stops = stops {
            if (stops.count > 0) {
                stopInfo["first"] = stops[0];
                stopInfo["last"] = stops[stops.count-1]
            }
        }
        
        //lets get the total walk time
        let timeToWalk = userInfo["timeLeft"] as? NSNumber //in ms
        self.walkTime = timeToWalk!.floatValue / 1000
        self.refreshUI()
        
        self.graphicsOverlay.graphics.removeAllObjects()
        if (segments.count > 0) {
            let lineSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.blue, width: 3)
            for segment: ATRRouteSegment in segments {
  
                for line: ATRRouteLine in segment.lines {
                    //convert to esri polyline
                    let polyline: AGSPolyline = createPolyline(coordinates: line.coordinates)
                    //add graphic to map
                    self.graphicsOverlay.graphics.add(AGSGraphic(geometry: polyline, symbol: lineSymbol, attributes: nil))
                }
            }
            
            let view = self.graphicsOverlay.extent;
            self.aMapView.setViewpointGeometry(view, padding: 150, completion: nil)
            
            //create location simulator
            self.locationOverlay.graphics.removeAllObjects()
            let markerSymbol = AGSSimpleMarkerSymbol(style: .circle, color: UIColor.red, size: 14)
            let point: AGSPoint = createPoint(coordinate: simCoordinates[0])
            self.locationOverlay.graphics.add(AGSGraphic(geometry: point, symbol: markerSymbol, attributes: nil))
            simulateLocation.restartSimulation()
        }
    }
    
    func coordinateNotification(notification:Notification) -> Void {
        guard let userInfo = notification.userInfo,
            let coordinate  = userInfo["currentCoord"] as? ATRCoordinate else {
                print("No userInfo found in notification")
                return
        }
        //create location simulator
            self.locationOverlay.graphics.removeAllObjects()
            let markerSymbol = AGSSimpleMarkerSymbol(style: .circle, color: UIColor.red, size: 14)
            let point: AGSPoint = createPoint(coordinate: coordinate)
            self.locationOverlay.graphics.add(AGSGraphic(geometry: point, symbol: markerSymbol, attributes: nil))
        
        //lets update the walk time TODO: update the SimulateLocation object to send us simulated updated walk times
        //let timeToWalk = userInfo["timeLeft"] as? NSNumber //in ms
        //self.walkTime = timeToWalk!.intValue / 1000
        if(self.walkTime > 0)
        {
            self.walkTime = self.walkTime - 0.4
        }
        self.refreshUI()
    }
    
    private func createPoint(coordinate: ATRCoordinate) -> AGSPoint {
        // create a point using x,y coordinates and a spatial reference
        let point = AGSPoint(x: coordinate.x, y: coordinate.y, spatialReference: AGSSpatialReference.wgs84())
        return point
    }
    private func createPolyline(coordinates: Array<ATRCoordinate> ) -> AGSPolyline {
        //create a polyline
        let polylineBuilder = AGSPolylineBuilder(spatialReference: AGSSpatialReference.wgs84())
        
        for coordinate: ATRCoordinate in coordinates {
            polylineBuilder.addPointWith(x: coordinate.x, y: coordinate.y)
            
            //need to collect all points on lines in a list that can use to simulate movement
            simCoordinates.append(coordinate)
        }
        
        simulateLocation.simCoordinates = simCoordinates
        
        return polylineBuilder.toGeometry()
    }
    
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        //get the geoElements for all layers present at the tapped point
        //let alert = UIAlertController(title: "My Alert", message: AGSCoordinateFormatter.latitudeLongitudeString(from: mapPoint, format: .decimalDegrees, decimalPlaces: 6), preferredStyle: .alert)
        //self.present(alert, animated: true, completion: nil)
        
    }
    
    func runRouteSimulatorTimer() {
        routeSimulatorTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (Timer) in
            //use esri sdk api to draw line segments showing a route between two given gates/locations
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.routeSimulatorTimer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //provide a mechanism to start the route simulator timer in cases where we can't use the atrius stuff
        //self.runRouteSimulatorTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshUI() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    @IBAction func playPauseButtonSelected(_ sender: Any) {
        
        let btn:UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
        
        if btn.isSelected {
            btn.setTitle("Pause", for: .normal)
            //show the triproutecell overlay for the turn by turn directions to the gate
            self.directionsOn = true
            previousButton.isHidden = false
            nextButton.isHidden = false
            //start simulation timer
            simulateLocation.startSimulation()
        }
            
        else {
            btn.setTitle("Begin", for: .normal)
            self.directionsOn = false
            previousButton.isHidden = true
            nextButton.isHidden = true
            //pause simulation
            simulateLocation.pauseSimulation()
        }
        self.refreshUI()
    }
    
    //TODO: Jason : This is where we would split-out the logic to get wait times for the various stops (restroom, restaurant etc.). Right now
    //they are hard-coded for demo purposes but refactor this as necessary to add handlers (currently nil) etc. I would then key off of this
    //depending on what the user finally selects and drop a pin on the map on the selected stop along the route.
    @IBAction func addButtonSelected(_ sender: Any) {
        let sr: AGSSpatialReference = AGSSpatialReference(wkid: 4326)!
        
        let alertController = UIAlertController(title: "Add Stop Along Route", message: "Please Choose An Option", preferredStyle: .actionSheet)
        
        let restroomButton = UIAlertAction(title: "Restroom", style: .default, handler: { (action) -> Void in
            let alertTitle = "Restroom"
            let alertControllerOptions = UIAlertController(title: alertTitle, message: "Choose a stop along your route", preferredStyle: .actionSheet)
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                let restLoc: AGSPoint = AGSPoint(x: -84.4424621, y: 33.6375572, spatialReference: sr)
                let info: [String:Any] = ["name":"Food", "wait":5, "location":restLoc]
                self.AddStop(stopData: info)
            }
            alertControllerOptions.addAction(UIAlertAction(title: "Terminal T2 - 0 min wait", style: .default, handler:callActionHandler))
            alertControllerOptions.addAction(UIAlertAction(title: "Terminal T8 - 3 min wait", style: .default, handler:nil))
            alertControllerOptions.addAction(UIAlertAction(title: "Terminal T4 - 2 min wait", style: .default, handler:nil))
            self.navigationController!.present(alertControllerOptions, animated: true, completion: nil)
        })
        
        let foodButton = UIAlertAction(title: "Food", style: .default, handler: { (action) -> Void in
            let alertTitle = "Food"
            let alertControllerOptions = UIAlertController(title: alertTitle, message: "Choose a stop along your route", preferredStyle: .actionSheet)
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                let foodLoc: AGSPoint = AGSPoint(x: -84.4424862, y: 33.6382237, spatialReference: sr)
                let info: [String:Any] = ["name":"Food", "wait":5, "location":foodLoc]
                self.AddStop(stopData: info)
            }
            alertControllerOptions.addAction(UIAlertAction(title: "Corner Bakery - 5 min wait", style: .default, handler:callActionHandler))
            alertControllerOptions.addAction(UIAlertAction(title: "Jamba Juice - 10 min wait", style: .default, handler:nil))
            self.navigationController!.present(alertControllerOptions, animated: true, completion: nil)
        })
        
        let shoppingButton = UIAlertAction(title: "Shopping", style: .default, handler: { (action) -> Void in
            let alertTitle = "Shopping"
            let alertControllerOptions = UIAlertController(title: alertTitle, message: "Choose a stop along your route", preferredStyle: .actionSheet)
            self.zoneInfo.forEach({ (keyValue, val) in
                if (1==1) {
                    let info: Dictionary<String, Any> = val as! Dictionary
                    let name = info["name"] as? String
                    let waitTime = info["wait"] as? Double
                    let title:String = "\(name ?? "Unknown") - \(waitTime ?? 0.0) min wait"
                    let callActionHandler = { (action:UIAlertAction!) -> Void in
                        self.AddStop(stopData: info)
                    }
                    alertControllerOptions.addAction(UIAlertAction(title: title, style: .default, handler:callActionHandler))
                }
            })
            //alertControllerOptions.addAction(UIAlertAction(title: "Terminal B - 2 min walk - 6 min wait", style: .default, handler:nil))
            //alertControllerOptions.addAction(UIAlertAction(title: "Terminal B - 8 min walk - 0 min wait", style: .default, handler:nil))
            //alertControllerOptions.addAction(UIAlertAction(title: "Terminal T - 13 min walk - 2 min wait", style: .default, handler:nil))
            self.navigationController!.present(alertControllerOptions, animated: true, completion: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        })
        
        
        alertController.addAction(restroomButton)
        alertController.addAction(foodButton)
        alertController.addAction(shoppingButton)
        alertController.addAction(cancelButton)
        
        if isTravelerMedallionMember() {
            let securityButton = UIAlertAction(title: "Security", style: .default, handler: { (action) -> Void in
                let alertTitle = "Security"
                let alertControllerOptions = UIAlertController(title: alertTitle, message: "Choose a stop along your route", preferredStyle: .actionSheet)
                alertControllerOptions.addAction(UIAlertAction(title: "Terminal B - 2 min walk - 6 min wait", style: .default, handler:nil))
                alertControllerOptions.addAction(UIAlertAction(title: "Terminal B - 8 min walk - 0 min wait", style: .default, handler:nil))
                alertControllerOptions.addAction(UIAlertAction(title: "Terminal T - 13 min walk - 2 min wait", style: .default, handler:nil))
                self.navigationController!.present(alertControllerOptions, animated: true, completion: nil)
            })
            
            alertController.addAction(securityButton)
        }
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func AddStop(stopData: Dictionary<String, Any>)
    {
        let currentLocation: AGSGraphic = self.locationOverlay.graphics.object(at: 0) as! AGSGraphic
        let currentStart: AGSPoint = currentLocation.geometry as! AGSPoint
        let savedStop: ATRPoint = (stopInfo["last"] as? ATRPoint)!
        let currentStop: AGSPoint = AGSPoint(x: savedStop.x, y: savedStop.y, spatialReference: AGSSpatialReference(wkid: 4326))
        
        let stops: [AGSPoint] = [currentStart, stopData["location"] as! AGSPoint, currentStop];

        let markerSymbol = AGSSimpleMarkerSymbol(style: .circle, color: UIColor.blue, size: 14)
        let point: AGSPoint = stopData["location"] as! AGSPoint
        self.graphicsOverlay.graphics.add(AGSGraphic(geometry: point, symbol: markerSymbol, attributes: nil))
        
        routeDataClass.requestRoute(withStop: stops)
        if (self.playPauseButton.currentTitle == "Pause") {
            self.playPauseButtonSelected(self.playPauseButton)
        }
        //simulateLocation.pauseSimulation()
        
    }
    
    func isTravelerMedallionMember()->Bool
    {
        var retVal : Bool = false
        if(!HomeViewController.isAirportEmployee())
        {
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return false
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<Traveler>(entityName: "Traveler")
            do {
                let results =  try managedContext.fetch(request)
                let currentTraveler =  results.first
                if(currentTraveler?.rewardStatus?.contains("Medallion"))! {
                    retVal = true
                } else {
                    retVal = false
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        return retVal
    }
    
    // MARK: Next Previous Button Actions for Direction Overlay
    @IBAction func prevButtonSelected(_ sender: Any) {
        print ("prev btn")
    }
    
    @IBAction func nextButtonSelected(_ sender: Any) {
        print ("next btn")
    }
    
    // MARK: - TripCustomCellDelegate
    func moreButtonSelected() {
    }
    
    // MARK: - Table View DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return 2 //take into account turn by turn directions
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if(indexPath.section == 0 && indexPath.row == 1)//turn by turn directions
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "tripRouteCell", for: indexPath)
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }
        else{
            return 490
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 1){
            let view = UIView()
            view.isUserInteractionEnabled = false
            view.backgroundColor = .clear
            return view
        }
        else {
          return nil
        }
    }
    
    // MARK: - Table View Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.section == 0 && indexPath.row == 1)//turn by turn directions
        {
            configureTripRouteCell(cell as! TripRouteCell, forRowAt: indexPath)
        }
        else
        {
            configureCell(cell as! TripCustomCell, forRowAt: indexPath)
        }
    }
    
    func configureTripRouteCell(_ cell: TripRouteCell, forRowAt indexPath: IndexPath) {
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        if(self.directionsOn)
        {
            //cell.delegate = self
            cell.isUserInteractionEnabled = true
            cell.selectionStyle = UITableViewCellSelectionStyle.default
            cell.isHidden = false
            cell.backgroundColor = UIColor(red:119/255.0, green:153/255.0,blue:204/255.0,alpha:1.0)
            cell.contentView.backgroundColor = UIColor(red:119/255.0, green:153/255.0,blue:204/255.0,alpha:1.0)
            var s:String
            if(HomeViewController.isAirportEmployee())
            {
                s = "Directions To Gate T5"
            }
            else
            {
                s = "Directions To Gate T2"
            }
            
            let myMutableString = NSMutableAttributedString(
                string: s,
                attributes: [NSAttributedStringKey.font:UIFont(
                    name: "System Font Regular",
                    size: 17.0)!])
            
            myMutableString.addAttribute(
                NSAttributedStringKey.foregroundColor,
                value: UIColor.white,
                range: NSRange(
                    location:0,
                    length:21)
            )
            cell.directionsToLabel.attributedText = myMutableString
            
            
            let myMutableString2 = NSMutableAttributedString(
                string: "Step 1 of 8: Walk Faster!",
                attributes: [NSAttributedStringKey.font:UIFont(
                    name: "System Font Regular",
                    size: 17.0)!])
            
            myMutableString2.addAttribute(
                NSAttributedStringKey.foregroundColor,
                value: UIColor.white,
                range: NSRange(
                    location:0,
                    length:25)
                )
            
            cell.stepsLabel.attributedText = myMutableString2
        }
        else
        {
            cell.isUserInteractionEnabled = false
            cell.isHidden = true
        }
    }
    
    func configureCell(_ cell: TripCustomCell, forRowAt indexPath: IndexPath) {
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            cell.DepartArriveCityLabelYConstraint.constant = -12
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.default
            cell.isUserInteractionEnabled = false
            cell.VerticalMoreButton.isHidden = true
            cell.backgroundColor = UIColor(red:119/255.0, green:153/255.0,blue:204/255.0,alpha:1.0)
            cell.contentView.backgroundColor = UIColor(red:119/255.0, green:153/255.0,blue:204/255.0,alpha:1.0)
            cell.GateBoardDescriptioLabel.text = ""
            
            if(HomeViewController.isAirportEmployee())
            {
                let myMutableString2 = NSMutableAttributedString(
                    string: "Wheelchair Assistance - T5    Est. 7 mins",
                    attributes: [NSAttributedStringKey.font:UIFont(
                        name: "System Font Regular",
                        size: 17.0)!])
                
                myMutableString2.addAttribute(
                    NSAttributedStringKey.foregroundColor,
                    value: UIColor.red,
                    range: NSRange(
                        location:26,
                        length:15))
                
                cell.DepartArriveCityLabel.attributedText = myMutableString2
            }
            else
            {
                let timeString:String = String(Int(walkTime/60))
                let myMutableString = NSMutableAttributedString(
                    string: "Gate T8 - Gate T2    Est. " + timeString + " mins",
                    attributes: [NSAttributedStringKey.font:UIFont(
                        name: "System Font Regular",
                        size: 17.0)!])
                
                myMutableString.addAttribute(
                    NSAttributedStringKey.foregroundColor,
                    value: UIColor.red,
                    range: NSRange(
                        location:21,
                        length:(10 + timeString.count)))
                
                cell.DepartArriveCityLabel.attributedText = myMutableString
            }
            cell.GrayGreenDotImageView.image = UIImage(named:"OvalGreen")
        }
        else if(indexPath.section == 1 && indexPath.row == 0)
        {
            cell.DepartArriveCityLabelYConstraint.constant = -12
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.default
            cell.isUserInteractionEnabled = false
            cell.VerticalMoreButton.isHidden = true
            cell.backgroundColor = UIColor(red:119/255.0, green:153/255.0,blue:204/255.0,alpha:1.0)
            cell.contentView.backgroundColor = UIColor(red:119/255.0, green:153/255.0,blue:204/255.0,alpha:1.0)
            cell.GateBoardDescriptioLabel.text = ""
            let myMutableString2 = NSMutableAttributedString(
                string: "Gate T2 - Delta 1988  Boards in 55 mins",
                attributes: [NSAttributedStringKey.font:UIFont(
                    name: "System Font Regular",
                    size: 17.0)!])
            myMutableString2.addAttribute(
                NSAttributedStringKey.foregroundColor,
                value: UIColor.red,
                range: NSRange(
                    location:22,
                    length:17))
            cell.DepartArriveCityLabel.attributedText = myMutableString2
            cell.GrayGreenDotImageView.image = UIImage(named:"OvalGray")
        }
        else
        {
            cell.isUserInteractionEnabled = false
            cell.VerticalMoreButton.isHidden = true
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.GateBoardDescriptioLabel.text = ""
            cell.DepartArriveCityLabel.text = ""
            cell.GrayGreenDotImageView.isHidden = true
        }
        
        if(indexPath.section == 1){
            //adjust the constraints on the buttons to bump them up because we added rows on the bottom
            addButtonYConstraint.constant = 50
            beginButtonYConstraint.constant = 50
        }
    }
    
    func metricsDidUpdate(_ metrics: [AnyHashable : Any]!) {
        zoneInfo.removeAll();
        for (metricKey, metricValue) in metrics {
            zoneInfo[metricKey as! String] = metricValue
        }
    }
}
