//
//  Preferences.m
//  UVX
//
//  Created by Luan Tran on 10/19/15.
//  Copyright © 2015 csnguyen. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

+ (instancetype)shareInstance {
    static Preferences *preferences;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preferences = [[self alloc] init];
    });
    return preferences;
}

- (void)setDidFlutterMigrate:(bool)on {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:on forKey:@FLAG_FLUTTER_MIGRATE];
    [ud synchronize];
}

- (void)setDidFirstTime:(bool)on {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:on forKey:@FLAG_FIRST_TIME];
    [ud synchronize];
}

- (void)setContinuousScanSetting:(bool)on {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:on forKey:@SETTING_CONTINUOUS_SCAN];
    [ud synchronize];
}

- (void)setCameraLightSetting:(bool)on {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:on forKey:@SETTING_CAMERA_LIGHT];
    [ud synchronize];
}

- (void)setSignLanguageSetting:(bool)on {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:on forKey:@SETTING_SIGN_LANGUAGE];
    [ud synchronize];
}

- (void)setNoScanSoundSetting:(bool)on {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:on forKey:@SETTING_NO_SCAN_SOUND];
    [ud synchronize];
}

- (void)setThicknessLevelSetting:(int)level {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:level forKey:@SETTING_THICKNESS_LEVEL];
    [ud synchronize];
}

- (void)setColorBorderSetting:(NSArray*)color {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:color forKey:@SETTING_COLOR_BORDER];
    [ud synchronize];
}

- (void)setLanguageSetting:(LanguageSetting)language {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:language forKey:@SETTING_LANGUAGE];
    [ud synchronize];
}

- (void)setSoundControlSetting:(bool)on {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:on forKey:@SETTING_SOUND_CONTROL];
    [ud synchronize];
}

-(void) setSpeechReadOut:(CGFloat) value {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setDouble:value forKey:@SETTING_SPEED_READ_OUT];
    [ud synchronize];
}

-(void) setSearchVoiceSpeedSetting:(CGFloat) value {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setDouble:value forKey:@SETTING_SEARCH_VOICE_SPEED];
    [ud synchronize];
}
- (void)setGuideByVoiceSetting:(bool) value {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:SETTING_GUIDE_VOICE];
    [ud synchronize];
}
- (void)setVibeSetting:(bool) value {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:SETTING_VIBE];
    [ud synchronize];
}
- (void)setShakeSetting:(bool) value {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:SETTING_SHAKE];
    [ud synchronize];
}
- (void)setCheckinRadiusSetting:(int)level {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:level forKey:SETTING_CHECKIN_RADIUS];
    [ud synchronize];
}
- (void)setOutOfCourseDistancesSetting:(int)level {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:level forKey:SETTING_OUT_OF_COURSE];
    [ud synchronize];
}
- (void)setVoiceSpeedSetting:(double)value {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setDouble:value forKey:SETTING_VOICE_SPEED];
    [ud synchronize];
}
- (void)increaseOpenAppCount {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger count = [ud integerForKey:FLAG_OPEN_COUNT] ?: 0;
    count++;
    [ud setInteger:count forKey:FLAG_OPEN_COUNT];
    [ud synchronize];
}
- (void)resetOpenAppCount {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:0 forKey:FLAG_OPEN_COUNT];
    [ud synchronize];
}

// Getters
- (bool)getDidFlutterMigrate {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@FLAG_FLUTTER_MIGRATE];
}

- (bool)getDidFirstTime {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@FLAG_FIRST_TIME];
}

- (bool)getContinuousScanSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@SETTING_CONTINUOUS_SCAN];
}

- (bool)getCameraLightSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@SETTING_CAMERA_LIGHT];
}

- (bool)getSignLanguageSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@SETTING_SIGN_LANGUAGE];
}

- (bool)getNoScanSoundSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@SETTING_NO_SCAN_SOUND];
}

- (int)getThicknessLevelSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return (int) [ud integerForKey:@SETTING_THICKNESS_LEVEL];
}

- (NSArray*)getColorBorderSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud arrayForKey:@SETTING_COLOR_BORDER];
}

- (LanguageSetting)getLanguageSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return (LanguageSetting) [ud integerForKey:@SETTING_LANGUAGE];
}

- (bool)getSoundControlSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@SETTING_SOUND_CONTROL];
}

-(CGFloat)getSpeedReadOut {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud doubleForKey:@SETTING_SPEED_READ_OUT]) {
        return 0.32;
    }
    return [ud doubleForKey:@SETTING_SPEED_READ_OUT];
}

-(CGFloat)getSearchVoiceSpeedSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud doubleForKey:@SETTING_SEARCH_VOICE_SPEED]) {
        return 0.32;
    }
    return [ud doubleForKey:@SETTING_SEARCH_VOICE_SPEED];
}

- (bool)getGuideByVoiceSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:SETTING_GUIDE_VOICE];
}
- (bool)getVibeSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:SETTING_VIBE];
}
- (bool)getShakeSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:SETTING_SHAKE];
}
- (NSInteger)getCheckinRadiusSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud integerForKey:SETTING_CHECKIN_RADIUS];
}
- (NSInteger)getOutOfCourseDistancesSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud integerForKey:SETTING_OUT_OF_COURSE];
}
- (double)getVoiceSpeedSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud doubleForKey:SETTING_VOICE_SPEED];
}
- (NSInteger)getOpenAppCount {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger count = [ud integerForKey:FLAG_OPEN_COUNT] ?: 0;
    return count;
}

// Location
- (NSDictionary*)getTagData {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    NSString *locationString = [ud objectForKey:FLAG_PICKED_LOCATION];
    if (!locationString || [locationString isEqualToString:@""]) {
        return nil;
    }
    NSError * err;
    NSData *data =[locationString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * response;
    if (data != nil) {
        response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    }
    return response;
}
- (void)markedPickedLocation:(NSDictionary*)tagData {
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tagData options:0 error:&err];
    NSString *encodedString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!err) {
        NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
        [ud setObject:encodedString forKey:FLAG_PICKED_LOCATION];
    }
}
- (BOOL)isSkipPickLocation {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    NSString *locationString = [ud objectForKey:FLAG_SKIP_PICK_LOCATION];
    return locationString && ![locationString isEqualToString:@""];
}
- (void) markSkipPickLocation {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    [ud setObject:@"YES" forKey:FLAG_SKIP_PICK_LOCATION];
    [ud synchronize];
}
@end
