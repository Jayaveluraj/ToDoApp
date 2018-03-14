//
//  DetailView.swift
//  ToDoSample
//
//  Created by DHANDAPANI R on 08/03/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import UIKit
protocol DetailViewDelegate : class{
    func saveActionDelegate()
    func toolBarCancelActionDelegate()
    func toolBarDoneActionDelegate()
    func editActionDelegate()
}
class DetailView: UIView {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtTitle: UITextView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    weak var delegate : DetailViewDelegate?
     
    @IBAction func toolBarCancelAction(_ sender: Any) {
        self.delegate?.toolBarCancelActionDelegate()
    }
    @IBAction func toolBarDoneAction(_ sender: Any) {
        self.delegate?.toolBarDoneActionDelegate()
    }
    @IBAction func saveAction(_ sender: Any) {
        self.delegate?.saveActionDelegate()
    }
    @IBAction func editAction(_ sender: Any) {
        self.delegate?.editActionDelegate()
    }
    @IBAction func tapGestureAction(_ sender: Any) {
      self.txtTitle.resignFirstResponder()
        self.endEditing(true)
    }
}
