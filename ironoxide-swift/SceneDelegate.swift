//
//  SceneDelegate.swift
//  ironoxide-swift
//
//  Created by Ernie Turner on 4/6/20.
//  Copyright © 2020 Ernie Turner. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let device = """
{"accountId": "swifttester","segmentId": 1,"signingPrivateKey": "uScugvExVjJDawNHxYOSPrnWBpXoG5MHofHX4Z0+W1uhTWWGGBofQKdYU8sG2YmvI4ptLwc+dEif7I7bDeGFBQ==","devicePrivateKey": "XLy0M319FMUSHlIiq1yEv1mhtZuRo6Ut4xBJ9TqJ8+w="}
"""
    
//    let device = """
//{"accountId":"ernie.turner@ironcorelabs.com","segmentId":1682,"devicePrivateKey":"BqWZkt2xtTmPYUjE94ptmy0UBs/fZYj8GmkG3C7VgH4=","signingPrivateKey":"k3z6cyXARjMMHV16Viv0g/YLTBOiHVqDEcpQ5tspzSxyUbXAydj1QFEbP2D+5ZnvKKeqehF6B63W5rt3/WSFsQ=="}
//"""
    
    let iclEngineeringGroup = "ca3023e0ebc9d51c9350b8ce03f1dbc4"
    let iclITGroup = "48dc3c20d11bfd9f408c204e24a248f9"
    let iclOpsGroup = "e67fa44665b6f12881fe3572ef69d20f"
    
    let randomDocId = "3674426793de0c46aac654c2de935ad8"

    func runIronOxideStuff() {
        Util.printWithTime("START")
        let op = SDK.initializeWithJson(device).flatMap({(ironoxide) in
            return SDK.groupList(ironoxide)
                .flatMap({(foo) in
                    return SDK.groupGet(ironoxide: ironoxide, groupId: iclOpsGroup)
                })
                .flatMap({() in
                    return SDK.documentList(ironoxide)
                })
                .flatMap({() in
                    return SDK.documentGet(ironoxide: ironoxide, docId: randomDocId)
                })
                .flatMap({() in
                    return SDK.roundTripEncryptAndDecrypt(ironoxide: ironoxide, stringToEncrypt: "Encrypting in Swift!")
                })
                .flatMap({() in
                    return SDK.unmanagedEncrypt(ironoxide: ironoxide, stringToEncrypt: "Unmanaged doc!")
                })
        })
        
        Util.runIronOxideOp(op)
        Util.printWithTime("Ops complete")
        Util.printWithTime("END")
    }
    
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        runIronOxideStuff()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

