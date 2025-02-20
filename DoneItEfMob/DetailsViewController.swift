//
//  DetailsViewController.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import UIKit
import SnapKit

final class DetailsViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    private var task: TaskViewModel
    
    // MARK: - GUI Variables
    private lazy var titleTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 34, weight: .bold)
        view.textColor = .lightGrayBackground
        view.textAlignment = .left
        view.isEditable = true
        view.isScrollEnabled = false
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.returnKeyType = .done // Закрытие клавиатуры по Return
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textColor = .lightGrayBackground.withAlphaComponent(0.5)
        view.textAlignment = .left
        return view
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textColor = .lightGrayBackground
        view.textAlignment = .left
        view.isEditable = true
        view.returnKeyType = .done // Закрытие клавиатуры по Return
        return view
    }()
    
    // MARK: - Initialization
    init(task: TaskViewModel) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        setupNavigationBar()
        setupGestureToDismissKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveTaskChanges()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .black
        
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        
        view.addSubview(titleTextView)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(36) // Минимальная высота
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(titleTextView)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func loadData() {
        titleTextView.text = task.title
        descriptionTextView.text = task.description
        dateLabel.text = task.date
    }
    
    private func saveTaskChanges() {
//        task.title = titleTextView.text
//        task.description = descriptionTextView.text
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "" // Убираем стандартный заголовок
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"), // Системная иконка
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
        
        let backTextButton = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
        
        backButton.tintColor = .systemYellow
        backTextButton.tintColor = .systemYellow
        
        navigationItem.leftBarButtonItems = [backButton, backTextButton]
    }
    
    private func setupGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            updateTitleTextViewHeight()
        }
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    private func updateTitleTextViewHeight() {
        let newSize = titleTextView.sizeThatFits(CGSize(width: titleTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        titleTextView.snp.updateConstraints { make in
            make.height.equalTo(newSize.height)
        }
        
        view.layoutIfNeeded() // Анимированное обновление
    }
}
