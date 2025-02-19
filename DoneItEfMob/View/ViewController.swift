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
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView?.alpha = 0
        }) { _ in
            self.overlayView?.removeFromSuperview()
            self.overlayView = nil
        }
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
        
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let window = view.window else { return }

        // Получаем frame ячейки относительно экрана
        let cellFrame = tableView.convert(cell.frame, to: window)
        selectedCellFrame = cellFrame

        // Если затемнение уже есть, удаляем его
        overlayView?.removeFromSuperview()

        // Создаем затемняющий фон
        let overlay = UIView(frame: window.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        overlay.alpha = 0
        overlayView = overlay
        window.addSubview(overlay)

        // Создаем "вырез" в затемнении
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: overlay.bounds)
        let cutoutPath = UIBezierPath(roundedRect: cellFrame, cornerRadius: 12) // Скругление, если нужно
        path.append(cutoutPath)
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        overlay.layer.mask = maskLayer

        // Анимация появления затемнения
        UIView.animate(withDuration: 0.3) {
            overlay.alpha = 1
        }

        // Добавляем тап для скрытия
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOverlay))
        overlay.addGestureRecognizer(tapGesture)
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Голосовой ввод активирован")
        // TODO: - вызов AVSpeechRecognizer
    }
}

