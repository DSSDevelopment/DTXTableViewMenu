//
//  EPSignaturePickerController.swift
//  DTXTableViewMenu
//
//  Created by Derek Sanchez on 10/24/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import UIKit
import Eureka

class EPSignaturePickerController:EPSignatureViewController, TypedRowControllerType, UINavigationControllerDelegate, EPSignatureDelegate {
    /// The row that pushed or presented this controller
    public var row: RowOf<UIImage>!
    //private var picker: EPSignatureViewController!
    /// A closure to be called when the controller disappears.
    public var onDismissCallback : ((UIViewController) -> ())?
    private var doneButton: UIButton?
    private var cancelButton: UIButton?
    private var clearButton: UIButton?
    
    /*init() {
        super.init(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: false)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signatureDelegate = self
        
        if let button1 = self.view.viewWithTag(8000){
            doneButton = (button1 as! UIButton)
            doneButton?.addTarget(self, action: #selector(onTouchDoneButton), for: .touchUpInside)
        }
        if let button2 = self.view.viewWithTag(8001){
            cancelButton = (button2 as! UIButton)
            cancelButton?.addTarget(self, action: #selector(onTouchCancelButton), for: .touchUpInside)
        }
        if let button3 = self.view.viewWithTag(8002){
            clearButton = (button3 as! UIButton)
            clearButton?.addTarget(self, action: #selector(onTouchClearButton), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func epSignature(_: EPSignatureViewController, didCancel error: NSError) {
        print("cancelled signature entry.")
        self.dismiss(animated: true, completion: nil)
        onDismissCallback?(self)
    }
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
        print("signing with completed image...")
        //(row as? ImageRow)?.imageURL //= info[UIImagePickerControllerReferenceURL] as? URL
        row.value = signatureImage//info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        onDismissCallback?(self)
    }


}
