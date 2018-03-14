//
//  ItemDetailsViewController.swift
//  ToDoSample
//
//  Created by DHANDAPANI R on 08/03/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    @IBOutlet var detailView: DetailView!
    var item : Item?
    var ref : DatabaseReference!
    var updating : Bool = false
    private var databaseHandle : DatabaseHandle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.setDelegates()
        self.detailView.txtTitle.text = self.item?.title
        self.detailView.txtDate.text = self.item?.date
    }
    override func viewWillAppear(_ animated: Bool) {
        self.detailView.datePicker.removeFromSuperview()
        self.detailView.toolbar.removeFromSuperview()
        self.enableDisableControls()
        if self.updating == false{
            self.setUpEditing()
        }
        }
    //MARK : INITIAL SETTUP
    func setUpView(selectedItem : Item) {
        self.item = selectedItem
        self.updating = true
    }
    // MARK : CONFIRM DELEGATES
    func setDelegates(){
        self.detailView.delegate = self as DetailViewDelegate
        self.detailView.txtTitle.delegate = self
        self.detailView.txtDate.delegate = self
        self.detailView.txtTitle.layer.borderColor = UIColor.lightGray.cgColor
        self.detailView.txtTitle.layer.borderWidth = 0.5
        self.detailView.txtDate.layer.borderColor = UIColor.lightGray.cgColor
        self.detailView.txtDate.layer.borderWidth = 0.5
        self.detailView.txtDate.inputView = self.detailView.datePicker
        self.detailView.txtDate.inputAccessoryView = self.detailView.toolbar
        self.detailView.txtDate.addTarget(self, action: Selector(("dateChanged:")), for: UIControlEvents.valueChanged)
    }
    
    func setUpEditing()
    {
        self.detailView.txtTitle.isUserInteractionEnabled = true
        self.detailView.txtDate.isUserInteractionEnabled = true
        self.detailView.txtTitle.becomeFirstResponder()
    }
    
    func showAlert(message : String){
        let alert : UIAlertController = UIAlertController(title: "Warning!!!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func enableDisableControls(){
        if self.updating == false{
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension DetailViewController : DetailViewDelegate{
    //MARK : HANDLE EVENTS
    func toolBarCancelActionDelegate() {
        self.detailView.txtDate.resignFirstResponder()
    }
    func toolBarDoneActionDelegate() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"//'T'HH:mm:ssZ"
        self.detailView.txtDate.text = dateFormatter1.string(from: self.detailView.datePicker.date)
        self.detailView.txtDate.resignFirstResponder()
    }
    func editActionDelegate() {
        self.setUpEditing()
    }
    func saveActionDelegate() {
        
        if let title = self.detailView.txtTitle.text, let strdate = self.detailView.txtDate.text
        {
            Auth.auth().signInAnonymously() { (user, error) in
                if error  == nil
                {
                    if self.updating{
                        if title.count > 1 && strdate.count > 1
                        {
                            let childUpdates = ["title": title, "date" : strdate] as  [String : Any]
                            self.item?.ref?.updateChildValues(childUpdates as Any as! [AnyHashable : Any])
                        }else{
                            self.showAlert(message: "Invalid Data")
                        }
                    }
                    else{
                        if title.count > 1 && strdate.count > 1{
                            let dict : Dictionary = ["title" : title, "date" : strdate] as [String : Any]
                            self.ref.child("items").childByAutoId().setValue(dict)
                        }else{
                            self.showAlert(message: "Invalid Data")
                        }
                        
                    }
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    self.showAlert(message: "Authentication Failur")
                }
            }
            
        }
    }

}

extension DetailViewController : UITextViewDelegate{
    //MARK : UITEXTVIEW DELEGATES
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textView: UITextField) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

extension DetailViewController : UITextFieldDelegate
{
    // MARK : UITEXTFIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false;
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }

}





