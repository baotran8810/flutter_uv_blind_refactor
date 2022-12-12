//
//  DataMigrateMethodChannel.swift
//  Runner
//
//  Created by Tuna on 8/2/21.
//

import Foundation

class DataMigrateChannel {
    static let shared = DataMigrateChannel()
    private var channel: FlutterMethodChannel?
    private var isMigrated: Bool = false
    
    private init() {}
    
    func register(with registrar: FlutterPluginRegistrar)  {
        channel = FlutterMethodChannel(name: "uv_migration", binaryMessenger: registrar.messenger())
        channel?.setMethodCallHandler(handler)
        
        if let _isMigrated: Bool = Preferences.shareInstance()?.getDidFlutterMigrate() {
            isMigrated = _isMigrated
        }
    }
    
    func handler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method.elementsEqual("check_migrated")) {
            print(isMigrated)
            if (!isMigrated) {
                print("Starting migration...")
                startMigrate()
            }
            result(isMigrated)
        }
    }
    
    func startMigrate() {
        channel?.invokeMethod("start_migrate", arguments: nil)
        
        migrateAddress()
        migrateScanCodeList()
        migrateSettings()
        
        channel?.invokeMethod("end_migrate", arguments: nil)
        //Preferences.shareInstance()?.setDidFlutterMigrate(true)
    }
    
    private func migrateAddress() {
        let tagData = Preferences.shareInstance()?.getTagData()
        channel?.invokeMethod("migrate_address", arguments: tagData)
    }
    
    private func migrateScanCodeList() {
        if let items = FileManager.sharedInstance()?.fetchFileList() {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            for item in items {
                let i: NSDictionary = item as! NSDictionary
                print("Copying " + (i.value(forKey: "fileName") as! String))
                let itemDict: NSMutableDictionary = NSMutableDictionary()
                let itemDate = i.value(forKey: "createdDate") as! NSDate
                itemDict.setValue(i.value(forKey: "fileId"), forKey: "fileId")
                itemDict.setValue(i.value(forKey: "fileName"), forKey: "fileName")
                itemDict.setValue(formatter.string(from: itemDate as Date), forKey: "createdDate")
                itemDict.setValue(i.value(forKey: "sourceContent"), forKey: "sourceContent")
                itemDict.setValue(i.value(forKey: "translatedContent"), forKey: "translatedContent")
                itemDict.setValue(i.value(forKey: "readOutContent"), forKey: "readOutContent")
                itemDict.setValue(i.value(forKey: "targetLanguage"), forKey: "targetLanguage")
                itemDict.setValue(i.value(forKey: "ids"), forKey: "ids")
                itemDict.setValue(i.value(forKey: "isJanCode"), forKey: "isJanCode")
                itemDict.setValue(i.value(forKey: "isQRCode"), forKey: "isQRCode")
                itemDict.setValue(i.value(forKey: "isFavourite"), forKey: "isFavourite")
                itemDict.setValue(i.value(forKey: "codeType"), forKey: "codeType")
                
                channel?.invokeMethod("migrate_scan_code", arguments: itemDict)
            }
        }
    }
    
    private func migrateSettings() {
        let oldPrefs: NSMutableDictionary = NSMutableDictionary()
        oldPrefs.setValue(Preferences.shareInstance()?.getSpeedReadOut(), forKey: "setting_speed_read_out")
        oldPrefs.setValue(Preferences.shareInstance()?.getContinuousScanSetting(), forKey: "setting_continuous_scan")
        oldPrefs.setValue(Preferences.shareInstance()?.getOutOfCourseDistancesSetting(), forKey: "uvb.setting_out_of_course")
        oldPrefs.setValue(Preferences.shareInstance()?.getCameraLightSetting(), forKey: "setting_camera_light")
        oldPrefs.setValue(Preferences.shareInstance()?.getCheckinRadiusSetting(), forKey: "uvb.setting_checkin_radius")
        oldPrefs.setValue(Preferences.shareInstance()?.getNoScanSoundSetting(), forKey: "setting_no_scan_sound")
        oldPrefs.setValue(Preferences.shareInstance()?.getVibeSetting(), forKey: "uvb.setting_vibe")
        oldPrefs.setValue(Preferences.shareInstance()?.getShakeSetting(), forKey: "uvb.setting_shake")
        oldPrefs.setValue(Preferences.shareInstance()?.getGuideByVoiceSetting(), forKey: "uvb.setting_guive_voice")
        oldPrefs.setValue(Preferences.shareInstance()?.getColorBorderSetting(), forKey: "setting_color_border")
        oldPrefs.setValue(Preferences.shareInstance()?.getThicknessLevelSetting(), forKey: "setting_thickness_level")
        oldPrefs.setValue(Preferences.shareInstance()?.getLanguageSetting().rawValue, forKey: "setting_language")
        oldPrefs.setValue(Preferences.shareInstance()?.getSignLanguageSetting(), forKey: "setting_sign_language")
        oldPrefs.setValue(Preferences.shareInstance()?.getVoiceSpeedSetting(), forKey: "uvb.setting_voice_speed")
        
        channel?.invokeMethod("migrate_settings", arguments: oldPrefs)
    }
}
