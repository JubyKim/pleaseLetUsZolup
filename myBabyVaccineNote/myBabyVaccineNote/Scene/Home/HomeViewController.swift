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
    struct diseases {
        var disId : Int
        var disName : String
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
    
    struct vaccine {
        var vacId : Int
        var disId : Int
        var vacName : String
        var make : String
        var scope : String
        var selected : Bool
    }
    
    
    // MARK:- Color
    let selectedButtonColor = UIColor(red: 64/255, green: 169/255, blue: 1, alpha: 1)
    let mainSkyColor = UIColor(red: 144/255, green: 202/255, blue: 249/255, alpha: 1.0)
    
    // MARK:- List
    
    var mapMarkers : [MTMapPOIItem] = []
    var justArray = [1]
    var diseasesList: [diseases] = [diseases(disId:0, disName: "대상포진"),
                                    diseases(disId:1, disName: "로타바이러스"),
                                    diseases(disId:2, disName: "A형간염"),
                                    diseases(disId:3, disName: "수막구균"),
                                    diseases(disId:4, disName: "사람유두종바이러스"),
                                    diseases(disId:5, disName: "인플루엔자"),
                                    diseases(disId:6, disName: "장티푸스"),
                                    diseases(disId:7, disName: "Td(파상풍, 디프테리아)"),
                                    diseases(disId:8, disName: "폐렴구균"),
                                    diseases(disId:9, disName: "수두"),
                                    diseases(disId:10, disName: "Tdap(파상풍, 디프테리아, 백일해)"),
                                    diseases(disId:11, disName: "신증후군출혈열"),
    ]
    
    var vaccineAllList : [vaccine] = [vaccine(vacId:1 , disId: 0, vacName: "조스타박스주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:2 , disId: 0, vacName: "스카이조스터주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:3 , disId: 1, vacName: "로타릭스프리필드", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:4 , disId: 1, vacName: "로타텍액", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:5 , disId: 2, vacName: "아박심160U성인용주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:6 , disId: 2, vacName: "하브릭스주 1ml", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:7 , disId: 2, vacName: "박타프리필드 시린지 0.5ml", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:8 , disId: 2, vacName: "박타주 0.5ml", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:9 , disId: 2, vacName: "박타프리필드 시린지 1ml", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:10 , disId: 2, vacName: "하브릭스주 0.5ml", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:11 , disId: 2, vacName: "아박심80U소아용주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:12 , disId: 3, vacName: "멘비오", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:13 , disId: 3, vacName: "메낙트라주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:14 , disId: 4, vacName: "가다실프리필드시린지", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:15 , disId: 4, vacName: "서바릭스프리필드시린지", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:16 , disId: 4, vacName: "가다실9프리필드시린지", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:17 , disId: 5, vacName: "지씨플루쿼드리밸런트프리필드시린지주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:18 , disId: 5, vacName: "플루아릭스테트라프리필드시린지", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:19 , disId: 5, vacName: "박씨그리프테트라주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:20 , disId: 5, vacName: "보령플루Ⅴ테트라백신주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:21 , disId: 5, vacName: "스카이셀플루4가프리필드시린지", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:22 , disId: 5, vacName: "보령플루Ⅷ테트라백신주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:23 , disId: 5, vacName: "비알플루텍III테트라백신프리필드시린지", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:24 , disId: 5, vacName: "테라텍트프리필드시린지주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:25 , disId: 5, vacName: "백시플루4가주사액프리필드시린지", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:26 , disId: 5, vacName: "코박스인플루4가PF주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:27 , disId: 5, vacName: "코박스플루4가PF주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:28 , disId: 5, vacName: "비알플루텍I테트라백신주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:29 , disId: 6, vacName: "지로티프-주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:30 , disId: 7, vacName: "에스케이티디백신주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:31 , disId: 7, vacName: "녹십자티디백신프리필드시린지주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:32 , disId: 7, vacName: "티디퓨어주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:33 , disId: 7, vacName: "디티부스터에스에스아이주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:34 , disId: 8, vacName: "프리베나13주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:35 , disId: 8, vacName: "프로디악스-23", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:36 , disId: 8, vacName: "프로디악스-23프리필드시린지", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:37 , disId: 8, vacName: "신플로릭스프리필드시린지", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:38 , disId: 9, vacName: "수두박스주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:39 , disId: 9, vacName: "스카이바리셀라주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:40 , disId: 9, vacName: "바리-엘백신", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:41 , disId: 10, vacName: "부스트릭스프리필드시린지", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:42 , disId: 10, vacName: "아다셀주", make : "sk", scope: "몰라", selected: false),
                                      vaccine(vacId:43 , disId: 11, vacName: "한타박스 0.5ml", make : "sk", scope: "몰라", selected: false)]
    
    var vaccineList : [vaccine] = [vaccine(vacId:1 , disId: 0, vacName: "조스타박스주", make : "sk", scope: "몰라", selected: false),
                                   vaccine(vacId:2 , disId: 0, vacName: "스카이조스터주", make : "sk", scope: "몰라", selected: false)]
    var hospitalList = [vaccineAndHospital]()
    
    // MARK:- property
    let headerView = UIView().then{
        $0.backgroundColor = UIColor(red: 144/255, green: 202/255, blue: 249/255, alpha: 1.0)
    }
    let addressButton = UIButton().then{
        $0.backgroundColor = .none
        $0.setTitle("강남구 신사동 ⌵ ", for: .normal)
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
        print($0.titleLabel?.font)
    }
    
    // MARK:- RadioButton
    let stackViewScrollView = UIScrollView()
    let radioButtonStackVIew = UIStackView().then{
        $0.spacing = 5
    }
    func makeButtons(){
        let disease1 = DLRadioButton().then{
            $0.setTitle(diseasesList[0].disName, for: .normal)
            $0.tag = diseasesList[0].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease2 = DLRadioButton().then{
            $0.setTitle(diseasesList[1].disName, for: .normal)
            $0.tag = diseasesList[1].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease3 = DLRadioButton().then{
            $0.setTitle(diseasesList[2].disName, for: .normal)
            $0.tag = diseasesList[2].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease4 = DLRadioButton().then{
            $0.setTitle(diseasesList[3].disName, for: .normal)
            $0.tag = diseasesList[3].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease5 = DLRadioButton().then{
            $0.setTitle(diseasesList[4].disName, for: .normal)
            $0.tag = diseasesList[4].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease6 = DLRadioButton().then{
            $0.setTitle(diseasesList[5].disName, for: .normal)
            $0.tag = diseasesList[5].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease7 = DLRadioButton().then{
            $0.setTitle(diseasesList[6].disName, for: .normal)
            $0.tag = diseasesList[6].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease8 = DLRadioButton().then{
            $0.setTitle(diseasesList[7].disName, for: .normal)
            $0.tag = diseasesList[7].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease9 = DLRadioButton().then{
            $0.setTitle(diseasesList[8].disName, for: .normal)
            $0.tag = diseasesList[8].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease10 = DLRadioButton().then{
            $0.setTitle(diseasesList[9].disName, for: .normal)
            $0.tag = diseasesList[9].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease11 = DLRadioButton().then{
            $0.setTitle(diseasesList[10].disName, for: .normal)
            $0.tag = diseasesList[10].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
            $0.addTarget(self, action: #selector(self.btnTouch(_:)), for: .touchUpInside)
        }
        let disease12 = DLRadioButton().then{
            $0.setTitle(diseasesList[11].disName, for: .normal)
            $0.tag = diseasesList[11].disId
            $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 16.0)
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
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(mapView)
        makeButtons()
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
        
        readData()
        
    }
    @objc func btnTouch(_ sender: UIButton){
        vaccineList = vaccineAllList.filter{$0.disId == sender.tag}
        selectedDisId = sender.tag
        vaccineList = vaccineAllList.filter{$0.disId == selectedDisId}
        print("selectedDisId는", selectedDisId)
        vaccineCollectionview.reloadData()
        vaccineCollectionview.reloadInputViews()
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
    
    // MARK:- DB
    
    func readData(){
            self.ref.getData { [self](error, snapshot) in
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
                            print("this is hospitalList")
                            print(self.hospitalList[10])
//                            print("dddd")
//                            print(hospitalList.filter{$0.vaccineName == "멘비오"}.map{$0.latitude})
                        } catch let err {
                            print (err)
                        }
                    }
                    else {
                        print("No data available")
                    }
        }
    }
    
    
    func allLayout(){
        headerViewLayout()
        mapViewLayout()
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
        }else {
            vaccineCell?.backgroundColor = .white
            vaccineCell?.button.setTitleColor(.blue, for: .normal)
        }
        return vaccineCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vaccineList[indexPath.item].selected.toggle()

        var temp : [vaccineAndHospital] = []
        temp.removeAll()
        mapMarkers.removeAll()
        temp = hospitalList.filter{$0.vaccineName == vaccineList[indexPath.item].vacName}
        for i in 0...temp.count-1 {
            mapMarkers.append(poiItem(id: temp[i].id, hospName: temp[i].hospitalName, latitude: temp[i].latitude, longitude: temp[i].longitude))
        }
        mapView.removeAllPOIItems()
        mapView.addPOIItems(mapMarkers)
        
        collectionView.reloadData()
        collectionView.reloadInputViews()
        tempIndex = indexPath.item
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
extension UITableViewCell: Identifiable {}
extension UICollectionViewCell: Identifiable {}
extension UIViewController: Identifiable {}
extension UICollectionReusableView: Identifiable {}
