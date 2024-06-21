//
//  LoginInputTextView.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import SnapKit
import UIKit

// Customize and reuse input text view in LoginViewController

class LoginInputTextView: UIView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    let accountImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login_account"))
        return imageView
    }()

    let pwdImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login_pwd"))
        return imageView
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = SColor.textColor2
        return textField
    }()

    lazy var eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "login_eye_close"), for: .normal)
        button.setImage(UIImage(named: "login_eye_open"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        button.addTarget(self, action: #selector(eyeButtonPressed), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(frame: .zero)
        setLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setType(_ type: LoginInputTextType) {
        switch type {
        case .account:
            pwdImageView.isHidden = true
            eyeButton.isHidden = true
            textField.attributedPlaceholder = NSAttributedString(string: LocalizeTool.string("CMoney帳號(email)"),
                                                                 attributes: [NSAttributedString.Key.foregroundColor: SColor.textColor1])
        case .password:
            accountImageView.isHidden = true
            textField.isSecureTextEntry = true
            textField.attributedPlaceholder = NSAttributedString(string: LocalizeTool.string("密碼"),
                                                                 attributes: [NSAttributedString.Key.foregroundColor: SColor.textColor1])
        }
    }

    @objc
    private func eyeButtonPressed() {
        let isSelected = eyeButton.isSelected
        eyeButton.isSelected = !isSelected
        textField.isSecureTextEntry = isSelected
    }
}

private extension LoginInputTextView {
    func setLayout() {
        backgroundColor = .white
        layer.cornerRadius = 4
    }

    func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(accountImageView)
        stackView.addArrangedSubview(pwdImageView)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(eyeButton)

        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }

        accountImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        pwdImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        eyeButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
}
