//
//  VoiceOverMethodChannel.swift
//  Runner
//
//  Created by Tuna on 8/3/21.
//

import Foundation
import Intents

class VoiceOverMethodChannel {
    static let shared = VoiceOverMethodChannel()
    private var channel: FlutterMethodChannel?
    
    private init() {}
    
    func register(with registrar: FlutterPluginRegistrar)  {
        channel = FlutterMethodChannel(name: "SKG.univoice.dev/talkback", binaryMessenger: registrar.messenger())
        channel?.setMethodCallHandler(handler)
    }
    
    func handler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method.elementsEqual("checkTalkBack")) {
            result(UIAccessibility.isVoiceOverRunning)
        } else if (call.method.elementsEqual("requestSiriPermission")) {
            requestSiriPermission(result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    func requestSiriPermission(_ result: @escaping FlutterResult) {
        INPreferences.requestSiriAuthorization { permissionStatus in
            if (permissionStatus == .authorized) {
                result(true)
            } else {
                result(false)
            }
        }
    }
}
