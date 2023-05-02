//
//  GroupPickerViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 30.04.2023.
//

import UIKit
import StorySDK

final class GroupPickerViewController: UIViewController {
    private var model: [String]?
    
    private var delayedOpenGroupId: String?
    private var modelLoaded: Bool = false
    
    var selectedRow: Int = 0
    
    init(model: [String]?) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let pickerView = UIPickerView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)))
        pickerView.delegate = self
        pickerView.dataSource = self
        view.addSubview(pickerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension GroupPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)  -> Int {
        model?.count ?? 0
    }
}

extension GroupPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        model?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}
