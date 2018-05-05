
/*
 This is where you will be getting your data from a different source.
 */

import UIKit

class Data {
    
    static func getData(completion: @escaping ([Model]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            var data = [Model]()
            data.append(Model(title: "Estudar AED", subTitle: "3º periodo", image: [], data1: "8", data2: "AM"))
            data.append(Model(title: "Prova AED", subTitle: "3º periodo", image: [], data1: "8:50", data2: "AM"))
            data.append(Model(title: "Calourada", subTitle: "DASistemas", image: getImages(), data1: "01", data2: "PM"))
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    static func getImages() -> [UIImage]{
        var images = [UIImage]()
        images.append(#imageLiteral(resourceName: "profile-pic3"))
        images.append(#imageLiteral(resourceName: "profile-pic2"))
        images.append(#imageLiteral(resourceName: "profile-pic1"))
        return images
    }
    static func getDayAndWeather(completion: @escaping (DayWeatherModel?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let data = DayWeatherModel(dayName: "Domingo", longDate: "22 de abril, 2018", temperature: "21º", city: "Belo Horizonte", weatherIcon: #imageLiteral(resourceName: "Icon-Sun"))
            
            DispatchQueue.main.async {
               completion(data)
            }
        }
    }
    
}
