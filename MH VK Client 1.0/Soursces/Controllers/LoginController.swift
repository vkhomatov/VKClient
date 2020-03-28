//
//  LoginViewController.swift
//  MH VK Client 1.0
//
//  Created by Vit on 12/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit
import WebKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var load1Label: UILabel!
    @IBOutlet weak var load2Label: UILabel!
    @IBOutlet weak var load3Label: UILabel!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    var loginOk: Bool = false
    var pushLogin: Bool = false
    var loadCount: Int = 0
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        
        
        guard usersDataIsRight() else {
            //showEnterError()
            loginTextField.placeholder = "Enter login"
            passwordTextField.placeholder = "Enter pass"
            
            return
        }
        

        // автозаполняем поля логин и пароль и нажимаем на кнопку войти
            if self.loadCount >= 2 {
            
                self.Loading(alpha: 0.2, duration: 0.8, delay: 0.8, speed: 0.8)
            
                guard let savedUsername = self.loginTextField.text else { return }
                guard let savedPassword = self.passwordTextField.text else { return }
            
            let fillForm1 = String(format:"document.getElementsByName('email')[0].value='\(savedUsername)';")
            let fillForm2 = String(format:"document.getElementsByName('pass')[0].value='\(savedPassword)';")
            let pushButton = String(format:"document.getElementsByClassName('button')[0].click();")
            
            DispatchQueue.main.async {

                
            self.webView.evaluateJavaScript(fillForm1, completionHandler: { (result, error) in
                if error != nil {
                    print("ФОРМА ВВОДА ЛОГИНА НЕ НАЙДЕНА: \(String(describing: error))")
                } else if result != nil {
                    print("ФОРМА ВВОДА ЛОГИНА НАЙДЕНА И ЗАПОЛНЕНА: \(String(describing: result!))")}
            })
            
            
            self.webView.evaluateJavaScript(fillForm2, completionHandler: { (result, error) in
                if error != nil {
                    print("ФОРМА ВВОДА ПАРОЛЯ НЕ НАЙДЕНА: \(String(describing: error))")
                } else if result != nil {
                    print("ФОРМА ВВОДА ПАРОЛЯ НАЙДЕНА И ЗАПОЛНЕНА: \(String(describing: result!))")}
            })
            
            self.webView.evaluateJavaScript(pushButton, completionHandler: { (result, error) in
                if error != nil {
                    print("КНОПКА ВХОДА НЕ НАЙДЕНА: \(String(describing: error))")
                } else /*if result != nil */ {
                  //  print(result as Any)
                    print("КНОПКА ВХОДА НАЙДЕНА И НАЖАТА")}// \(String(describing: result))")}

            })
            
            self.pushLogin = true
                }
            
        } else {
            print("СТРАНИЦА ЕЩЕ НЕ ЗАГРУЖЕНА ИЛИ НЕТ СВЯЗИ С ИНТЕРНЕТ")
        }
        
    }
    
    func Loading(alpha : CGFloat, duration : Double, delay: Double, speed: Double) {
        
        
        UIView.animate(withDuration: duration, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.load1Label.alpha = 1
        })
        
        
        UIView.animate(withDuration: duration, delay: 0.4,  options: [.repeat, .autoreverse], animations: {
            self.load2Label.alpha = 1
        })
        
        
        UIView.animate(withDuration: duration, delay: 0.8,  options: [.repeat, .autoreverse], animations: {
            self.load3Label.alpha = 1
        })
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = "Enter your VK account"
        loginLabel.text = "Login"
        passwordLabel.text = "Password"
        loginTextField.placeholder = "Login"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        loginButton.setTitle("Log In", for: .normal)
        
        load1Label.alpha = 0.2
        load2Label.alpha = 0.2
        load3Label.alpha = 0.2
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        ScrollView.addGestureRecognizer(hideKeyboardGesture)
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7370693"), //7370693  //7246951
            URLQueryItem(name: "scope", value: "336918"), //"262150"
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        
        
        let request = URLRequest(url: components.url!)
        
        DispatchQueue.main.async {

        // удаляем куки, необходимые для автоматического входа
            self.webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { [weak self] cookie in
            cookie.forEach { self?.webView.configuration.websiteDataStore.httpCookieStore.delete($0) }
            print("КУКИ УДАЛЕНЫ")
        }
        }
        
        DispatchQueue.main.async {
            self.webView.load(request)
        }
        
    }
    
    @objc func hideKeyboard() {
        self.ScrollView?.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //  Loading(alpha: 0.2, duration: 0.8, delay: 0.8, speed: 0.8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // управляем системной клавиатурой
    @objc func keyboardWasShown(notification: Notification) {
        
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        ScrollView.contentInset = contentInsets
        ScrollView.scrollIndicatorInsets = contentInsets
        
    }
    
    @objc func keyboardWillHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        ScrollView.contentInset = contentInsets
        ScrollView.scrollIndicatorInsets = contentInsets
        
    }
    
    // функция проверки введенных в поля Login и Password данных
    func usersDataIsRight() -> Bool {
        guard let login = loginTextField.text else { return false }
        guard let password = passwordTextField.text else { return false }
        
        return login != "" && password != ""
    }
    
    // сообщаем пользователю если данные введеные в Login и Password неверны
    func showEnterError() {
        let alert = UIAlertController(title: "Error!", message: "Введены неверные пользовательские данные", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
}



extension LoginViewController: WKNavigationDelegate {
    
    // проверка на загрузку вэб-формы VK, почему-то срабатывает два раза - полная загрузка только после второго раза
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadCount += 1
        
        if loadCount >= 2 {
            // Loading(alpha: 1, duration: 0.8, delay: 0.8, speed: 0.8)
            print("Страница загружена \(webView.url!)")}
    }
    
    //Настраиваем WebView
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else { decisionHandler(.allow);
                
                if pushLogin {
                    loginOk = false
                    print("ДОСТУП С АККАУНТУ НЕ ПОЛУЧЕН")
                    showEnterError()}
                return
        }
        
        print("ДОСТУП С АККАУНТУ ПОЛУЧЕН")
        loginOk = true
        
        //Разделяем строку URL VK на составляющие, выделяем параметры входа
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        //Получаем токен VK
        guard let token = params["access_token"],
            let userIdString = params["user_id"],
            let userID = Int(userIdString) else {
                decisionHandler(.allow)
                return
        }
        
        print("ТОКЕН VK ПОЛУЧЕН: \(token)")
        
        //сохраняем токен и юзерайди VK в синглтон
        Session.shared.accessToken = token
        Session.shared.usedId = userID
        print("ТОКЕН СОХРАНЕН В СИНГЛТОНЕ: \(Session.shared.accessToken)")
        performSegue(withIdentifier: "fromLoginController", sender: self)
        decisionHandler(.cancel)
    }
    
}
