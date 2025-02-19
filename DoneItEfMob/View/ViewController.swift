//
//  ViewController.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 18.02.25.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
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
        
        return searchBar
    }()
    
    private lazy var micImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "micImage"))
        return image
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "DetailsTableViewCell")
        return tableView
    }()
    
    private var overlayView: UIView?
    private var selectedCellFrame: CGRect?
    
    private var actionPanel1: UIView?
    private var actionPanel: ActionPanel?
    private var selectedCell: DetailsTableViewCell?
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Methods
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(searchBar)
        searchBar.addSubview(micImage)
        view.addSubview(tableView)
        
        style()
        setupConstraints()
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
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func hideOverlay() {
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

    
    @objc private func editTask() {
        print("Редактирование задачи")
    }

    @objc private func shareTask() {
        print("Поделиться задачей")
    }

    @objc private func deleteTask() {
        print("Удаление задачи")
    }
    
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
    
    private func showActionPanel1(below cellFrame: CGRect, in window: UIWindow) {
        let panelY = cellFrame.maxY + 10 // 10 pt ниже ячейки
        let x = (view.frame.width - 254) / 2
        let panelFrame = CGRect(x: x, y: panelY, width: 254, height: 132)

        let panel = UIView(frame: panelFrame)
        panel.backgroundColor = UIColor.gray
        panel.layer.cornerRadius = 12
        panel.layer.masksToBounds = true

        // Создаём кнопки
        let editButton = createActionButton(title: "Редактировать", image: "pencil", action: #selector(editTask))
        let shareButton = createActionButton(title: "Поделиться", image: "square.and.arrow.up", action: #selector(shareTask))
        let deleteButton = createActionButton(title: "Удалить", image: "trash", action: #selector(deleteTask))
        deleteButton.tintColor = .darkRed

        // Stack для кнопок
        let stack = UIStackView(arrangedSubviews: [editButton, shareButton, deleteButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.frame = panel.bounds.insetBy(dx: 10, dy: 5)

        panel.addSubview(stack)
        window.addSubview(panel)
        actionPanel = panel
    }
    
    private func showActionPanel(below cellFrame: CGRect, in window: UIWindow) {
        let panelY = cellFrame.maxY + 10 // 10 pt ниже ячейки
        let x = (view.frame.width - 254) / 2
        let panelFrame = CGRect(x: x, y: panelY, width: 254, height: 132)

        let panel = UIView(frame: panelFrame)
        panel.backgroundColor = UIColor.gray
        panel.layer.cornerRadius = 12
        panel.layer.masksToBounds = true

        // Создаём кнопки
        let editButton = createActionButton(title: "Редактировать", image: "pencil", action: #selector(editTask))
        let shareButton = createActionButton(title: "Поделиться", image: "square.and.arrow.up", action: #selector(shareTask))
        let deleteButton = createActionButton(title: "Удалить", image: "trash", action: #selector(deleteTask))
        deleteButton.tintColor = .darkRed

        // Stack для кнопок
        let stack = UIStackView(arrangedSubviews: [editButton, shareButton, deleteButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.frame = panel.bounds.insetBy(dx: 10, dy: 5)

        panel.addSubview(stack)
        window.addSubview(panel)
        actionPanel = panel
    }
    
    private func createActionButton(title: String, image: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: image), for: .normal)
        button.tintColor = .darkPrimary
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.contentHorizontalAlignment = .leading // Иконка справа
        return button
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as? DetailsTableViewCell else { return UITableViewCell() }
        cell.showElements()
        
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(#function)
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
//        guard let window = view.window else { return }
//
//        // Получаем frame ячейки относительно экрана
//        let cellFrame = tableView.convert(cell.frame, to: window)
//        selectedCellFrame = cellFrame
//
//        // Если затемнение уже есть, удаляем его
//        overlayView?.removeFromSuperview()
//
//        // Создаем затемняющий фон
//        let overlay = UIView(frame: window.bounds)
//        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        overlay.alpha = 0
//        overlayView = overlay
//        window.addSubview(overlay)
//
//        // Создаем "вырез" в затемнении
//        let maskLayer = CAShapeLayer()
//        let path = UIBezierPath(rect: overlay.bounds)
//        let cutoutPath = UIBezierPath(roundedRect: cellFrame, cornerRadius: 12) // Скругление, если нужно
//        path.append(cutoutPath)
//        maskLayer.path = path.cgPath
//        maskLayer.fillRule = .evenOdd
//        overlay.layer.mask = maskLayer
//
//        // Анимация появления затемнения
//        UIView.animate(withDuration: 0.3) {
//            overlay.alpha = 1
//        }
//
//        // Добавляем тап для скрытия
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOverlay))
//        overlay.addGestureRecognizer(tapGesture)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DetailsTableViewCell else { return }
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first(where: { $0.isKeyWindow }) else { return }

        // Очищаем предыдущее выделение
        selectedCell?.layer.borderWidth = 0
        actionPanel?.removeFromSuperview()

        selectedCell = cell

        // Вычисляем координаты ячейки
        let cellFrame = tableView.convert(cell.frame, to: window)
        selectedCellFrame = cellFrame

        // ✅ Делаем рамку и фон у выбранной ячейки
        //cell.layer.borderWidth = 2
        //cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.backgroundColor = .darkSecondary
        
        cell.hideElements()

        // ✅ Показываем затемнение
        showOverlay(for: cellFrame)

        // ✅ Добавляем панель действий под ячейку
        showActionPanel(below: cellFrame, in: window)
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Голосовой ввод активирован")
        // TODO: - вызов AVSpeechRecognizer
    }
}

