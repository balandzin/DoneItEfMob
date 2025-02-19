//
//  DetailsTableViewCell.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 19.02.25.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell {
    
    // MARK: - GUI Variables
    private lazy var statusIndicatorImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "emptyCircle")
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
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.equalTo(descriptionLabel)
            make.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

