import UIKit
import Flutter
import Firebase
import Intents

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        donateInteraction()
        GeneratedPluginRegistrant.register(with: self)

        let fbConfigFileName = Bundle.main.object(forInfoDictionaryKey: "FirebaseConfigFileName") as! String
        let filePath = Bundle.main.path(forResource: fbConfigFileName, ofType: "plist")
        if let fileopts = FirebaseOptions(contentsOfFile: filePath!) {
            FirebaseApp.configure(options: fileopts)
        } else {
            print("Couldn't load Firebase config file")
        }

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        DeeplinkMethodChannel.shared.register(with: controller.registrar(forPlugin: "uv_deeplink")!)
        DataMigrateChannel.shared.register(with: controller.registrar(forPlugin: "uv_migration")!)
        VoiceOverMethodChannel.shared.register(with: controller.registrar(forPlugin: "SKG.univoice.dev/talkback")!)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?
    ) -> Void) -> Bool {
        if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
            let url = userActivity.webpageURL
            handleDeeplink(url: url)
        }
        
        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        handleDeeplink(url: url)
        return true;
    }
    
    func handleDeeplink(url: URL?) {
        DeeplinkMethodChannel.shared.openLink(url: url)
    }
    
    func donateInteraction(){
        let intent = INSearchForNotebookItemsIntent()
        let interaction = INInteraction(intent: intent, response: nil)

        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Interaction donation failed: \(error.description)")
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
    }
}
