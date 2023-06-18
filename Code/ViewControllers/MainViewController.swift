//
//  MainViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 08.04.2023.
//

import UIKit
import StorySDK
import SnapKit
import Combine

final class TitleNavView: UIView {
    var title: String? {
        didSet {
            titleLabel.text = title
            setNeedsLayout()
        }
    }
    
    private var titleLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 330, height: 40)))
        lbl.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.medium)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private var arrowImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "arrow-bottom.png"))
        
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addMultipleSubviews(with: [titleLabel,
                                   arrowImageView,])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let str: NSString = NSString(string: title ?? "")
        let sz = str.boundingRect(with: CGSize(width: 330, height: 40), options: .usesLineFragmentOrigin, attributes: [.font: titleLabel.font ?? UIFont.systemFont(ofSize: 17.0)], context: nil)

        titleLabel.snp.remakeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalTo(ceil(sz.width + 1))
            $0.height.equalToSuperview()
        }
        
        arrowImageView.snp.remakeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MainViewController: UIViewController, SRStoryWidgetDelegate {
    func onWidgetMethodCall(_ selectorName: String?) {
        
    }
    
    weak var model: SettingsModel?
    
    var storiesModel: StoriesPlayerModel?
    let widget = SRStoryWidget()
    
    weak var coordinator: AppCoordinatorProtocol?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var titleView = TitleNavView(frame: CGRect(origin: .zero, size: CGSize(width: 330, height: 40)))
    
    init(model: SettingsModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.model = model
        self.model?.delegate = self
        
        self.model?.$selected
            .sink { [weak self] in self?.didSelect(project: $0) }
            .store(in: &cancellables)
        
        if let apiKey = model.selected?.apiKey {
            storiesModel = StoriesPlayerModel(apiKey: apiKey)
        }
        
        storiesModel?.delegate = self
        titleView.addTapTouch(self, action: #selector(onTitleTap))
        navigationItem.titleView = titleView
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onWidgetErrorReceived(_ error: Error, widget: SRStoryWidget) {
        print(error)
    }
    
    func onWidgetGroupPresent(index: Int, groups: [SRStoryGroup], widget: SRStoryWidget) {
        guard groups.count > index else { return }
        let group = groups[index]
        
        coordinator?.openStories(group: group, in: self, delegate: self, animated: true)
    }
    
    func onWidgetGroupsLoaded(groups: [SRStoryGroup]) {
        if groups.count == 0 {
            let errorMsg = "There are no active groups"
            coordinator?.showError(errorMsg, in: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupLayout()
        widget.delegate = self
        
        storiesModel?.setup(widget: widget)
        reloadApp()
        
        navigationItem.rightBarButtonItem = .init(
            image: .init(systemName: "arrow.counterclockwise"),
            style: .plain,
            target: self,
            action: #selector(fetchData)
        )
        
        navigationItem.leftBarButtonItem = .init(
            image: .init(systemName: "circle.grid.hex.fill"),
            style: .plain,
            target: self,
            action: #selector(onSettingsTap)
        )
    }
    
    @objc func fetchData() {
        storiesModel?.fetchData()
    }
    
    @objc func onSettingsTap() {
        coordinator?.openSettings(model: storiesModel, in: self)
    }
    
    @objc func onTitleTap() {
        model?.delegate = self
        onSettingsTap()
    }
    
    @objc func reloadApp() {
        storiesModel?.reloadApp()
    }
    
    private func setupLayout() {
        view.addMultipleSubviews(with: [widget])
        
        widget.snp.remakeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MainViewController: StoriesPlayerModelDelegate {
    func apiKeyDidChanged() {
        storiesModel?.setup(widget: widget)
        reloadApp()
    }
}

extension MainViewController: SettingsModelDelegate {
    func didChange() {
    }
    
    func didSelect(project: ProjectSettingsModel?) {
        guard let project = project else { return }
        
        titleView.title = project.projectName
        storiesModel?.apiKey = project.apiKey
    }
}
