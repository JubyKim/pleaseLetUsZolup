//
//  ScheduleViewController.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/10/13.
//

import UIKit
import FSCalendar
import Then

class ScheduleViewController: UIViewController, FSCalendarDelegateAppearance {
    let dateFormatter = DateFormatter()
    
    let cellReuseIdentifier = "EventTableViewCell"
    
    struct event {
        var date : Date
        var events : String
    }
    
    var events = [DateFormatter().date(from: "2020-12-25")]
    var eventsList = [event(date: DateFormatter().date(from: "2021-11-15") ?? Date()
                            ,events: "가다실2가")]
    
    let calendar = FSCalendar().then{
        $0.scrollDirection = .vertical
        
        $0.appearance.todayColor = .white
        $0.appearance.titleTodayColor = .black
        $0.appearance.selectionColor = UIColor(red: 144/255, green: 202/255, blue: 249/255, alpha: 1.0)
        $0.appearance.headerTitleColor = .darkText
        $0.appearance.weekdayTextColor = .gray
    }
    
    let eventTable = UITableView()
    
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
        calendarLayout()
        setUpEvents()
        eventTableLayout()
        
        eventTable.register(UITableViewCell.self, forCellReuseIdentifier: "EventTableViewCell")
        
    }
    
    func setUpEvents() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let xmas = formatter.date(from: "2021-12-25")
        events = [xmas!]
    }
    
    func calendarLayout(){
        calendar.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(view.safeAreaInsets.top).offset(20)
            $0.bottom.equalToSuperview().offset(-340)
            
        }
    }
    
    func eventTableLayout(){
        eventTable.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(calendar.snp.bottom)
        }
    }
    
    //    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    //
    //            switch dateFormatter.string(from: date) {
    //            case dateFormatter.string(from: Date()):
    //                return "오늘"
    //            case "2020-06-22":
    //                return "출근"
    //            case "2020-06-23":
    //                return "지각"
    //            case "2020-06-24":
    //                return "결근"
    //            default:
    //                return nil
    //            }
    //        }
    
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
        guard let modalPresentView = self.storyboard?.instantiateViewController(identifier: "eventViewController") as? eventViewController else { return }
        
        // 날짜를 원하는 형식으로 저장하기 위한 방법입니다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        modalPresentView.dateLabel.text = dateFormatter.string(from: date)
        print("여기야")
        self.present(modalPresentView, animated: true, completion: nil)
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
        print("여깄슈", eventsList[indexPath.row].events)
        print(dateFormatter.string(from: eventsList[indexPath.row].date))
        return cell ?? UITableViewCell()
    }
    
    
    
}

