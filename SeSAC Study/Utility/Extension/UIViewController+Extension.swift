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
    
    func changeButtonColor(button: UIButton, status: ButtonStatus) {
        switch status {
        case .enable:
            button.configuration?.baseForegroundColor = .white
            button.configuration?.baseBackgroundColor = .brandGreen
        case .disable:
            button.configuration?.baseForegroundColor = .grayThree
            button.configuration?.baseBackgroundColor = .graySix
        }
    }
    
    func presentToast(view: UIView, message: String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .darkGray
        view.makeToast(message, duration: 1, position: .top, style: style)
    }
}
