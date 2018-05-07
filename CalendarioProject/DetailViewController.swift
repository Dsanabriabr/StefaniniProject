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
    @IBOutlet weak var textLbl: UITextView!
    
    var locationManager = CLLocationManager.init()
    var location = CLLocationCoordinate2D.init()
    var query: Int = 0
    override func viewDidLoad() {
        getCitie()
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        let region = MKCoordinateRegion.init(center: location, span: span)
        mapView.setRegion(region, animated: true)
        mapView.mapType = .standard
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func getImage(weather: String) -> UIImage {
        var image: UIImage!
        if weather == "Clouds"{
            image = #imageLiteral(resourceName: "Icon-FewClouds")
            return image
        } else if weather == "Rain"{
            image = #imageLiteral(resourceName: "Icon-ModerateRain")
            return image
        } else if weather == "Drizzle"{
            image = #imageLiteral(resourceName: "Icon-lightrain")
            return image
        }else {
            image = #imageLiteral(resourceName: "Icon-ClearSky")
            return image
        }
    }
    private func getDoubleStrWith4DecimalDigits(value: Double) -> String {
        return String(format: "%.4f", value)
    }
    @IBAction func favoriteTapped(_ sender: Any) {
    }
    public func getCitie(){
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?id=\(query)&appid=2bac87e0cb16557bff7d4ebcbaa89d2f&lang=pt&units=metric")!
        print (url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(CityInformations.self, from: responseData)
                dump(responseModel)
                //Get back to the main queue
                DispatchQueue.main.async {
                self.nameCity.text = responseModel.name
                self.latCity.text = "lat: \(self.getDoubleStrWith4DecimalDigits(value: responseModel.coordcity.lat!))"
                self.lonCity.text = "lon: \(self.getDoubleStrWith4DecimalDigits(value: responseModel.coordcity.lon!))"
                self.humidCity.text = "Humidade: \(responseModel.main.humidity)"
                self.tempCity.text = "\(String(describing: responseModel.main.temp))º"
                self.maxTemp.text = "max: \(responseModel.main.temp_max)º"
                self.tempMin.text = "min: \(responseModel.main.temp_min)º"
                self.location = CLLocationCoordinate2D(latitude: responseModel.coordcity.lat!, longitude: responseModel.coordcity.lon!)
                self.windCity.text = "ventos: \(String(describing: responseModel.wind.speed))km/h"
                self.textLbl.text = responseModel.weather[0].description
                self.weatherCity.image = self.getImage(weather: responseModel.weather[0].main!)
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation ){
        
    }
}

