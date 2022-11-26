//
//  UIViewController+Extension.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/08.
//

import UIKit
import Toast

extension UIViewController {
    
    enum TransitionStyle {
        case present
        case presentModally
        case presentOver
        case presentNavigation
        case presentNavigationModally
        case push
        case pop
        case dismiss
    }
    
    func noHandlerAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func handlerAlert(title: String, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

    func transition<T: UIViewController> (_ viewController: T, transitionStyle: TransitionStyle) {
        switch transitionStyle {
        case .present:
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        case .presentModally:
            self.present(viewController, animated: true)
        case .presentOver:
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true)
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        case .presentNavigationModally:
            let navi = UINavigationController(rootViewController: viewController)
            self.present(navi, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .dismiss:
            self.dismiss(animated: true)
        }
    }
    
    func changeNextButtonColor(button: UIButton, status: ButtonStatus) {
        switch status {
        case .enable:
            button.configuration?.baseForegroundColor = .white
            button.configuration?.baseBackgroundColor = .brandGreen
        case .disable:
            button.configuration?.baseForegroundColor = .grayThree
            button.configuration?.baseBackgroundColor = .graySix
        }
    }
    
    func changeSelectedButtonColor(button: UIButton, status: ButtonStatus) {
        switch status {
        case .enable:
            button.configuration?.baseForegroundColor = .white
            button.configuration?.baseBackgroundColor = .brandGreen
            button.layer.borderWidth = 0
        case .disable:
            button.configuration?.baseForegroundColor = .black
            button.configuration?.baseBackgroundColor = .clear
            button.layer.borderWidth = 1
        }
    }
    
    func presentToast(view: UIView, message: String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .darkGray
        view.makeToast(message, duration: 0.8, position: .top, style: style)
    }
    
    func presentHandlerToast(view: UIView, message: String, completion: @escaping (() -> Void)) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .darkGray
        view.makeToast(message, duration: 0.8, style: style) { _ in
            completion()
        }
    }
    
    func changeRootViewController<T: UIViewController>(viewcontroller: T, isTabBar: Bool) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
        
        if isTabBar {
            let vc = T()
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        } else {
            let nav = UINavigationController(rootViewController: T())
            sceneDelegate?.window?.rootViewController = nav
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
}
