//
//  TodoListViewController.swift
//  ToDoSample
//
//  Created by DHANDAPANI R on 08/03/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import UIKit
import Firebase
class TodoListViewController: UITableViewController {

    @IBOutlet var tableTodo: ToDoListView!
    
    var items = [Item]()
    var ref : DatabaseReference!
    private var databaseHandle : DatabaseHandle!
    var filteredDates = [String]()
    var dict  = Dictionary<String, [Item]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.registerTableCell()
        self.fireBaseAuthenticate()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.startObsorvingDatabase()
    }
    func fireBaseAuthenticate(){
      FireBaseManager.authenticate { (isSuccess) in
            if !isSuccess{
                let alert : UIAlertController = UIAlertController(title: "Warning!!!", message: "Authentication Error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func registerTableCell(){
        self.tableTodo.register(UINib(nibName:"CustomTableCell", bundle: nil), forCellReuseIdentifier: "CustomCellIdentifier")
        self.tableTodo.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.tableTodo.rowHeight = UITableViewAutomaticDimension;
        self.tableTodo.estimatedRowHeight = 80.0;
        let nib = UINib(nibName: "CustomTableHeader", bundle: nil)
        self.tableTodo.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        self.tableTodo.autoresizingMask = UIViewAutoresizing.flexibleHeight;
    }
    //Mark : TABLE VIEW DELEGATES AND DATASOURCES
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dict.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let str : String = self.filteredDates[section]
        let arr : Array = self.dict[str]!
        return arr.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomTableCell = tableView.dequeueReusableCell(withIdentifier: "CustomCellIdentifier", for: indexPath) as! CustomTableCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let str = self.filteredDates[indexPath.section]
        let arr : Array = self.dict[str]!
        
        let item = arr[indexPath.row]
        cell.lblTitle.text = item.title
        cell.lblDate.text = item.date

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc:DetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewcontroller") as! DetailViewController
        let str = self.filteredDates[indexPath.section]
        let arr : Array = self.dict[str]!
        let item = arr[indexPath.row]
        vc.setUpView(selectedItem: item)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let str = self.filteredDates[indexPath.section]
            let arr : Array = self.dict[str]!
            let item = arr[indexPath.row]

            item.ref?.removeValue()
        } else if editingStyle == .insert {
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let str : String = self.filteredDates[section]
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let header = cell as! CustomHeader
        header.lblTitle.text = str
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44;
    }
    //MARK :  OBSERVER TO RECEIVE DB CHANGES
    func startObsorvingDatabase()
    {
        databaseHandle = ref.child("items").observe(.value, with: { (snapshot) in
            var newItems = [Item]()
            for itemSnapShot in snapshot.children
            {
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                newItems.append(item)
            }
            self.items = newItems
            self.parseData()
            
            self.tableView.reloadData()
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK : HELPER METHODS
    func parseData(){
        var filterdArray = [Date]()
        for  str  in self.items.map({$0.date!})
        {
            let formator : DateFormatter = DateFormatter()
            formator.dateFormat = "yyyy-MM-dd"
            let date : Date = formator.date(from: str)!
            if filterdArray.contains(date) == false
            {
                filterdArray.append(date)
                 let tempArray = self.items.filter({$0.date == str})
                self.dict[formator.string(from: date)] = tempArray;
            }
        }
        
        for  date in filterdArray.sorted()
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let myString = formatter.string(from:date)
            self.filteredDates.insert(myString, at: 0)
        }
    }


}

