//
//  DetailViewController.swift
//  CalendarioProject
//
//  Created by Daniel Sanabria on 06/05/18.
//  Copyright © 2018 Daniel Sanabria. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var weatherCity: UIImageView!
    @IBOutlet weak var tempCity: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var nameCity: UILabel!
    @IBOutlet weak var latCity: UILabel!
    @IBOutlet weak var lonCity: UILabel!
    @IBOutlet weak var humidCity: UILabel!
    @IBOutlet weak var windCity: UILabel!
    
    var locationManager = CLLocationManager.init()
    override func viewDidLoad() {
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: -19.92, longitude: -43.94), span: span)
        mapView.setRegion(region, animated: true)
        mapView.mapType = .standard
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        <#code#>
    }
    @IBAction func favoriteTapped(_ sender: Any) {
    }
    
    public func getCitie(){
        let query = "3470127"
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?id=\(query)&appid=2bac87e0cb16557bff7d4ebcbaa89d2f&lang=pt&units=metric")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(CityInformations.self, from: data!)
                print("\(responseModel)")
                //Get back to the main queue
                DispatchQueue.main.async {
//                    for data in responseModel.data!{
//                        self.cities.append(data.name)
//                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    //    func mapView(_ mapView: MKMapView, didUpdate userLocation: ){
//        
//    }
}

