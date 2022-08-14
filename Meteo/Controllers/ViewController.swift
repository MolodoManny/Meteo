//
//  ViewController.swift
//  Meteo
//
//  Created by Артем Савицкий on 05.08.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate {
    
    let networkManager = WeatherNetworkManager()
    
    let currentLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 38 , weight: .heavy)
        return label
    }()
    
    let currentTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "28 march 2022"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 10 , weight: .heavy)
        return label
    }()
    
    let currentTempatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 60 , weight: .heavy)
        return label
    }()
    let tempDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    let tempSymbol : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "cloud.fill")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .gray
        return img
    }()
    
    let maxTemp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14 , weight: .medium)
        return label
    }()
    
    let minTemp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14 , weight: .medium)
        return label
    }()
    
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var stackView: UIStackView!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem(image: UIImage(systemName: "plus.circle"),  style: .done, target: self , action: #selector(handleAddPlaceButton)),UIBarButtonItem(image: UIImage(systemName: "thermometer"), style: .done , target: self, action: #selector(handleShowForecast)) ,  UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done , target: self, action: #selector(handleRefresh))]
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        transparentNavigationBar()
        
        setupViews()
        layoutViews()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        let location = locations[0].coordinate
        latitude = locations.latitude
        longitude = locations.longitude
        print("Long" , longitude.description)
        print("Lat" , latitude.description)
        loadDataUsingCoordinates(lat: latitude.description , long: longitude.description)
    }
    
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
            print("Current Tempature" ,  weather.main.temp.kelvinToCelciusConverter())
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MM yyyy"
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            DispatchQueue.main.async {
                self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToCelsiusConverter()) + "C")
                self.currentLocation.text = "\(weather.name ?? ""), \(weather.sys.country ?? "")"
                self.tempDescription.text = weather.weather[0].description
                self.currentTime.text = stringDate
                self.minTemp.text = ("Min : " + String(weather.main.temp_min.kelvinToCelsiusConverter()) + "C")
                self.maxTemp.text = ("Max : " + String(weather.main.temp_max.kelvinToCelsiusConverter()) + "C")
                self.tempSymbol.loadImageFromURL( url : "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")" , forKey: "SelectedCity")
            }
        }
    }
    
    func loadDataUsingCoordinates(lat: String , lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon){ (weather) in
            print("Current Tempature" ,  weather.main.temp.kelvinToCelciusConverter())
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MM yyyy"
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            DispatchQueue.main.async {
                self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToCelsiusConverter()) + "C")
                self.currentLocation.text = "\(weather.name ?? ""), \(weather.sys.country ?? "")"
                self.tempDescription.text = weather.weather[0].description
                self.currentTime.text = stringDate
                self.minTemp.text = ("Min : " + String(weather.main.temp_min.kelvinToCelsiusConverter()) + "C")
                self.maxTemp.text = ("Max : " + String(weather.main.temp_max.kelvinToCelsiusConverter()) + "C")
                self.tempSymbol.loadImageFromURL( url : "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")" , forKey: "SelectedCity")
            }
        }
    }
    
    func setupViews(){
        view.addSubview(currentLocation)
        view.addSubview(currentTempatureLabel)
        view.addSubview(tempSymbol)
        view.addSubview(tempDescription)
        view.addSubview(currentTime)
        view.addSubview(minTemp)
        view.addSubview(maxTemp)
    }
    
    func layoutViews() {
        currentLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        currentLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 18).isActive = true
        currentLocation.heightAnchor.constraint(equalToConstant: 70).isActive = true
        currentLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -18).isActive = true
        
        
        currentTime.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: 4).isActive = true
        currentTime.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 18).isActive = true
        currentTime.heightAnchor.constraint(equalToConstant: 10).isActive = true
        currentTime.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -18).isActive = true
        
        
        currentTempatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        currentTempatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 18).isActive = true
        currentTempatureLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        currentTempatureLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        tempSymbol.topAnchor.constraint(equalTo: currentTempatureLabel.bottomAnchor).isActive = true
        tempSymbol.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 18).isActive = true
        tempSymbol.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tempSymbol.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        tempDescription.topAnchor.constraint(equalTo: currentTempatureLabel.bottomAnchor, constant: 12.5).isActive = true
        tempDescription.leadingAnchor.constraint(equalTo: tempSymbol.trailingAnchor , constant: 8).isActive = true
        tempDescription.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tempDescription.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        minTemp.topAnchor.constraint(equalTo: tempSymbol.bottomAnchor, constant: 80).isActive = true
        minTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 18).isActive = true
        minTemp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        minTemp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        maxTemp.topAnchor.constraint(equalTo: minTemp.bottomAnchor).isActive = true
        maxTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 18).isActive = true
        maxTemp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        maxTemp.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
  /*  let imageCache = NSCache<AnyObject , AnyObject>()
    extension UIImageView{
        func loadImageFromURL(url : String){
            self.image = nil
            guard let URL = URL ( string: url) else {
                print("No image this url" , url )
                return
            }
            if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
                self.image = cachedImage
                return
            }
            DispatchQueue.global().async {
                [weak self] in
                if let data = try? Data (contentsOf: URL) {
                    if let image = UIImage(data: data){
                        let imageTocache = image
                        imageCache.setObjects( imageTocache , forKey: url as AnyObject)
                        DispatchQueue.main.async {
                            self?.image = imageTocache
                        }
                    }
                }
            }
        }
    }
}*/

@objc func handeAddPlaceButton(){
    let alertController = UIAlertController( title: "Add city", message: " ", preferredStyle: .alert)
    alertController.addTextField(){ (textField : UITextField!)-> Void in
        textField.placeholder = "City Name"
    }
    let saveAction = UIAlertAction(title: "add", style: .default , handler: {alert -> Void in
        let firstTextField = alertController.textFields![0] as UITextField
        print("City name: \(firstTextField.text)")
        guard let cityname = firstTextField.text else { return }
        self.loadData(city: cityname)
    })
    let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: {(action: UIAlertAction)-> Void in
        print("cancel")
    })
    
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
    self.present(alertController , animated: true , completion: nil)
}
@objc func handleShowForecast(){
    self.navigationController?.pushViewController(ForecastViewController(), animated: true)
}

@objc func handleRefresh(){
    let city = UserDefaults.standard.string(forKey: "Selected city") ?? ""
    loadData(city : city)
}
func transparentNavigationBar(){
    self.navigationController?.navigationBar.setBackgroundImage(UIImage, for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
}
}
