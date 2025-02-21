//
//  ViewController.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 18.02.25.
//

import UIKit
import SnapKit

protocol TasksViewControllerProtocol: AnyObject {
    func showTasks(_ tasks: [TaskViewModel])
    func showEditTask(_ task: TaskViewModel)
    func showError(_ message: String)
}

final class TasksViewController: UIViewController, TasksViewControllerProtocol {
    
    // MARK: - GUI Variables
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.barTintColor = .clear
        searchBar.searchTextField.backgroundColor = .darkSecondary
        searchBar.tintColor = .lightGrayBackground.withAlphaComponent(0.5)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGrayBackground.withAlphaComponent(0.5),
            .font: UIFont.systemFont(ofSize: 17)
        ]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        searchBar.searchTextField.textColor = .lightGrayBackground
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.layer.masksToBounds = true
        
        if let glassIconView = searchBar.searchTextField.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .lightGrayBackground.withAlphaComponent(0.5)
        }
        
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var micImage: UIImageView = UIImageView(image: UIImage(named: "micImage"))
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "DetailsTableViewCell")
        return tableView
    }()
    
    private lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkSecondary
        return view
    }()
    
    private lazy var tasksCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGrayBackground
        label.textAlignment = .center
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .accentYellow
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var overlayView: UIView?
    private var selectedCellFrame: CGRect?
    
    private var actionPanel: ActionPanel?
    private var selectedCell: DetailsTableViewCell?
    
    // MARK: - Properties
    var presenter: TasksPresenterProtocol!
    private var taskViewModels: [TaskViewModel] = [] {
        didSet {
            tasksCountLabel.text = "Задач: \(taskViewModels.count)"
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Methods
    func showTasks(_ tasks: [TaskViewModel]) {
        self.taskViewModels = tasks
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showEditTask(_ task: TaskViewModel) {
        
    }
    
    // MARK: - Private Methods
}

// MARK: - UITableViewDataSource
extension TasksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as? DetailsTableViewCell else { return UITableViewCell() }
        cell.showElements()
        
        let taskViewModel = taskViewModels[indexPath.row]
        cell.configure(with: taskViewModel)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DetailsTableViewCell else { return }
        
        let touchLocation = tableView.panGestureRecognizer.location(in: cell)
        if cell.statusIndicatorImage.frame.contains(touchLocation) {
            print("Статус изменен!")
            cell.toggleStatus(to: &taskViewModels[indexPath.row])
        } else {
            
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first(where: { $0.isKeyWindow }) else { return }
            
            selectedCell = cell
            
            // Вычисляем координаты ячейки
            let cellFrame = tableView.convert(cell.frame, to: window)
            selectedCellFrame = cellFrame
            
            // ✅ Делаем рамку и фон у выбранной ячейки
            cell.layer.cornerRadius = 12
            cell.layer.masksToBounds = true
            cell.backgroundColor = .darkSecondary
            
            cell.hideElements()
            
            // ✅ Показываем затемнение
            showOverlay(for: cellFrame)
            
            let actionPanel = ActionPanel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 106, height: 132))
            
            actionPanel.onEdit = { [weak self] in
                guard let self else { return }
                self.hideOverlay(UITapGestureRecognizer())
                self.presenter.didSelectTask(taskViewModels[indexPath.row])
            }
            
            actionPanel.onShare = { [weak self] in
                guard let self else { return }
                print("Поделиться задачей")
                self.hideOverlay(UITapGestureRecognizer())
            }
            
            actionPanel.onDelete = { [weak self] in
                guard let self else { return }
                print("Удалить задачу")
                self.hideOverlay(UITapGestureRecognizer())
                self.presenter.deleteTask(taskViewModels[indexPath.row], from: taskViewModels)
            }
            
            self.actionPanel = actionPanel
            
            // ✅ Добавляем панель действий под ячейку
            showActionPanel(below: cellFrame, in: window)
        }
    }
}

extension TasksViewController {
    
    private func showOverlay(for cellFrame: CGRect) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first(where: { $0.isKeyWindow }) else { return }
        
        overlayView?.removeFromSuperview()
        let overlay = UIView(frame: window.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        overlay.alpha = 0
        overlayView = overlay
        window.addSubview(overlay)
        
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: overlay.bounds)
        let cutoutPath = UIBezierPath(roundedRect: cellFrame, cornerRadius: 12)
        path.append(cutoutPath)
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        overlay.layer.mask = maskLayer
        
        UIView.animate(withDuration: 0.2) { overlay.alpha = 1 }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOverlay))
        overlay.addGestureRecognizer(tapGesture)
    }
    
    private func showActionPanel(below cellFrame: CGRect, in window: UIWindow) {
        let width = view.frame.width - 106
        let x = (view.frame.width - width) / 2
        let panelHeight: CGFloat = 132
        let padding: CGFloat = 10
        
        var panelY = cellFrame.maxY + padding
        let maxY = window.frame.height - panelHeight - view.safeAreaInsets.bottom - padding
        
        if panelY > maxY {
            panelY = cellFrame.minY - panelHeight - padding
        }
        
        let panelFrame = CGRect(x: x, y: panelY, width: width, height: panelHeight)
        
        actionPanel?.frame = panelFrame
        window.addSubview(actionPanel ?? UIView())
    }
    
    @objc private func addButtonTapped() {
        presenter.didAddTask()
    }
    
    @objc private func hideOverlay(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.overlayView?.alpha = 0
        }) { [weak self] _ in
            guard let self else { return }
            
            self.overlayView?.removeFromSuperview()
            self.overlayView = nil
            
            // Сбрасываем стили выделенной ячейки
            self.selectedCell?.backgroundColor = .clear
            self.selectedCell = nil
            
            // Удаляем панель
            self.actionPanel?.removeFromSuperview()
            self.actionPanel = nil
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        searchBar.addSubview(micImage)
        view.addSubview(tableView)
        view.addSubview(bottomContainerView)
        view.addSubview(tasksCountLabel)
        view.addSubview(addButton)
        
        style()
        setupConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(36)
        }
        
        micImage.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.trailing.equalTo(searchBar).inset(16)
            make.width.equalTo(17)
            make.height.equalTo(22)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(bottomContainerView.snp.top)
        }
        
        bottomContainerView.snp.makeConstraints { make in
            make.height.equalTo(83)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    
        tasksCountLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(addButton)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(bottomContainerView).inset(16)
            make.width.height.equalTo(28)
        }
    }
    
    private func style() {
        view.backgroundColor = .darkPrimary
        title = "Задачи"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        //appearance.titleTextAttributes = [.foregroundColor: UIColor.lightGrayBackground]
        appearance.backgroundColor = .clear
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.lightGrayBackground]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        //navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}

// MARK: - UISearchBarDelegate
extension TasksViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Голосовой ввод активирован")
        // TODO: - вызов AVSpeechRecognizer
    }
}

