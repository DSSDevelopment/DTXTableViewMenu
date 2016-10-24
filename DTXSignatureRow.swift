//
//  DTXSignatureRow.swift
//  DTXTableViewMenu
//
//  Created by Derek Sanchez on 10/24/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import UIKit
import Eureka

open class _SignatureRow<Cell: CellType>: SelectorRow<Cell, EPSignaturePickerController>, EPSignatureDelegate where Cell: BaseCell, Cell: TypedCellType, Cell.Value == UIImage {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .presentModally(controllerProvider: ControllerProvider.callback { return EPSignaturePickerController(signatureDelegate: self, showsDate: false, showsSaveSignatureOption:false) }, onDismiss: { [weak self] vc in
            print("trying to hide VC.")
            self?.select()
            vc.dismiss(animated: true)
            })
        self.displayValueFor = nil
        
    }
    
    func displaySignatureController() {
        if let presentationMode = presentationMode, !isDisabled {
            if let controller = presentationMode.makeController(){
                controller.row = self
                //controller.sourceType = sourceType
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.present(controller, row: self, presentingController: cell.formViewController()!)
            }
            else{
                //_sourceType = sourceType
                presentationMode.present(nil, row: self, presentingController: cell.formViewController()!)
            }
        }
    }
    
    open override func customDidSelect() {
        guard !isDisabled else {
            super.customDidSelect()
            return
        }
        deselect()
        displaySignatureController()
        
    }
    
    open override func customUpdateCell() {
        super.customUpdateCell()
        cell.accessoryType = .none
        if let image = self.value {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 96, height: 44))
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
            imageView.clipsToBounds = true
            cell.accessoryView = imageView
        }
        else {
            cell.accessoryView = nil
        }
    }
    
    

}

/// A selector row where the user can sign their name
public final class SignatureRow : _SignatureRow<PushSelectorCell<UIImage>>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}
