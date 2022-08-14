//
//  ForecastViewController.swift
//  Meteo
//
//  Created by Артем Савицкий on 14.08.2022.
//

import Foundation
import UIKit

class ForecastViewController : UIViewController , UICollectionViewDataSource , UICollectionViewDelegate {
    
    let networkManager = WeatherNetworkManager()
    var collectionView : UICollectionView!
    var forecastData : [ForecastTemperature] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Forecast"
        
        collectionView = UICollectionView(frame: .zero , collectionViewLayout: createCompositionalLayout())
        collectionView.register(ForecastCell.self,  forCellWithReuseIdentifier: ForecastCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        setupViews()
        let city = UserDefaults.standard.string(forKey: "Selected City") ?? ""
        print("City Forecast:" , city)
        networkManager.fetchNextFiveWeatherForecast(city: city) { ( forecast ) in
            self.forecastData = forecast
            print("Total Count:", forecast.count)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        forecastData = []
    }
    
    func setupViews(){
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 8).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier, for: indexPath) as! ForecastCell
        cell.configure(with : forecastData[indexPath.row])
        return cell
    }
    func createCompositionalLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionIndex , layoutEnvirenment in
            self.createFeaturedSection()
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func createFeaturedSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5 , leading: 5 , bottom: 0 , trailing:  5 )
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
        let layutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layutGroup)
        return layoutSection
    }
}
