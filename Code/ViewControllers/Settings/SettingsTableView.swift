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
            model?.delegate = self
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
        cell.accessoryType = .detailButton
        
        if indexPath.row == model.count - 1 {
            cell.textLabel?.text = model.action
            cell.textLabel?.textColor = UIColor.spRose
        } else {
            cell.textLabel?.text = model.listOfProjects[indexPath.row].projectName
        }
        
        return cell
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
}

extension SettingsTableView: SettingsModelDelegate {
    func didChange() {
        reloadData()
    }
    
    func didSelect(project: ProjectSettingsModel) {
    }
}
