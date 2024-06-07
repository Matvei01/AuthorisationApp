//
//  SceneDelegate.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.05.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let viewController = RegistrationViewController()
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification),
            name: .showSignIn,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification),
            name: .showProfile,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification),
            name: .showRegister,
            object: nil
        )
    }
    
    @objc func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .showSignIn:
            setRootViewController(SignInViewController())
        case .showProfile:
            setRootViewController(UINavigationController(rootViewController: ProfileViewController()))
        case .showRegister:
            setRootViewController(RegistrationViewController())
        default:
            break
        }
    }
    
    private func setRootViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
    }
}

