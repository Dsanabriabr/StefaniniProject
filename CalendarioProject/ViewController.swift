
import UIKit
import SQLite

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuView: UIViewX!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var searchMenuView: UIView!
    @IBOutlet weak var buttonMenu: FloatingActionButton!
    @IBOutlet weak var buttonAgendar: UIButtonX!
    @IBOutlet weak var buttonAct2: UIButtonX!
    @IBOutlet weak var buttonAct3: UIButtonX!
    @IBOutlet weak var SearchPickerMenu: UIPickerView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var tableData: [Model] = []
    var dayWeatherData: DayWeatherModel?
    var effect: UIVisualEffect!
    var citiesList: [String] = []
    var idList: [Int] = []
    var idSearch: Int?
    var database: Connection!
    let citiesTable = Table("cities")
    let id = Expression<Int>("id")
    let idCity = Expression<Int>("idCity")
    let name = Expression<String>("name")
    let weather = Expression<String>("weather")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        tableView.dataSource = self
        SearchPickerMenu.delegate = self
        SearchPickerMenu.dataSource = self
        getCities()
        addNavBarImage()
        createTableSQLite()
        
        //#SQL connection
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("cities").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch{
            print(error)
        }
        
        
        Data.getDayAndWeather{ (data) in
            if let data = data{
                self.dayLabel.text = data.dayName
                self.dateLabel.text = data.longDate
                self.tempLabel.text = data.temperature
                self.cityLabel.text = data.city
                self.weatherLabel.image = data.weatherIcon
                }
        }
        Data.getData { (data) in
            self.tableData = data
            self.tableView.reloadData()
        }
        
        closeMenu()
        setupAnimatedControls()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.dateView.transform = .identity
            self.tempView.transform = .identity
        }) { (sucess) in
            
        }
    }
    public func createTableSQLite(){
        let createTable = self.citiesTable.create{ (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.idCity)
            table.column(self.name)
            table.column(self.weather)
        }
        do {
            try self.database.run(createTable)
            print("Create Table")
        } catch {
            print(error)
        }
    }
    public func insertCitySQLite(){
        let insertCity = self.citiesTable.insert(self.idCity <- idCity, self.name <- name, self.weather <- weather)
        do{
            try self.database.run(insertCity)
            print("cidade favoritos")
        } catch {
            print(error)
        }
    }
    public func listCitiesSQLite(){
        do {
            let cities = try self.database.prepare(self.citiesTable)
            for citie in cities {
                print("id: \(citie[self.id]), name: \(citie[self.name]), weather: \(citie[self.weather])")
            }
        } catch {
            print (error)
        }
    }
    public func deleteCitySQLite(idCity: Int){
        let city = self.citiesTable.filter(self.idCity == idCity)
        let deleteCity = city.delete()
        do{
            try self.database.run(deleteCity)
        } catch {
            print(error)
        }
        
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return citiesList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return citiesList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        idSearch = row
    }
    func addNavBarImage(){
        let navController = navigationController!
        let image = #imageLiteral(resourceName: "icon-Logo")
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        navigationItem.titleView = imageView
    }
    public func getCities(){
        if let file = Bundle.main.path(forResource: "citylist.json", ofType: nil){
            let url = URL(fileURLWithPath: file)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                do {
                    //Decode retrived data with JSONDecoder and assing type of Article object
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(CityList.self, from: data!)
                    //Get back to the main queue
                    DispatchQueue.main.async {
                        for data in responseModel.data!{
                            self.citiesList.append(data.name)
                            self.idList.append(data.id)
                        }
                        self.SearchPickerMenu.reloadAllComponents()
                    }
                    
                } catch let jsonError {
                    print(jsonError)
                }
                }.resume()
        }
    }
    
    func animateIn(){
        self.view.addSubview(searchMenuView)
        searchMenuView.center = self.view.center
        searchMenuView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.4){
            self.tempView.isHidden = true
            self.dateView.isHidden = true
            self.buttonMenu.isHidden = true
            self.tableView.isHidden = true
            
            self.navigationController?.navigationBar.isHidden = true
            self.menuView.isHidden = true
            self.visualEffectView.effect = self.effect
      
            self.searchMenuView.alpha = 1
            self.searchMenuView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.searchMenuView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.searchMenuView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success:Bool) in
            self.searchMenuView.removeFromSuperview()
            self.tempView.isHidden = false
            self.dateView.isHidden = false
            self.menuView.isHidden = false
            self.buttonMenu.isHidden = false
            self.tableView.isHidden = false
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    func setupAnimatedControls(){
        dateView.transform = CGAffineTransform(translationX: -dateView.frame.width, y:0)
        tempView.transform = CGAffineTransform(translationX: tempView.frame.width, y:0)
    }
    func closeMenu(){
        menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        buttonAgendar.transform = CGAffineTransform(translationX: 0, y:15)
        buttonAct2.transform = CGAffineTransform(translationX: 11, y:11)
        buttonAct3.transform = CGAffineTransform(translationX: 15, y:0)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dtlview = segue.destination as! DetailViewController
        dtlview.query = sender as! Int
    }
    @IBAction func menuTapped(_ sender: FloatingActionButton) {
        self.view.bringSubview(toFront: menuView)
        self.view.bringSubview(toFront: buttonMenu)
        UIView.animate(withDuration: 0.3, animations: {
            if self.menuView.transform == .identity {
                self.closeMenu()
            } else {
                self.menuView.transform = .identity
            }
            })
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
            if self.menuView.transform == .identity{
                self.buttonAgendar.transform = .identity
                self.buttonAct3.transform = .identity
                self.buttonAct2.transform = .identity
            }
        })
    }
    
    @IBAction func searchDone(_ sender: Any) {
        animateOut()
        performSegue(withIdentifier: "makeTransition", sender: idList[idSearch!])
    }
    @IBAction func searchMenu(_ sender: Any) {
        animateIn()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var total = 0
        do {
            let cities = try self.database.prepare(self.citiesTable)
            for citie in cities {
                total = total + 1
            }
        } catch {
            print (error)
        }
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        cell.setup(model: tableData[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "makeTransition", sender: idList[indexPath.row])
        
    }
}
