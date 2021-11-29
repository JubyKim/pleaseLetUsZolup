//
//  HomeViewController.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/09/29.
//

import UIKit
import Then
import SnapKit
import SwiftUI
import CoreLocation
import DLRadioButton
import Firebase
import FirebaseFirestore
import CodableFirebase

class CustomDLRadioButton: DLRadioButton {
    override var intrinsicContentSize: CGSize {
        if let label = self.titleLabel {
            label.sizeToFit()
            var sz = label.bounds.size;
            sz.height += self.titleEdgeInsets.top + self.titleEdgeInsets.bottom
            sz.width += self.icon.size.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right + self.marginWidth
            return sz
        }
        return CGSize.zero
    }
}


class HomeViewController: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {
    
    private let ref: DatabaseReference! = Database.database().reference()
    
    // MARK: - extension
    func makeShadow(yourView: UIView){
        yourView.layer.shadowColor = UIColor.black.cgColor
        yourView.layer.shadowOpacity = 1
        yourView.layer.shadowOffset = .zero
        yourView.layer.shadowRadius = 10
    }
    
    // MARK:- variables
    var selectedDisId = 0
    var tempIndex = 0
    // MARK:- struct
    struct diseases : Codable
    {
        var disId : Int
        var disName : String
        var sideEffect : String
    }
    
    struct vaccineAndHospital : Codable {
        let id: Int
        let hospitalName, diseaseName, vaccineName: String
        let price: Int
        let location: String
        let latitude, longitude: Double
        let sideeffect: String
        
        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case hospitalName = "HOSPITAL_NAME"
            case diseaseName = "DISEASE_NAME"
            case vaccineName = "VACCINE_NAME"
            case price = "PRICE"
            case location = "LOCATION"
            case latitude = "LATITUDE"
            case longitude = "LONGITUDE"
            case sideeffect = "SIDEEFFECT"
        }
        
    }
    
    struct vaccine: Codable {
        let vacId, disId: Int
        let vacName: String
        let make: String
        let scope: String
        var selected: Bool
        let sideEffect: String
    }
    
    
    // MARK:- Color
    let selectedButtonColor = UIColor(red: 64/255, green: 169/255, blue: 1, alpha: 1)
    let mainSkyColor = UIColor(red: 144/255, green: 202/255, blue: 249/255, alpha: 1.0)
    
    // MARK:- List
    
    var mapMarkers : [MTMapPOIItem] = []
    var currentMarkersList : [MTMapPOIItem] = []
    var currentList : [vaccineAndHospital] = []
    var justArray = [1]
    var diseasesList: [diseases] = [diseases(disId:0, disName: "대상포진", sideEffect: "대상포진부작용")]
    var vaccineOUTList : [vaccine] = [vaccine(vacId:1 , disId: 0, vacName: "조스타박스주", make : "sk", scope: "몰라", selected: false, sideEffect: "q")]
    
    var vaccineAllList : [vaccine] = [vaccine(vacId:1 , disId: 0, vacName: "조스타박스주", make : "sk", scope: "몰라", selected: false, sideEffect: "q")]
    
    var vaccineList : [vaccine] = [vaccine(vacId:1 , disId: 0, vacName: "조스타박스주", make : "sk", scope: "몰라", selected: false, sideEffect: "q"),
                                   vaccine(vacId:2 , disId: 0, vacName: "스카이조스터주", make : "sk", scope: "몰라", selected: false, sideEffect: "q")]
    var hospitalList = [vaccineAndHospital]()
    
    // MARK:- property
    let headerView = UIView().then{
        $0.backgroundColor = UIColor(red: 144/255, green: 202/255, blue: 249/255, alpha: 1.0)
    }
    let addressButton = UIButton().then{
        $0.backgroundColor = .none
//        $0.setTitle("강남구 신사동 ⌵ ", for: .normal)
        $0.titleLabel?.textColor = .white
    }
    let diseaseTitle = UILabel().then{
        $0.text = "질병"
    }
    let vaccineTitle = UILabel().then{
        $0.text = "백신"
    }
    let vaccineCollectionview : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        return cv
    }()
    
    let myLocationButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named:"currentLocationButton"), for: .normal)
        $0.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
    }
    
    let mapView = MTMapView().then {
        $0.setMapCenter(.init(geoCoord: .init(latitude: 37.537229, longitude: 127.005515)), animated: true)
        $0.baseMapType = .standard
    }
    
    let listUpButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "listUpButtonBackground"), for: .normal)
        $0.setTitle("목록보기", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
        $0.addTarget(self, action: #selector(listBtnTapped), for: .touchUpInside)
        print($0.titleLabel?.font)
    }
    
    let listTableView = UITableView().then{
        $0.separatorStyle = .none
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        $0.backgroundColor = .yellow
        
        }
    
    // MARK:- RadioButton
    let stackViewScrollView = UIScrollView()
    let radioButtonStackVIew = UIStackView().then{
        $0.spacing = 5
    }
    
    let vaccineDetailView = UIView().then{
        $0.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
    }
    
    let vaccineDetailHospName = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 20.0)
    }
    let vaccineDetailHospAdr = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
    }
    let vaccineDetailDisName = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 14.0)
    }
    
    let vaccineDetailvacName = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 14.0)
    }
    let vaccineDetailPrice = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 14.0)
    }
    let detailCloseButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "close"), for: .normal)
        $0.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    func makeDetailView(){
        vaccineDetailView.addSubview(vaccineDetailHospName)
        vaccineDetailView.addSubview(vaccineDetailHospAdr)
        vaccineDetailView.addSubview(vaccineDetailDisName)
        vaccineDetailView.addSubview(vaccineDetailvacName)
        vaccineDetailView.addSubview(vaccineDetailPrice)
        vaccineDetailView.addSubview(detailCloseButton)
        
        vaccineDetailView.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        vaccineDetailHospName.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(10)
        }
        vaccineDetailHospAdr.snp.makeConstraints{
            $0.top.equalTo(vaccineDetailHospName.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(10)
        }
        vaccineDetailDisName.snp.makeConstraints{
            $0.top.equalTo(vaccineDetailHospAdr.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(10)
        }
        vaccineDetailvacName.snp.makeConstraints{
            $0.top.equalTo(vaccineDetailHospAdr.snp.bottom).offset(8)
            $0.leading.equalTo(vaccineDetailDisName.snp.trailing).offset(8)
        }
        vaccineDetailPrice.snp.makeConstraints{
            $0.top.equalTo(vaccineDetailvacName.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(10)
        }
        detailCloseButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
    }
    func makeButtons(){
        let disease1 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[0].disName, for: .normal)
            $0.tag = diseasesList[0].disId
            $0.titleLabel?.numberOfLines = 1
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.tag = 0
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
            
        }
        let disease2 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[1].disName, for: .normal)
            $0.tag = diseasesList[1].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.titleLabel?.numberOfLines = 1
            $0.tag = 1
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease3 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[2].disName, for: .normal)
            $0.tag = diseasesList[2].disId
            $0.titleLabel?.numberOfLines = 1
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.tag = 2
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease4 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[3].disName, for: .normal)
            $0.tag = diseasesList[3].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.titleLabel?.numberOfLines = 1
            $0.tag = 3
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease5 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[4].disName, for: .normal)
            $0.tag = diseasesList[4].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.titleLabel?.numberOfLines = 1
            $0.tag = 4
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease6 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[5].disName, for: .normal)
            $0.tag = diseasesList[5].disId
            $0.titleLabel?.numberOfLines = 1
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.titleLabel?.sizeToFit()
            $0.tag = 5
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease7 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[6].disName, for: .normal)
            $0.tag = diseasesList[6].disId
            $0.titleLabel?.numberOfLines = 1
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.tag = 6
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease8 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[7].disName, for: .normal)
            $0.tag = diseasesList[7].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.titleLabel?.numberOfLines = 1
            $0.tag = 7
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease9 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[8].disName, for: .normal)
            $0.tag = diseasesList[8].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.titleLabel?.numberOfLines = 1
            $0.tag = 8
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease10 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[9].disName, for: .normal)
            $0.tag = diseasesList[9].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.titleLabel?.numberOfLines = 1
            $0.tag = 9
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease11 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[10].disName, for: .normal)
            $0.tag = diseasesList[10].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.titleLabel?.numberOfLines = 1
            $0.tag = 10
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease12 = CustomDLRadioButton().then{
            $0.setTitle(diseasesList[11].disName, for: .normal)
            $0.tag = diseasesList[11].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.titleLabel?.numberOfLines = 1
            $0.tag = 11
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        disease1.otherButtons.append(disease2)
        disease1.otherButtons.append(disease3)
        disease1.otherButtons.append(disease4)
        disease1.otherButtons.append(disease5)
        disease1.otherButtons.append(disease6)
        disease1.otherButtons.append(disease7)
        disease1.otherButtons.append(disease8)
        disease1.otherButtons.append(disease9)
        disease1.otherButtons.append(disease10)
        disease1.otherButtons.append(disease11)
        disease1.otherButtons.append(disease12)
        
        disease1.isSelected = true
        
        radioButtonStackVIew.addArrangedSubview(disease1)
        radioButtonStackVIew.addArrangedSubview(disease2)
        radioButtonStackVIew.addArrangedSubview(disease3)
        radioButtonStackVIew.addArrangedSubview(disease4)
        radioButtonStackVIew.addArrangedSubview(disease5)
        radioButtonStackVIew.addArrangedSubview(disease6)
        radioButtonStackVIew.addArrangedSubview(disease7)
        radioButtonStackVIew.addArrangedSubview(disease8)
        radioButtonStackVIew.addArrangedSubview(disease9)
        radioButtonStackVIew.addArrangedSubview(disease10)
        radioButtonStackVIew.addArrangedSubview(disease11)
        radioButtonStackVIew.addArrangedSubview(disease12)
    }
    
    
    //MARK:- ??
    var locationManager : CLLocationManager!
    //MARK:- ??
    let db = Database.database().reference()
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.isHidden = true
        vaccineDetailView.isHidden = true
        readData()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.backgroundColor = .white
        
        view.addSubview(headerView)
        view.addSubview(mapView)
        view.addSubview(vaccineDetailView)
        view.addSubview(listTableView)
        mapView.delegate = self
        initCollectionView()
        allLayout()
        view.addSubview(listUpButton)
        listUpButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @objc func btnTouch(_ sender: UIButton){
        vaccineList = vaccineAllList.filter{$0.disId == sender.tag}
        vaccineCollectionview.reloadData()
        vaccineCollectionview.reloadInputViews()
        vaccineButtonTapped(sideEffect: diseasesList[sender.tag].sideEffect)
    }
    
    @objc func listBtnTapped() {
        listTableView.reloadInputViews()
        vaccineCollectionview.reloadData()
        vaccineCollectionview.reloadInputViews()
        listTableView.isHidden = false
        listUpButton.isHidden = true
    }
    
    @objc func closeButtonTapped(){
        vaccineDetailView.isHidden = true
        listUpButton.isHidden = false
    }
    
    @objc func myLocationButtonTapped(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let currentLocation = locationManager.location?.coordinate
        let lat = currentLocation?.latitude.magnitude ?? 37.5663
        let lng = currentLocation?.longitude.magnitude ?? 126.9779
        
        self.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: lat, longitude: lng)), animated: false)
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithoutHeading
    }
    
    func poiItem(id: Int, hospName: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.tag = id
        item.markerType = .customImage
        item.customImage = UIImage(named: "mapMarker")
        item.markerSelectedType = .customImage
        //        item.customSelectedImage = UIImage(named: "iconMapAct")
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        item.showAnimationType = .noAnimation
        return item
    }
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        vaccineDetailView.isHidden = false
        listUpButton.isHidden = true
        fetchDetailView(id: poiItem.tag)
        return false
    }
    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        listUpButton.isHidden = false
        listTableView.isHidden = true
    }
    
    
    func fetchDetailView(id: Int?){
        vaccineDetailPrice.text = String(hospitalList[id!].price)
        vaccineDetailvacName.text = hospitalList[id!].vaccineName
        vaccineDetailDisName.text = hospitalList[id!].diseaseName
        vaccineDetailHospName.text = hospitalList[id!].hospitalName
        vaccineDetailHospAdr.text = hospitalList[id!].location
        
    }
    // MARK:- DB
    
    func readData(){
        self.ref.child("vacHosp").getData { [self](error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //                        print("Got data \(snapshot.value!)")
                //                        print("ttt \(type(of: snapshot.value!))")
                
                guard let value = snapshot.value else {return}
                do {
                    let vaccineAndHospital = try FirebaseDecoder().decode([vaccineAndHospital].self, from: value)
                    self.hospitalList = vaccineAndHospital
                } catch let err {
                    print (err)
                }
            }
            else {
                print("No data available")
            }
        }
        
        self.ref.child("diseaseTable").getData { [self](error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                guard let value = snapshot.value else {return}
                do {
                    let disease = try FirebaseDecoder().decode([diseases].self, from: value)
                    self.diseasesList = disease
                    makeButtons()
                } catch let err {
                    print (err)
                }
            }
            else {
                print("No data available")
            }
        }
        
        self.ref.child("vaccineTable").getData { [self](error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                guard let value = snapshot.value else {return}
                do {
                    let vaccine = try FirebaseDecoder().decode([vaccine].self, from: value)
                    self.vaccineAllList = vaccine
                    outVaccineList(list: self.vaccineAllList)
                } catch let err {
                    print (err)
                }
            }
            else {
                print("No data available")
            }
        }
        
    }
    
    func outVaccineList(list: [vaccine]){
        vaccineOUTList = list
    }
    
    func allLayout(){
        headerViewLayout()
        mapViewLayout()
        makeDetailView()
        tableviewLayout()
    }
    
    func headerViewLayout(){
        headerView.snp.makeConstraints(){
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height / 5)
        }
        headerView.addSubview(addressButton)
        addressButton.snp.makeConstraints(){
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30) // safeAreaInset쓰는 게 좋긴한데
        }
        headerView.addSubview(diseaseTitle)
        diseaseTitle.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(8)
            $0.top.equalTo(addressButton.snp.bottom).offset(16)
        }
        headerView.addSubview(stackViewScrollView)
        stackViewScrollView.addSubview(radioButtonStackVIew)
        stackViewScrollView.snp.makeConstraints{
            $0.leading.equalTo(diseaseTitle.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.height.equalTo(30)
            $0.centerY.equalTo(diseaseTitle)
        }
        radioButtonStackVIew.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        //        radioButtonStackVIew.snp.makeConstraints{
        //            $0.top.trailing.equalToSuperview()
        //            $0.leading.equalTo(diseaseTitle.snp.trailing).offset(8)
        //        }
        
        headerView.addSubview(vaccineTitle)
        vaccineTitle.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(8)
            $0.top.equalTo(radioButtonStackVIew.snp.bottom).offset(16)
        }
        
        headerView.addSubview(vaccineCollectionview)
        vaccineCollectionview.snp.makeConstraints{
            $0.leading.equalTo(vaccineTitle.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalTo(vaccineTitle)
            $0.height.equalTo(30)
        }
    }
    func mapViewLayout(){
        mapView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        mapView.addSubview(myLocationButton)
        myLocationButton.snp.makeConstraints{
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.leading.equalTo(mapView).offset(10)
        }
    }
    
    func tableviewLayout(){
        listTableView.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(180)
            
        }
    }
    
    private func findCurrentMarker(temp: [vaccineAndHospital]) { //현재 보이는 맵에 있는 Marker들에 해당하는 것만.
        let bounds = self.mapView.mapBounds
        let southWest = bounds?.bottomLeft
        let northEast = bounds?.topRight
        currentList = temp.filter{$0.latitude > (southWest?.mapPointGeo().latitude)! &&
                                                $0.latitude < (northEast?.mapPointGeo().latitude)! &&
                                                $0.longitude > (southWest?.mapPointGeo().longitude)! &&
                                                $0.longitude < (northEast?.mapPointGeo().longitude)!}
        print("currnetList의 갯수는?", currentList.count)
        print("currentList 내용을 보자잇~", currentList)
    }
    
    
//        for i in 0 ... currentList.count-1 {
//            currentMarkersList.append(poiItem(id: currentList[i].id, hospName: currentList[i].hospitalName, latitude: currentList[i].latitude, longitude: currentList[i].longitude))
//        }
//        if mapView.poiItems.count > 0 {
//            mapView.removeAllPOIItems()
//        }
//        mapView.addPOIItems(currentMarkersList)
//        currentMarkersList = []
//    }
//
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        print("move")
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func initCollectionView() {
        self.vaccineCollectionview.delegate = self
        self.vaccineCollectionview.dataSource = self
        self.vaccineCollectionview.register(VaccineCollectionViewCell.self, forCellWithReuseIdentifier: VaccineCollectionViewCell.identifier)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        count = self.vaccineList.count
        return count
    }
    
    @objc func vaccineButtonTapped(sideEffect: String!){
        showAlert(style: .alert, text : sideEffect)
    }
    
//    func vaccineButtonTapped2(sideEffect: String!){
//        showAlert(style: .alert, text : sideEffect)
//    }
    
    func showAlert(style: UIAlertController.Style, text: String) {
            let alert = UIAlertController(title: "백신", message: text, preferredStyle: style)
            let success = UIAlertAction(title: "네", style: .default) { (action) in
                print("확인")
            }
            
            let cancel = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
            
            alert.addAction(success)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var vaccineCell: VaccineCollectionViewCell?
        vaccineCell = (collectionView.dequeueReusableCell(withReuseIdentifier: VaccineCollectionViewCell.identifier, for:indexPath) as? VaccineCollectionViewCell)
        
        vaccineCell!.setupView()
        vaccineCell?.backgroundColor = nil
        vaccineCell?.button.layer.cornerRadius = 15
        vaccineCell?.button.titleLabel?.text = vaccineList[indexPath.row].vacName
        vaccineCell?.button.setTitle(vaccineList[indexPath.row].vacName, for: .normal)
        vaccineCell?.button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
        //        vaccineCell?.button.titleLabel?.minimumScaleFactor = 0.5
        vaccineCell?.button.titleLabel?.numberOfLines = 1
        vaccineCell?.button.titleLabel?.sizeToFit()

        if vaccineList[indexPath.row].selected == true {
            vaccineCell?.backgroundColor = selectedButtonColor
            vaccineList[indexPath.row].selected = false
        }else {
            vaccineCell?.backgroundColor = .white
            vaccineCell?.button.setTitleColor(.blue, for: .normal)
        }
        
        if vaccineList[indexPath.row].selected == true {
            vaccineList[indexPath.row].selected = false
        }
        
        return vaccineCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vaccineList[indexPath.item].selected.toggle()
        
        var temp : [vaccineAndHospital] = []
        temp.removeAll()
        mapMarkers.removeAll()
        temp = hospitalList.filter{$0.vaccineName == vaccineList[indexPath.item].vacName}
        for i in 0...temp.count-1 { //
            mapMarkers.append(poiItem(id: temp[i].id, hospName: temp[i].hospitalName, latitude: temp[i].latitude, longitude: temp[i].longitude))
        }
//        vaccineButtonTapped(sideEffect: vaccineList[indexPath.row].sideEffect)
        findCurrentMarker(temp: temp)
        mapView.removeAllPOIItems()
        mapView.addPOIItems(mapMarkers)
        
        tempIndex = indexPath.item
        
        collectionView.reloadData()
        collectionView.reloadInputViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

protocol Identiifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell
        
        cell?.HospName.text = currentList[indexPath.row].hospitalName
        cell?.HospAdr.text = currentList[indexPath.row].location
        cell?.DisName.text = currentList[indexPath.row].diseaseName
        cell?.vacName.text = currentList[indexPath.row].vaccineName
        cell?.Price.text = String(currentList[indexPath.row].price)
        return cell!
    }
    
}

extension UITableViewCell: Identifiable {}
extension UICollectionViewCell: Identifiable {}
extension UIViewController: Identifiable {}
extension UICollectionReusableView: Identifiable {}
