//
//  Preferences.h
//  UVX
//
//  Created by Luan Tran on 10/19/15.
//  Copyright © 2015 csnguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FLAG_FLUTTER_MIGRATE            "flag_flutter_migrate"
#define FLAG_FIRST_TIME                 "flag_first_time"
#define SETTING_CONTINUOUS_SCAN         "setting_continuous_scan"
#define SETTING_CAMERA_LIGHT            "setting_camera_light"
#define SETTING_SIGN_LANGUAGE           "setting_sign_language"
#define SETTING_NO_SCAN_SOUND           "setting_no_scan_sound"
#define SETTING_THICKNESS_LEVEL         "setting_thickness_level"
#define SETTING_COLOR_BORDER            "setting_color_border"
#define SETTING_LANGUAGE                "setting_language"
#define SETTING_SOUND_CONTROL           "setting_sound_control"
#define SETTING_SPEED_READ_OUT          "setting_speed_read_out"
#define SETTING_SEARCH_VOICE_SPEED      "setting_search_voice_speed"
// New
#define SETTING_GUIDE_VOICE             @"uvb.setting_guive_voice"
#define SETTING_VIBE                    @"uvb.setting_vibe"
#define SETTING_SHAKE                   @"uvb.setting_shake"
#define SETTING_OUT_OF_COURSE           @"uvb.setting_out_of_course"
#define SETTING_CHECKIN_RADIUS          @"uvb.setting_checkin_radius"
#define SETTING_VOICE_SPEED             @"uvb.setting_voice_speed"
#define FLAG_OPEN_COUNT                 @"uvb.flag_open_count"
#define FLAG_PICKED_LOCATION            @"uvb.flag_picked_location"
#define FLAG_SKIP_PICK_LOCATION         @"uvb.flag_skip_pick_location"

typedef enum {
    ENGLISH_US     = 0,
    JAPANESE    = 1,
    SIMPLIFIED_CHINESE = 2,
    TRADITIONAL_CHINESE= 3,
    KOREAN      = 4,
    FRENCH      = 5,
    GERMAN      = 6,
    SPANISH     = 7,
    ITALIAN     = 8,
    PORTUGUESE  = 9,
    RUSSIAN     = 10,
    THAI        = 11,
    INDONESIAN  = 12,
    ARABIC      = 13
} LanguageSetting;

typedef enum {
    WHITE   = 0,
    BLACK   = 1,
    BROWN   = 2,
    BLUE    = 3,
    GREEN   = 4,
    ORANGE  = 5,
    PURPLE  = 6,
    PINK    = 7
} BorderColor;

@interface Preferences : NSObject

+ (instancetype)shareInstance;

- (void)setDidFlutterMigrate:(bool)on;
- (void)setDidFirstTime:(bool)on;
- (void)setContinuousScanSetting:(bool)on;
- (void)setCameraLightSetting:(bool)on;
- (void)setSignLanguageSetting:(bool)on;
- (void)setNoScanSoundSetting:(bool)on;
- (void)setThicknessLevelSetting:(int)level;
- (void)setColorBorderSetting:(NSArray*)color;
- (void)setLanguageSetting:(LanguageSetting)language;
- (void)setSoundControlSetting:(bool)on;
- (void)setSpeechReadOut:(CGFloat) value;
- (void)setSearchVoiceSpeedSetting:(CGFloat) value;
- (void)setGuideByVoiceSetting:(bool) value;
- (void)setVibeSetting:(bool) value;
- (void)setShakeSetting:(bool) value;
- (void)setCheckinRadiusSetting:(int)level;
- (void)setOutOfCourseDistancesSetting:(int)level;
- (void)setVoiceSpeedSetting:(double)value;
- (void)increaseOpenAppCount;
- (void)resetOpenAppCount;

- (bool)getDidFlutterMigrate;
- (bool)getDidFirstTime;
- (bool)getContinuousScanSetting;
- (bool)getCameraLightSetting;
- (bool)getSignLanguageSetting;
- (bool)getNoScanSoundSetting;
- (int)getThicknessLevelSetting;
- (NSArray*)getColorBorderSetting;
- (LanguageSetting)getLanguageSetting;
- (bool)getSoundControlSetting;
- (CGFloat)getSpeedReadOut;
- (CGFloat)getSearchVoiceSpeedSetting;
- (bool)getGuideByVoiceSetting;
- (bool)getVibeSetting;
- (bool)getShakeSetting;
- (NSInteger)getCheckinRadiusSetting;
- (NSInteger)getOutOfCourseDistancesSetting;
- (double)getVoiceSpeedSetting;
- (NSInteger)getOpenAppCount;

- (NSDictionary*)getTagData;
- (void)markedPickedLocation:(NSDictionary*)tagData;

- (BOOL)isSkipPickLocation;
- (void)markSkipPickLocation;

@end
