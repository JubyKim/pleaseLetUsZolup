//
//  ViewController.swift
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


class ViewController: UIViewController, MTMapViewDelegate {
    // MARK:- variables
    var selectedDisId = 0
    
    // MARK:- struct
    struct diseases {
        var disId : Int
        var disName : String
    }
    
    struct vaccine {
        var vacId : Int
        var disId : Int
        var vacName : String
        var make : String
        var scope : String
    }

    // MARK:- List
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
    
    var vaccineAllList : [vaccine] = [vaccine(vacId:1 , disId: 0, vacName: "조스타박스주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:2 , disId: 0, vacName: "스카이조스터주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:3 , disId: 1, vacName: "로타릭스프리필드", make : "sk", scope: "몰라"),
                                   vaccine(vacId:4 , disId: 1, vacName: "로타텍액", make : "sk", scope: "몰라"),
                                   vaccine(vacId:5 , disId: 2, vacName: "아박심160U성인용주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:6 , disId: 2, vacName: "하브릭스주 1ml", make : "sk", scope: "몰라"),
                                   vaccine(vacId:7 , disId: 2, vacName: "박타프리필드 시린지 0.5ml", make : "sk", scope: "몰라"),
                                   vaccine(vacId:8 , disId: 2, vacName: "박타주 0.5ml", make : "sk", scope: "몰라"),
                                   vaccine(vacId:9 , disId: 2, vacName: "박타프리필드 시린지 1ml", make : "sk", scope: "몰라"),
                                   vaccine(vacId:10 , disId: 2, vacName: "하브릭스주 0.5ml", make : "sk", scope: "몰라"),
                                   vaccine(vacId:11 , disId: 2, vacName: "아박심80U소아용주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:12 , disId: 3, vacName: "멘비오", make : "sk", scope: "몰라"),
                                   vaccine(vacId:13 , disId: 3, vacName: "메낙트라주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:14 , disId: 4, vacName: "가다실프리필드시린지", make : "sk", scope: "몰라"),
                                   vaccine(vacId:15 , disId: 4, vacName: "서바릭스프리필드시린지", make : "sk", scope: "몰라"),
                                   vaccine(vacId:16 , disId: 4, vacName: "가다실9프리필드시린지", make : "sk", scope: "몰라"),
                                   vaccine(vacId:17 , disId: 5, vacName: "지씨플루쿼드리밸런트프리필드시린지주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:18 , disId: 5, vacName: "플루아릭스테트라프리필드시린지", make : "sk", scope: "몰라"),
                                   vaccine(vacId:19 , disId: 5, vacName: "박씨그리프테트라주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:20 , disId: 5, vacName: "보령플루Ⅴ테트라백신주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:21 , disId: 5, vacName: "스카이셀플루4가프리필드시린지", make : "sk", scope: "몰라"),
                                   vaccine(vacId:22 , disId: 5, vacName: "보령플루Ⅷ테트라백신주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:23 , disId: 5, vacName: "비알플루텍III테트라백신프리필드시린지", make : "sk", scope: "몰라"),
                                   vaccine(vacId:24 , disId: 5, vacName: "테라텍트프리필드시린지주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:25 , disId: 5, vacName: "백시플루4가주사액프리필드시린지", make : "sk", scope: "몰라"),
                                   vaccine(vacId:26 , disId: 5, vacName: "코박스인플루4가PF주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:27 , disId: 5, vacName: "코박스플루4가PF주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:28 , disId: 5, vacName: "비알플루텍I테트라백신주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:29 , disId: 6, vacName: "지로티프-주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:30 , disId: 7, vacName: "에스케이티디백신주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:31 , disId: 7, vacName: "녹십자티디백신프리필드시린지주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:32 , disId: 7, vacName: "티디퓨어주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:33 , disId: 7, vacName: "디티부스터에스에스아이주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:34 , disId: 8, vacName: "프리베나13주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:35 , disId: 8, vacName: "프로디악스-23", make : "sk", scope: "몰라"),
                                   vaccine(vacId:36 , disId: 8, vacName: "프로디악스-23프리필드시린지", make : "sk", scope: "몰라"),
                                   vaccine(vacId:37 , disId: 8, vacName: "신플로릭스프리필드시린지", make : "sk", scope: "몰라"),
                                   vaccine(vacId:38 , disId: 9, vacName: "수두박스주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:39 , disId: 9, vacName: "스카이바리셀라주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:40 , disId: 9, vacName: "바리-엘백신", make : "sk", scope: "몰라"),
                                   vaccine(vacId:41 , disId: 10, vacName: "부스트릭스프리필드시린지", make : "sk", scope: "몰라"),
                                   vaccine(vacId:42 , disId: 10, vacName: "아다셀주", make : "sk", scope: "몰라"),
                                   vaccine(vacId:43 , disId: 11, vacName: "한타박스 0.5ml", make : "sk", scope: "몰라")]
    
    var vaccineList : [vaccine] = [vaccine(vacId:1 , disId: 0, vacName: "조스타박스주", make : "sk", scope: "몰라")]
    
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
    let diseaseCollectionview: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    let vaccineTitle = UILabel().then{
        $0.text = "백신"
    }
    let vaccineCollectionview : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    let mapView = MTMapView().then {
        $0.setMapCenter(.init(geoCoord: .init(latitude: 37.537229, longitude: 127.005515)), animated: true)
        $0.baseMapType = .standard
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView)
        view.addSubview(mapView)
        mapView.delegate = self
        initCollectionView()
        allLayout()
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
        headerView.addSubview(diseaseCollectionview)
        diseaseCollectionview.snp.makeConstraints{
            $0.leading.equalTo(diseaseTitle.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalTo(diseaseTitle)
            $0.height.equalTo(30)
        }
        
        headerView.addSubview(vaccineTitle)
        vaccineTitle.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(8)
            $0.top.equalTo(diseaseCollectionview.snp.bottom).offset(16)
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
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func initCollectionView() {
        self.diseaseCollectionview.delegate = self
        self.diseaseCollectionview.dataSource = self
        self.diseaseCollectionview.register(DiseaseCollectionViewCell.self, forCellWithReuseIdentifier: DiseaseCollectionViewCell.identifier)
        
        self.vaccineCollectionview.delegate = self
        self.vaccineCollectionview.dataSource = self
        self.vaccineCollectionview.register(VaccineCollectionViewCell.self, forCellWithReuseIdentifier: VaccineCollectionViewCell.identifier)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        if(collectionView == self.diseaseCollectionview) {
            count = self.diseasesList.count
        }
        else if(collectionView == self.vaccineCollectionview) {
            vaccineList = vaccineAllList.filter{$0.disId == selectedDisId}
            count = self.vaccineList.count
        }
        print("count가 몇일까??", count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var diseaseCell: DiseaseCollectionViewCell?
        var vaccineCell: VaccineCollectionViewCell?
        
        if collectionView == self.diseaseCollectionview {
            diseaseCell = collectionView.dequeueReusableCell(withReuseIdentifier: DiseaseCollectionViewCell.identifier, for:indexPath) as? DiseaseCollectionViewCell
            
//            diseaseCell?.button.setTitle(diseasesList[indexPath.row].disName, for: .normal)
            diseaseCell?.buttonLabel.text = diseasesList[indexPath.row].disName
            print(diseasesList[indexPath.row].disName)
            diseaseCell?.setupView()
            return diseaseCell!
        }
        
        else if (collectionView == self.vaccineCollectionview) {
            vaccineCell = (collectionView.dequeueReusableCell(withReuseIdentifier: VaccineCollectionViewCell.identifier, for:indexPath) as? VaccineCollectionViewCell)
//            vaccineCell?.button.setTitle(vaccineList[indexPath.row].disName, for: .normal)
            return vaccineCell!
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == diseaseCollectionview{
            selectedDisId = indexPath.item
            collectionView.reloadData()
        }
        if collectionView == diseaseCollectionview{
            collectionView.reloadData()
        }
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
