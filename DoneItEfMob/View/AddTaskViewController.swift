//
//  AddTaskViewController.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 21.02.25.
//

import UIKit

final class AddTaskViewController: UIViewController {
    
    // MARK: - GUI Variables
    private lazy var titleTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 34, weight: .bold)
        view.textColor = .lightGrayBackground
        view.textAlignment = .left
        view.isEditable = true
        view.text = "Введите данные..."
        view.isScrollEnabled = false
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.returnKeyType = .done
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
        view.text = "Введите данные..."
        view.textAlignment = .left
        view.isEditable = true
        view.returnKeyType = .done
        return view
    }()
    
    // MARK: - Properties
    var taskDidAdded: ((String, String) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        view.addSubview(titleTextView)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(36)
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
    
    private func saveTaskChanges() {
        let title = titleTextView.text
        let description = descriptionTextView.text
        
        if title != "Введите данные..." && description != "Введите данные..." {
            
            if title == "Введите данные..." {
                titleTextView.text = ""
            }
            
            if description == "Введите данные..." {
                descriptionTextView.text = ""
            }
            
            taskDidAdded?(title ?? "", description ?? "")
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = UIView(frame: .zero)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
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
    
    private func updateTitleTextViewHeight() {
        guard let width = titleTextView.superview?.bounds.width, width > 0 else { return }
        
        let newSize = titleTextView.sizeThatFits(CGSize(width: width - 32, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = max(newSize.height, 36)
        
        titleTextView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(newHeight)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Введите данные..." {
            textView.text = ""
            textView.textColor = .lightGrayBackground
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Введите данные..."
            textView.textColor = .lightGrayBackground
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите данные..."
            textView.textColor = .lightGrayBackground
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
