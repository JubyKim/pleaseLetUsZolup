//
//  ScheduleViewController.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/10/13.
//

import UIKit
import FSCalendar
import Then
import Firebase
import FirebaseFirestore
import CodableFirebase
import Foundation
import Firebase


class ScheduleViewController: UIViewController, FSCalendarDelegateAppearance {
    
    let dateFormatter = DateFormatter()
    private let ref: DatabaseReference! = Database.database().reference()
    var diseasesList: [diseases] = [diseases(disId:0, disName: "대상포진", sideEffect: "대상포진부작용")]
    let cellReuseIdentifier = "EventTableViewCell"
    
    
    struct event {
        var date : Date
        var events : String
    }
    
    struct diseases : Codable
    {
        var disId : Int
        var disName : String
        var sideEffect : String
    }
    
    
    var events = [DateFormatter().date(from: "2020-12-25")]
    var eventsList = [event(date: DateFormatter().date(from: "2021-11-15") ?? Date()
                            ,events: "가다실2가")]
    var eventsNameList = [" "]
    var dateList = ["2021-11-15"]
    let calendar = FSCalendar().then{
        $0.scrollDirection = .vertical
        
        $0.appearance.todayColor = .white
        $0.appearance.titleTodayColor = .black
        $0.appearance.selectionColor = UIColor(red: 144/255, green: 202/255, blue: 249/255, alpha: 1.0)
        $0.appearance.headerTitleColor = .darkText
        $0.appearance.weekdayTextColor = .gray
    }
    
    let eventTable = UITableView()
    
    let reservationView = UIView().then{
        $0.backgroundColor = .white
    }
    var showDateLabel = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 15.0)
    }
    var pickerData: [String] = [String]()
    
    let diseaseNamePicker = UIPickerView()
    let diseaseNameTitle = UILabel().then{
        $0.font = UIFont(name: "GillSans-SemiBold", size: 15.0)
        $0.text = "어떤 예방접종을 완료하셨나요?"
    }
    let reservationButton = UIButton().then{
//        $0.titleLabel?.text = "예약하기"
        $0.setTitle("접종완료", for: .normal)
        $0.titleLabel?.textColor = .black
        $0.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 15.0)
        $0.addTarget(self, action: #selector(reservationButtonTapped), for: .touchUpInside)
        $0.backgroundColor = .gray
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        calendar.delegate = self
        calendar.dataSource = self
        eventTable.delegate = self
        eventTable.dataSource = self
        view.addSubview(calendar)
        view.addSubview(eventTable)
        view.addSubview(reservationView)
        calendarLayout()
        setUpEvents()
        eventTableLayout()
        reservationViewLayout()
        reservationView.isHidden = true
        eventTable.register(UITableViewCell.self, forCellReuseIdentifier: "EventTableViewCell")
        //        loadDiseaseList()
        //        temp = hospitalList.filter{$0.vaccineName == vaccineList[indexPath.item].vacName}
        
        pickerData = ["대상포진", "A형간염","수막구균","사람유두종바이러스","인플루엔자","장티푸스","Td(파상풍, 디프테리아)","폐렴구균","수두","Tdap(파상풍, 디프테리아, 백일해)","신증후군출혈열"]
        self.diseaseNamePicker.delegate = self
        self.diseaseNamePicker.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func reservationButtonTapped(){
        reservationView.isHidden = true
    }
    func makeEvent(Date: Date, Event:String){
        eventsList.append(event(date: Date, events: Event))
    }
    
    func setUpEvents() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        makeEvent(Date: formatter.date(from: "2021-12-25")!, Event: "Xmas")
        events = [eventsList[0].date]
    }
    
    func calendarLayout(){
        calendar.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(view.safeAreaInsets.top).offset(40)
            $0.bottom.equalToSuperview().offset(-340)
        }
    }
    
    func eventTableLayout(){
        eventTable.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(calendar.snp.bottom)
        }
    }
    
    func reservationViewLayout(){
        reservationView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(170)
            $0.bottom.equalToSuperview().offset(-250)
            $0.center.equalToSuperview()
        }
        reservationView.addSubview(reservationButton)
        reservationView.addSubview(diseaseNameTitle)
        reservationView.addSubview(diseaseNamePicker)
        reservationView.addSubview(showDateLabel)
        
        showDateLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        diseaseNameTitle.snp.makeConstraints{
            $0.top.equalTo(showDateLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        diseaseNamePicker.snp.makeConstraints{
            $0.top.equalTo(diseaseNameTitle.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        reservationButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        if dateList.count < 2 {
            if date == dateFormatter.date(from: dateList[0])! {
                return eventsNameList[0]
            }
            else {
                return nil
                
            }
        }
        if dateList.count > 1 {
            if date == dateFormatter.date(from: dateList[0])! {
                return eventsNameList[0]
            }
            if date == dateFormatter.date(from: dateList[1])! {
                return eventsNameList[1]
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    
}

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    //이벤트 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        reservationView.isHidden = false
        showDateLabel.text = dateFormatter.string(from: date)
    }
    
    func addEvent(date: String, event: String){
        print("this is date", date)
        print("this is event", event)
        eventsNameList.append(event)
        dateList.append(date)
        print("여기서 확인하는 eventNameList", eventsNameList)
        print("여기서 확인하는 dateList", dateList)
        //        calendar.reloadData()
//        calendar.reloadInputViews()
        calendar.reloadData()
        //        eventsList.append(events(date: dateFormatter.date(from: date)!, event: event))
    }
    
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource{
    public func initCollectionView() {
        self.eventTable.dataSource = self
        self.eventTable.delegate = self
        self.eventTable.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for:indexPath) as? EventTableViewCell
        
        cell?.event.text = eventsList[indexPath.row].events
        cell?.date.text = dateFormatter.string(from: eventsList[indexPath.row].date)
        return cell ?? UITableViewCell()
    }
}


extension ScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData[row])
        print(showDateLabel.text!)
        addEvent(date: showDateLabel.text!, event: pickerData[row])
        
        //        calendar.reloa
        //        addEvent(date: showDateLabel.text!, event: )
    }
}

