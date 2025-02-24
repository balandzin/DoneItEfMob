//
//  ActionPanel.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 19.02.25.
//

import UIKit

final class ActionPanel: UIView {
    
    // MARK: - GUI Variables
    private lazy var containerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .actionPanel
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var row1 = createRow()
    private lazy var row2 = createRow()
    private lazy var row3 = createRow()
    
    private lazy var editLabel = createLabel(title: "Редактировать", color: .darkPrimary)
    private lazy var shareLabel = createLabel(title: "Поделиться", color: .darkPrimary)
    private lazy var deleteLabel = createLabel(title: "Удалить", color: .darkRed)
    
    private lazy var editImage = createImage(imageName: "edit")
    private lazy var shareImage = createImage(imageName: "export")
    private lazy var deleteImage = createImage(imageName: "trash")
    
    private lazy var separatorView1 = createSeparator()
    private lazy var separatorView2 = createSeparator()
    
    // MARK: - Properties
    var onEdit: (() -> Void)?
    var onShare: (() -> Void)?
    var onDelete: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    @objc private func handleTapEdit() {
        onEdit?()
    }
    
    @objc private func handleTapShare() {
        onShare?()
    }
    
    @objc private func handleTapDelete() {
        onDelete?()
    }
    
    private func addTargets() {
        let tapGestureEdit = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapEdit)
        )
        let tapGestureShare = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapShare)
        )
        let tapGestureDelete = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapDelete)
        )
        
        row1.addGestureRecognizer(tapGestureEdit)
        row2.addGestureRecognizer(tapGestureShare)
        row3.addGestureRecognizer(tapGestureDelete)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(row1)
        containerView.addSubview(row2)
        containerView.addSubview(row3)
        
        row1.addSubview(editLabel)
        row1.addSubview(editImage)
        row1.addSubview(separatorView1)
        
        row2.addSubview(shareLabel)
        row2.addSubview(shareImage)
        row2.addSubview(separatorView2)
        
        row3.addSubview(deleteLabel)
        row3.addSubview(deleteImage)
        
        setupConstraints()
    }
    
    private func createRow() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return view
    }
    
    private func createLabel(title: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.text = title
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }
    
    private func createImage(imageName: String) -> UIImageView {
        let image = UIImageView(image: UIImage(named: imageName))
        return image
    }
    
    private func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.7)
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(132)
        }
        
        row1.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        editLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        editImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        separatorView1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(row1.snp.bottom)
        }
        
        row2.snp.makeConstraints { make in
            make.top.equalTo(row1.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        shareLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        shareImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        separatorView2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(row2.snp.bottom)
        }
        
        row3.snp.makeConstraints { make in
            make.top.equalTo(row2.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        deleteLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        deleteImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
    }
}
