//
//  DetailsTableViewCell.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 19.02.25.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell {
    
    // MARK: - GUI Variables
    lazy var statusIndicatorImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "emptyCircle")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .lightGrayBackground
        label.text = "Уборка в квартире"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGrayBackground
        label.text = "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGrayBackground.withAlphaComponent(0.5)
        label.text = "09/10/24"
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrayBackground.withAlphaComponent(0.5)
        return view
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        addSubview(statusIndicatorImage)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(dateLabel)
        addSubview(separatorView)
        
        style()
        setupConstraints()
    }
    
    func updateLabels(for task: TaskViewModel) {
        titleLabel.attributedText = nil
        descriptionLabel.attributedText = nil
        
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        dateLabel.text = task.date
        
        let titleText = titleLabel.text ?? ""
        let descriptionText = descriptionLabel.text ?? ""
        
        let titleAttributedText = NSMutableAttributedString(string: titleText)
        let descriptionAttributedText = NSMutableAttributedString(string: descriptionText)
        
        if task.status {
            titleAttributedText.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: titleText.count)
            )
            titleAttributedText.addAttribute(
                .foregroundColor,
                value: UIColor.lightGrayBackground.withAlphaComponent(0.5),
                range: NSRange(location: 0, length: titleText.count)
            )
            descriptionAttributedText.addAttribute(
                .foregroundColor,
                value: UIColor.lightGrayBackground.withAlphaComponent(0.5),
                range: NSRange(location: 0, length: descriptionText.count)
            )
        } else {
            titleAttributedText.addAttribute(
                .foregroundColor,
                value: UIColor.lightGrayBackground,
                range: NSRange(location: 0, length: titleText.count)
            )
            descriptionAttributedText.addAttribute(
                .foregroundColor,
                value: UIColor.lightGrayBackground,
                range: NSRange(location: 0, length: descriptionText.count)
            )
        }
        
        titleLabel.attributedText = titleAttributedText
        descriptionLabel.attributedText = descriptionAttributedText
    }
    
    func configure(with task: TaskViewModel) {
        statusIndicatorImage.image = task.status ? UIImage(named: "checkedCircle") :
        UIImage(named: "emptyCircle")
        
        updateLabels(for: task)
    }
    
    func toggleStatus(to task: inout TaskViewModel) {
        task.status.toggle()
        configure(with: task)
    }
    
    func hideElements() {
        statusIndicatorImage.isHidden = true
        separatorView.isHidden = true
    }
    
    func showElements() {
        statusIndicatorImage.isHidden = false
        separatorView.isHidden = false
    }
    
    private func style() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        statusIndicatorImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusIndicatorImage.snp.trailing).offset(10)
            make.centerY.equalTo(statusIndicatorImage)
            make.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(32)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.equalTo(descriptionLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
