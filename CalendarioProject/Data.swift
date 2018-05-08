
/*
 This is where you will be getting your data from a different source.
 */

import UIKit

class Data {
    
    static func getData(completion: @escaping ([Model]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            var data = [Model]()
            data.append(Model(title: "Rio de Janeiro", subTitle: "few clouds", image: getImages(weather: "few clouds"), data1: "13PM", data2: "40º"))
            data.append(Model(title: "Barcelona", subTitle: "few clouds", image: getImages(weather: "few clouds"), data1: "18PM", data2: "18º"))
            data.append(Model(title: "Londres", subTitle: "light rain", image: getImages(weather: "light rain"), data1: "19PM", data2: "15º"))
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    
    static func getImages(weather: String) -> UIImage {
        var image: UIImage!
        if weather == "few clouds"{
            image = #imageLiteral(resourceName: "Icon-FewClouds")
            return image
        } else if weather == "moderate rain"{
            image = #imageLiteral(resourceName: "Icon-ModerateRain")
            return image
        } else if weather == "light rain"{
            image = #imageLiteral(resourceName: "Icon-lightrain")
            return image
        }else {
            image = #imageLiteral(resourceName: "Icon-ClearSky")
            return image
        }
    }
            
    
    static func getDayAndWeather(completion: @escaping (DayWeatherModel?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let data = DayWeatherModel(dayName: "min: 19º  max: 23º", longDate: "22 de abril, 2018", temperature: "21º", city: "Belo Horizonte", weatherIcon: #imageLiteral(resourceName: "Icon-ClearSky"))
            
            DispatchQueue.main.async {
               completion(data)
            }
        }
    }
    
}
