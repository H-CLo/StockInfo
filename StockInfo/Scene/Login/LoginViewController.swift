//
//  LoginViewController.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController<BaseViewModel> {
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login_background"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let accountTextField: LoginInputTextView = {
        let view = LoginInputTextView()
        view.setType(.account)
        return view
    }()

    let passwordTextField: LoginInputTextView = {
        let view = LoginInputTextView()
        view.setType(.password)
        return view
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()

    let forgetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizeTool.string("忘記密碼"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()

    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizeTool.string("註冊"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()

    let guestLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizeTool.string("訪客登入"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()

    let savePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizeTool.string("訪客登入"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()

    let savePasswordSwitch: UISwitch = {
        let uiSwitch = UISwitch()

        return uiSwitch
    }()

    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizeTool.string("登入"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(SColor.textColor3, for: .disabled)
        button.setTitleColor(SColor.textColor2, for: .normal)
        button.setBackgroundColor(color: SColor.disableColor, forState: .disabled)
        button.setBackgroundColor(color: SColor.yellowColor, forState: .normal)
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
}

// MARK: - UI

extension LoginViewController {
    func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(accountTextField)
        view.addSubview(passwordTextField)
        view.addSubview(stackView)
        stackView.addArrangedSubview(forgetPasswordButton)
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(guestLoginButton)
        view.addSubview(savePasswordButton)
        view.addSubview(savePasswordSwitch)
        view.addSubview(loginButton)

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        accountTextField.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.centerY)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(accountTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(accountTextField)
            $0.height.equalTo(36)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.leading.equalTo(accountTextField)
            $0.height.equalTo(24)
        }

        savePasswordSwitch.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(18)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        savePasswordSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

        savePasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.trailing.equalTo(savePasswordSwitch.snp.leading).offset(-6)
            $0.height.equalTo(24)
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(accountTextField)
            $0.height.equalTo(40)
        }
        loginButton.layer.cornerRadius = 8
    }
}
