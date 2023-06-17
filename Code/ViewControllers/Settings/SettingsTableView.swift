//
//  SettingsTableView.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 11.06.2023.
//

import UIKit

class SettingsTableView: UITableView {
    weak var actionDelegate: SettingsViewControllerDelegate?
    
    weak var model: SettingsModel? {
        didSet {
            reloadData()
        }
    }
    
    init(frame: CGRect, model: SettingsModel?) {
        super.init(frame: frame, style: .plain)
        dataSource = self
        delegate = self
        self.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model else { return UITableViewCell() }
        
        let cell = UITableViewCell()
        cell.backgroundColor = .spTableBackground
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0, weight:UIFont.Weight.medium)
        
        if indexPath.row == model.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        if indexPath.row == model.count - 1 {
            cell.textLabel?.text = model.action
            cell.textLabel?.textColor = UIColor.spRose
            cell.accessoryView = nil
        } else {
            cell.textLabel?.text = model.listOfProjects[indexPath.row].projectName
            cell.textLabel?.textColor = .spLabelPrimary
            
            let settingButton = UIButton(type: .custom)
            settingButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            settingButton.addTarget(self, action: #selector(accessoryButtonTapped(sender:)), for: .touchUpInside)
            settingButton.setImage(UIImage(named: "settings.png"), for: .normal)
            settingButton.contentMode = .scaleAspectFit
            settingButton.tag = indexPath.row
            cell.accessoryView = settingButton as UIView
        }
        
        return cell
    }
    
    @objc func accessoryButtonTapped(sender : UIButton) {
        guard let model = model else { return }
        
        let item = model.listOfProjects[sender.tag]
        actionDelegate?.settings(project: item)
    }
}

extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = model else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == model.count - 1 {
            actionDelegate?.addProject()
        } else {
            let item = model.listOfProjects[indexPath.row]
            actionDelegate?.choose(project: item)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46.0
    }
}
