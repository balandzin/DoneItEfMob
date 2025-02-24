//
//  DetailsViewController.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import UIKit
import SnapKit

final class EditViewController: UIViewController {
        
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
        view.textAlignment = .left
        view.isEditable = true
        view.returnKeyType = .done
        return view
    }()
    
    // MARK: - Properties
    var date: String!
    var editModifiedTask: ((_ task: TaskViewModel) -> ())?
    private var task: TaskViewModel
    
    // MARK: - Initialization
    init(task: TaskViewModel, date: String) {
        self.task = task
        self.date = date
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
    
    private func loadData() {
        titleTextView.text = task.title
        descriptionTextView.text = task.description
        dateLabel.text = task.date
    }
    
    private func saveTaskChanges() {
        if titleTextView.text.isEmpty && descriptionTextView.text.isEmpty {
            editModifiedTask?(task)
        } else {
            
            if task.title != titleTextView.text || task.description != descriptionTextView.text  {
                task.date = date
            }
            
            task.title = titleTextView.text
            task.description = descriptionTextView.text
            
            editModifiedTask?(task)
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

extension EditViewController: UITextViewDelegate {
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
