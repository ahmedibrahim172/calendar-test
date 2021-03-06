

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UITableViewDelegate , UITableViewDataSource {
   
    
    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var MonthLabel: UILabel!
    
    @IBOutlet weak var listEventsTable: UITableView!
    
    
    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    let DaysOfMonth = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var NumberOfEmptyBox = Int()
    
    var NextNumberOfEmptyBox = Int()
    
    var PreviousNumberOfEmptyBox = 0
    
    var Direction = 0
    
    var PositionIndex = 0
    
    var LeapYearCounter = 2
    
    var dayCounter = 0
    
    
    var lisNotes=[MyNotes]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
        today.text = "\(day) \(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 7
        }
       
        GetStartDateDayPosition()
        loadNotes()
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lisNotes.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        cell.SetCell(note: lisNotes[indexPath.row])
        return cell
    }
    
    func loadNotes() {
        let fetchRequest: NSFetchRequest<MyNotes> = MyNotes.fetchRequest()
        
        do{
            lisNotes = try context.fetch(fetchRequest)
            listEventsTable.reloadData()
            
        }catch{
        }}
//-----------(Calculates the number of "empty" boxes at the start of every month")------------------------------------------------------
    
    func GetStartDateDayPosition() {
        switch Direction{
        case 0:                                     
            NumberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter>0 {
                NumberOfEmptyBox = NumberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if NumberOfEmptyBox == 0 {
                    NumberOfEmptyBox = 7
                }
            }
            if NumberOfEmptyBox == 7 {
                NumberOfEmptyBox = 0
            }
            PositionIndex = NumberOfEmptyBox
        case 1...:
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
            
        case -1:
            PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }

//--------------------------------------------------(Next and back buttons)-------------------------------------------------------------

    @IBAction func Next(_ sender: Any) {
        switch currentMonth {
        case "December":
            Direction = 1

            month = 0
            year += 1
            
            if LeapYearCounter  < 5 {
                LeapYearCounter += 1
            }
            
            if LeapYearCounter == 4 {
                DaysInMonths[1] = 29
            }
            
            if LeapYearCounter == 5{
                LeapYearCounter = 1
                DaysInMonths[1] = 28
            }
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            today.text = "\(day) \(currentMonth) \(year)"
            Calendar.reloadData()
            listEventsTable.reloadData()
        default:
            Direction = 1
            
            GetStartDateDayPosition()
            
            month += 1

            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            today.text = "\(day) \(currentMonth) \(year)"
            Calendar.reloadData()
    //        listEventsTable.reloadData()
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        switch currentMonth {
        case "January":
            Direction = -1

            month = 11
            year -= 1
            
            if LeapYearCounter > 0{
                LeapYearCounter -= 1
            }
            if LeapYearCounter == 0{
                DaysInMonths[1] = 29
                LeapYearCounter = 4
            }else{
                DaysInMonths[1] = 28
            }
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            today.text = "\(day) \(currentMonth) \(year)"
            Calendar.reloadData()
  //          listEventsTable.reloadData()
        default:
            Direction = -1

            month -= 1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            today.text = "\(day) \(currentMonth) \(year)"
            Calendar.reloadData()
//listEventsTable.reloadData()
        }
    }
    
   
//----------------------------------(CollectionView)------------------------------------------------------------------------------------

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction{
        case 0:
            return DaysInMonths[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.DateLabel.textColor = UIColor.black
        
        cell.Circle.isHidden = true
        listEventsTable.reloadData()
        if cell.isHidden{
            cell.isHidden = false
        }
        
        switch Direction {      //the first cells that needs to be hidden (if needed) will be negative or zero so we can hide them
        case 0:
            cell.DateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1:
            cell.DateLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1:
            cell.DateLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.DateLabel.text!)! < 1{ //here we hide the negative numbers or zero
            cell.isHidden = true
        }
        
        switch indexPath.row { //weekend days color
        case 5,6,12,13,19,20,26,27,33,34:
            if Int(cell.DateLabel.text!)! > 0 {
                cell.DateLabel.textColor = UIColor.black
            }
        default:
            break
        }
     if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - NumberOfEmptyBox == day{
        cell.Circle.isHidden = false
          cell.DrawCircle()
        
//        cell.isUserInteractionEnabled = true
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //        var Scell = Calendar.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        //        Scell.Circle.isHidden = true
        var Scell=Calendar.cellForItem(at: indexPath)
        Scell?.backgroundColor=UIColor.clear
        listEventsTable.reloadData()
      //  Calendar.reloadData()
        // let lbl = cell?.subviews[1] as! UILabel
        // lbl.textColor = UIColor.blue
    }


  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       var Scell=Calendar.cellForItem(at: indexPath)
       Scell?.backgroundColor = UIColor.red
    listEventsTable.reloadData()
    //Calendar.reloadData()
//    let e = Calendar.cellForItem(at: indexPath)
//     var Scell = Calendar.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
//    Scell.Circle.isHidden = false
//    Scell.DrawCircle()
    //Scell.isUserInteractionEnabled = true
       // let lbl = cell?.subviews[1] as! UILabel
       // lbl.textColor=UIColor.white
    }
    

    
    
}

