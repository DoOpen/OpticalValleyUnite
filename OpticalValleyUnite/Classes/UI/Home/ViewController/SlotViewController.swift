//
//  SlotViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/20.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class SlotViewController: UIViewController {
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var mapView: MAMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateView: DateChooseView!

    var models = [SignModel](){
        didSet{
            addMAAnnotations()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Date.dateStringDate(dateFormetString: "YYYY-MM-dd")
        mapSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100;

        
        getData(Date.dateStringDate(dateFormetString: "YYYY-MM-dd"))
        let nib = UINib(nibName: "SigninCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        dateView.didSelectHandle = { [weak self] dateStr in
            
            self?.getData(dateStr)
            self?.title = dateStr
        }
    }

    
    func addMAAnnotations(){
        
        mapView.removeAnnotations(mapView.annotations)
        
        if models.count == 0 {
            return
        }
        
       for model in models{
            
            let annotation = FootAnnotation(model: model)
            annotation.index = mapView.annotations.count
            mapView.addAnnotation(annotation)
        
        
        }
        
        mapView.reloadMap()
        
    }
    
    
    @IBAction func listBtnClick() {
        listBtn.isSelected = true
        mapBtn.isSelected = false
        
        tableView.isHidden = false
        mapView.isHidden = true
    }
    @IBAction func mapBtnClick() {
        mapBtn.isSelected = true
        listBtn.isSelected = false
        
        tableView.isHidden = true
        mapView.isHidden = false
        mapView.showAnnotations(mapView.annotations, animated: true)
    }


    func  mapSetup(){
        
        AMapServices.shared().enableHTTPS = true
        mapView.showsUserLocation = true;
        mapView.userTrackingMode = .followWithHeading;
        mapView.delegate = self
        mapView.zoomLevel = 17.0

    }
    
    func getData(_ date: String){
        
        var parmat = [String: Any]()
        parmat["date"] = date
        
        let url = URLPath.getPersonPosList

        SVProgressHUD.show()
        
        HttpClient.instance.get(path: url, parameters: parmat, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            var temp = [SignModel]()
            
            if let arry = response as? Array<[String: Any]>{
                for dic in arry {
                    let model = SignModel(parmart: dic)
                    temp.append(model)
                }
            }
            
            if temp.isEmpty{
                SVProgressHUD.showSuccess(withStatus: "数据为空")
            }
            
            self.models = temp
            self.tableView.reloadData()
            
        }) { (error) in
            
        }
    }

}

extension SlotViewController: MAMapViewDelegate{
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        //        print(mapView.userLocation.location)
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        
        if let annotation = annotation as? FootAnnotation{
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "cell")
            
            if let view = view{
                view.annotation = annotation
                return view
            }else{
                view = MAAnnotationView(annotation: annotation, reuseIdentifier: "cell")
            }
            let image = UIImage(named: "larpin_red")
            view?.image = image
            view?.canShowCallout = true
            if let label = view?.viewWithTag(101) as? UILabel{
                label.text = "\(annotation.index)"
                label.sizeToFit()
            }else{
                let label = UILabel()
                label.textAlignment = .center
                label.tag = 101
                label.textColor = UIColor.white
                label.font = UIFont.systemFont(ofSize: 14)
                label.width = 25.0
                label.height = 25.0
                label.center = CGPoint(x: (image?.size.width)! * 0.5, y: (image?.size.height)! * 0.5)
                view?.addSubview(label)
                view?.bringSubview(toFront: label)
                label.text = "\(annotation.index)"
                
            }
            
            return view!
        }
        
        return MAAnnotationView()
        
       
    }
}

extension SlotViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SigninCell
        
        let model = models[indexPath.row]
        model.index = indexPath.row
        cell.model = model
        
        return cell
    }
}

class FootAnnotation: NSObject,MAAnnotation{
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var index = 0
    
    init(model: SignModel) {
        coordinate = CLLocationCoordinate2D(latitude:
            CLLocationDegrees(model.MAP_LAT)!, longitude: CLLocationDegrees(model.MAP_LNG)!)
        
        title = ((model.SIGN_TIME as NSString).substring(from: 10) as NSString).substring(to: 6) + " : " + model.ADDRESS
    }
}
