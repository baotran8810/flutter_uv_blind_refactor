//
//  DeeplinkMethodChannel.swift
//  Runner
//
//  Created by Tuna on 7/26/21.
//

import Foundation

class DeeplinkMethodChannel {
    static let shared = DeeplinkMethodChannel()
    private var channel: FlutterMethodChannel?
    
    private init() {}
    
    func register(with registrar: FlutterPluginRegistrar)  {
        channel = FlutterMethodChannel(name: "uv_deeplink", binaryMessenger: registrar.messenger())
        channel?.setMethodCallHandler(handler)
    }
    
    func handler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
    
    func openLink(url: URL?) {
        guard let urlString: String = url?.absoluteString else {
            return
        }

        channel?.invokeMethod("open_link", arguments: urlString)
    }
}
