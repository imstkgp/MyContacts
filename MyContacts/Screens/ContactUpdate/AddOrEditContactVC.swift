//
//  EditContactVC.swift
//  MyContacts
//
//  Created by mmt5885 on 09/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

class AddOrEditContactVC: UIViewController {

    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector(("inputToolbarDonePressed")))
        doneButton.tintColor = Constant.appGreenColor
        
        var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        var nextButton  = UIBarButtonItem(image: UIImage(named: "next"), style: .plain, target: self, action: Selector(("keyboardNextButton")))
        nextButton.width = 50.0
        nextButton.tintColor = Constant.appGreenColor
        
        var previousButton  = UIBarButtonItem(image: UIImage(named: "previous"), style: .plain, target: self, action: Selector(("keyboardPreviousButton")))
        previousButton.tintColor = Constant.appGreenColor
        
        toolbar.setItems([fixedSpaceButton, previousButton, fixedSpaceButton, nextButton, flexibleSpaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    @IBOutlet weak var profileInfoView: UIView! {
        didSet {
            self.profileInfoView.addGradientColor(
                withColors: [UIColor.white, Constant.appGreenColor],
                withStartPoint:  CGPoint.init(x: 0.5, y: 0),
                withEndPoint: CGPoint.init(x: 0.5, y: 1)
            )
        }
    }
    
    @IBOutlet weak var userImageView: AsyncImageView! {
        didSet {
            self.userImageView.layer.cornerRadius = 50
            self.userImageView.layer.borderColor = UIColor.white.cgColor
            self.userImageView.layer.borderWidth = 3
        }
    }

    @IBOutlet weak var userDetailTableView: UITableView! {
        didSet {
            if #available(iOS 11.0, *) {
                userDetailTableView.contentInsetAdjustmentBehavior = .never
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }
        }
    }
    
    var contactDetail:Contact?
    var viewModel: AddOrEditContactVM!
    var activeEditingField:UITextField? {
        didSet {
            self.scrollTableViewToActiveField()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup() {
        viewModel = AddOrEditContactVM()
        viewModel.delegate = self
        viewModel.setupContactData(contactDetail)
    }
    
    @IBAction func cameraTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))

        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func doneTapped() {
    }
    
    @IBAction func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.userDetailTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            self.scrollTableViewToActiveField()
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.userDetailTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc func keyboardNextButton() {
        if let activeEditingField = self.activeEditingField,
           let nextField = self.userDetailTableView.viewWithTag(activeEditingField.tag + 1) as? UITextField {
            self.activeEditingField = nextField
        }
    }
    
    @objc func keyboardPreviousButton() {
        if let activeEditingField = self.activeEditingField,
            let prevField = self.userDetailTableView.viewWithTag(activeEditingField.tag - 1) as? UITextField {
            self.activeEditingField = prevField
        }
    }
    
    @objc func inputToolbarDonePressed() {
        self.view.endEditing(true)
    }
}

extension AddOrEditContactVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.userImageView.image = image
    }
}

extension AddOrEditContactVC: EditContactDelegate {
    func updateContactDetails() {
        self.userDetailTableView.reloadData()
    }
}

extension AddOrEditContactVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contactData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactDetailCell.self), for: indexPath) as! ContactDetailCell
        let contactData = viewModel.contactData[indexPath.row]
        cell.typeLabel.text = contactData["name"]
        cell.valueField.text = contactData["value"]
        cell.valueField.placeholder = contactData["placeholder"]
        setKeyboardTypeForTextField(cell.valueField, type: contactData["name"]!)
        cell.valueField.tag = indexPath.row + 1
        cell.valueField.delegate = self
        cell.type = .edit
        return cell
    }
    
    func setKeyboardTypeForTextField(_ textField:UITextField, type:String) {
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        
        switch type {
        case "mobile":
            textField.keyboardType = .numberPad
            break
        case "email":
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .done
            break
        default:
            textField.keyboardType = .default
        }
    }
    
    func scrollTableViewToActiveField() {
        if let activeEditingField = self.activeEditingField {
            let indexPath = IndexPath.init(row: activeEditingField.tag - 1, section: 0)
            self.userDetailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            activeEditingField.becomeFirstResponder()
        }
    }
}

extension AddOrEditContactVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputAccessoryView = inputToolbar
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeEditingField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.contactData[textField.tag - 1]["value"] = textField.text ?? ""
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .numberPad {
            let maxLength = Constant.mobileNumberLength
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.userDetailTableView.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
