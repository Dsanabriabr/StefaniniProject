
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuView: UIViewX!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var searchMenuView: UIView!
    @IBOutlet weak var buttonMenu: FloatingActionButton!
    @IBOutlet weak var buttonAgendar: UIButtonX!
    @IBOutlet weak var buttonAct2: UIButtonX!
    @IBOutlet weak var buttonAct3: UIButtonX!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var tableData: [Model] = []
    var dayWeatherData: DayWeatherModel?
    var effect:UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        tableView.dataSource = self
        
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
    @IBAction func searchDone(_ sender: Any) {
        animateOut()
    }
    @IBAction func searchMenu(_ sender: Any) {
        animateIn()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        cell.setup(model: tableData[indexPath.row])
        return cell
    }
}
