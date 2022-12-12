//
//  IntentHandler.m
//  UV_SiriExtension
//
//  Created by lituser on 27/10/2021.
//

#import "IntentHandler.h"
#import <sqlite3.h>

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

@interface IntentHandler () <INSearchForNotebookItemsIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    
    return self;
}
-(void)resolveTitleForSearchForNotebookItems:(INSearchForNotebookItemsIntent *)intent withCompletion:(void (^)(INSpeakableStringResolutionResult * _Nonnull))completion {
    INSpeakableStringResolutionResult *result = nil;
    if (intent.title) {
        result = [INSpeakableStringResolutionResult successWithResolvedString:intent.title];
        NSLog(@"Resolove for Title: %@", intent.title.spokenPhrase);
    } else {
        result = [INSpeakableStringResolutionResult notRequired];
    }
    completion(result);
}

-(void)resolveContentForSearchForNotebookItems:(INSearchForNotebookItemsIntent *)intent withCompletion:(void (^)(INStringResolutionResult * _Nonnull))completion {
    INStringResolutionResult *result = nil;
    if (intent.content) {
        result = [INStringResolutionResult successWithResolvedString:intent.content];
        NSLog(@"Resolove for Title: %@", intent.content);
    } else {
        result = [INStringResolutionResult notRequired];
    }
    completion(result);
}

-(void)resolveDateTimeForSearchForNotebookItems:(INSearchForNotebookItemsIntent *)intent withCompletion:(void (^)(INDateComponentsRangeResolutionResult * _Nonnull))completion {
    INDateComponentsRangeResolutionResult *result = nil;
    if (intent.dateTime) {
        result = [INDateComponentsRangeResolutionResult successWithResolvedDateComponentsRange:intent.dateTime];
        NSLog(@"Resolove for Title: %@", intent.dateTime.description);
    } else {
        result = [INDateComponentsRangeResolutionResult notRequired];
    }
    completion(result);
}

-(void)confirmSearchForNotebookItems:(INSearchForNotebookItemsIntent *)intent completion:(void (^)(INSearchForNotebookItemsIntentResponse * _Nonnull))completion {
    completion([[INSearchForNotebookItemsIntentResponse alloc] initWithCode:INSearchForNotebookItemsIntentResponseCodeReady userActivity:nil]);
}

- (void)handleSearchForNotebookItems:(nonnull INSearchForNotebookItemsIntent *)intent completion:(nonnull void (^)(INSearchForNotebookItemsIntentResponse * _Nonnull))completion {
    NSString *keyword = nil;
    if (intent.title) {
        keyword = intent.title.spokenPhrase;
    } else if (intent.content) {
        keyword = intent.content;
    }
    NSDate *sDate, *eDate;
    if (intent.dateTime) {
        sDate = [intent.dateTime.startDateComponents date];
        eDate = [intent.dateTime.endDateComponents date];
    }
    NSString *newKeyword = @"";
    if ([keyword hasPrefix:@"の"]) {
        newKeyword = (NSString *)[[keyword componentsSeparatedByString:@"の"] lastObject];
    } else {
        newKeyword = keyword;
    }
    // keyword containt: 以前 | 以降 | 以後
    unsigned dateFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents *startDate, *endDate;
    NSDateComponents *currentDate = [calendar components:dateFlags fromDate:[NSDate date]];
    NSArray *keywordComponents = [keyword componentsSeparatedByString:@"の"];
    NSString *keywordByArr = keyword;
    for (NSString *keyItem in keywordComponents) {
        if (![keyItem isEqualToString:@""]) {
            keywordByArr = keyItem;
            break;
        }
    }
    if ([keywordByArr containsString:@"以前"]) {
        if (eDate == nil) {
            eDate = [NSDate date];
        }
        endDate = [calendar components:dateFlags fromDate:eDate];
        if (![keywordByArr containsString:@"年"]) {
            startDate.year = currentDate.year;
        }
        endDate.hour = 23;
        endDate.minute = 59;
        endDate.second = 59;
        if ([keywordByArr containsString:@"先月"]) {
            endDate.month = endDate.month - 1;
        }
        if (([keywordByArr containsString:@"月"] && [keyword containsString:@"日"]) || [keyword containsString:@"年"]) {
            endDate.day = startDate.day;
        } else {
            if ([keywordByArr containsString:@"月"]) {
                endDate.month = endDate.month;
                endDate.day = [self getLastDateOfMonth:endDate.month andYear:endDate.year];;
            } else {
                endDate.day = endDate.day;
            }
        }
        eDate = [calendar dateFromComponents:endDate];
        if (keywordComponents.count > 1) {
            newKeyword = [keywordComponents lastObject];
        } else {
            newKeyword = @"";
        }
    } else if ([keywordByArr containsString:@"以降"] || [keywordByArr containsString:@"以後"]) {
        if (sDate == nil) {
            sDate = [NSDate date];
        }
        startDate = [calendar components:dateFlags fromDate:sDate];
        if (![keywordByArr containsString:@"年"]) {
            startDate.year = currentDate.year;
        }
        startDate.hour = 0;
        startDate.minute = 0;
        startDate.second = 0;
        if ([keywordByArr containsString:@"先月"]) {
            startDate.month = startDate.month - 1;
        }
        if (startDate) {
            if (([keywordByArr containsString:@"月"] && [keywordByArr containsString:@"日"]) || [keywordByArr containsString:@"年"]) {
                startDate.day = startDate.day;
            } else {
                if ([keywordByArr containsString:@"月"]) {
                    startDate.month = startDate.month;
                    startDate.day = 1;
                } else {
                    startDate.day = startDate.day;
                }
            }
        }
        sDate = [calendar dateFromComponents:startDate];
        if (keywordComponents.count > 1) {
            newKeyword = [keywordComponents lastObject];
        } else {
            newKeyword = @"";
        }
    } else {
        if (keywordComponents.count > 1) {
            if ([keywordByArr containsString:@"今日"]) {
                if (sDate == nil) {
                    sDate = [NSDate date];
                    eDate = [NSDate date];
                    startDate = [calendar components:dateFlags fromDate:sDate];
                    startDate.hour = 0;
                    startDate.minute = 0;
                    startDate.second = 0;
                    endDate = [calendar components:dateFlags fromDate:eDate];
                    endDate.hour = 23;
                    endDate.minute = 59;
                    endDate.second = 59;
                }
                sDate = [calendar dateFromComponents:startDate];
                eDate = [calendar dateFromComponents:endDate];
            }else if ([keywordByArr containsString:@"今週"]) {
                if (sDate == nil) {
                    int dayofweek = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday];
                    startDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    [startDate setDay:([startDate day] - ((dayofweek) - 2))];
                    startDate.hour = 0;
                    startDate.minute = 0;
                    startDate.second = 0;
                    NSDate *beginningOfWeek = [calendar dateFromComponents:startDate];
                    sDate = beginningOfWeek;
                }
                if (eDate == nil) {
                    int Enddayofweek = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday];
                    endDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    [endDate setDay:([endDate day]+(7-Enddayofweek)+1)];
                    endDate.hour = 0;
                    endDate.minute = 0;
                    endDate.second = 0;
                    NSDate *EndOfWeek = [calendar dateFromComponents:endDate];
                    eDate = EndOfWeek;
                }
            }else if ([keywordByArr containsString:@"今月"]) {
                if (sDate == nil) {
                    startDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    startDate.day = 1;
                    startDate.hour = 0;
                    startDate.minute = 0;
                    startDate.second = 0;
                    sDate = [calendar dateFromComponents:startDate];
                }
                if (eDate == nil) {
                    endDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    endDate.day = [self getLastDateOfMonth:endDate.month andYear:currentDate.year];
                    endDate.hour = 23;
                    endDate.minute = 59;
                    endDate.second = 59;
                    eDate = [calendar dateFromComponents:endDate];
                }
            }else if ([keywordByArr containsString:@"今年"]){
                if (sDate == nil) {
                    startDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    startDate.year = currentDate.year;
                    startDate.month = 1;
                    startDate.day = 1;
                    startDate.hour = 0;
                    startDate.minute = 0;
                    startDate.second = 0;
                    sDate = [calendar dateFromComponents:startDate];
                }
                if (eDate == nil) {
                    endDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    endDate.year = currentDate.year;
                    endDate.month = 12;
                    endDate.day = 31;
                    endDate.hour = 23;
                    endDate.minute = 59;
                    endDate.second = 59;
                    eDate = [calendar dateFromComponents:endDate];
                }
            }else if ([keywordByArr containsString:@"昨日"]) {
                if (sDate == nil) {
                    sDate = [NSDate date];
                    startDate = [calendar components:dateFlags fromDate:sDate];
                    startDate.day = startDate.day - 1;
                    startDate.hour = 0;
                    startDate.minute = 0;
                    startDate.second = 0;
                    sDate = [calendar dateFromComponents:startDate];
                }
                if (eDate == nil) {
                    eDate = [NSDate date];
                    endDate = [calendar components:dateFlags fromDate:eDate];
                    endDate.day = endDate.day - 1;
                    endDate.hour = 23;
                    endDate.minute = 59;
                    endDate.second = 59;
                    eDate = [calendar dateFromComponents:endDate];
                }
            }else if ([keywordByArr containsString:@"先週"]){
                if (sDate == nil) {
                    int dayofweek = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday];
                    startDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    [startDate setDay:([startDate day] - ((dayofweek) - 2))];
                    startDate.day = startDate.day - 7;
                    startDate.hour = 0;
                    startDate.minute = 0;
                    startDate.second = 0;
                    NSDate *beginningOfWeek = [calendar dateFromComponents:startDate];
                    sDate = beginningOfWeek;
                }
                if (eDate == nil) {
                    int Enddayofweek = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday];
                    endDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    [endDate setDay:([endDate day]+(7-Enddayofweek)+1)];
                    endDate.day = endDate.day - 7;
                    startDate.hour = 23;
                    startDate.minute = 59;
                    startDate.second = 59;
                    NSDate *EndOfWeek = [calendar dateFromComponents:endDate];
                    eDate = EndOfWeek;
                }
            }else if ([keywordByArr containsString:@"先月"]){
                if (sDate == nil) {
                    startDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    startDate.month = startDate.month - 1;
                    startDate.day = 1;
                    startDate.hour = 0;
                    startDate.minute = 0;
                    startDate.second = 0;
                    sDate = [calendar dateFromComponents:startDate];
                }
                if (eDate == nil) {
                    endDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    endDate.month = endDate.month - 1;
                    endDate.day = [self getLastDateOfMonth:endDate.month andYear:currentDate.year];
                    endDate.hour = 23;
                    endDate.minute = 59;
                    endDate.second = 59;
                    eDate = [calendar dateFromComponents:endDate];
                }
            }else if ([keywordByArr containsString:@"先年"]){
                if (sDate == nil) {
                    startDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    startDate.year = currentDate.year - 1;
                    startDate.month = 1;
                    startDate.day = 1;
                    startDate.hour = 0;
                    startDate.minute = 0;
                    startDate.second = 0;
                    sDate = [calendar dateFromComponents:startDate];
                }
                if (eDate == nil) {
                    endDate = [calendar components:dateFlags fromDate:[NSDate date]];
                    endDate.year = currentDate.year - 1;
                    endDate.month = 12;
                    endDate.day = 31;
                    endDate.hour = 23;
                    endDate.minute = 59;
                    endDate.second = 59;
                    eDate = [calendar dateFromComponents:endDate];
                }
            } else {
                NSDate *currentDate = [NSDate date];
                startDate = [calendar components:dateFlags fromDate:currentDate];
                if (keywordComponents.count > 2) {
                    if ([(NSString *)keywordComponents[1] containsString:@"日"]) {
                        startDate.day = [[keywordComponents[1] substringToIndex:2] integerValue];
                    } else if([(NSString *)keywordComponents[1] containsString:@"月"]) {
                        startDate.month = [[keywordComponents[1] substringToIndex:2] integerValue];
                        startDate.day = 1;
                    } else if([(NSString *)keywordComponents[1] containsString:@"年"]) {
                        startDate.year = [[keywordComponents[1] substringToIndex:4] integerValue];
                        startDate.month = 1;
                        startDate.day = 1;
                    }
                } else {
                    if (keywordComponents.count > 1) {
                        if ([(NSString *)keywordComponents[0] containsString:@"日"]) {
                            startDate.day = [[keywordComponents[0] substringToIndex:2] integerValue];
                        } else if([(NSString *)keywordComponents[0] containsString:@"月"]) {
                            startDate.month = [[keywordComponents[0] substringToIndex:2] integerValue];
                            startDate.day = 1;
                        } else if([(NSString *)keywordComponents[0] containsString:@"年"]) {
                            startDate.year = [[keywordComponents[0] substringToIndex:4] integerValue];
                            startDate.month = 1;
                            startDate.day = 1;
                        }
                    }
                }
                if ([(NSString *)keywordComponents[0] containsString:@"日"] || [(NSString *)keywordComponents[0] containsString:@"月"] || [(NSString *)keywordComponents[0] containsString:@"年"])  {
                    startDate.hour = 0;
                    startDate.minute = 0;
                    startDate.second = 0;
                    endDate = [calendar components:dateFlags fromDate:currentDate];
                }
                if (keywordComponents.count > 2) {
                    if ([(NSString *)keywordComponents[1] containsString:@"日"]) {
                        endDate.day = [[keywordComponents[1] substringToIndex:2] integerValue];
                    } else if([(NSString *)keywordComponents[1] containsString:@"月"]) {
                        endDate.month = [[keywordComponents[1] substringToIndex:2] integerValue];
                        endDate.day = [self getLastDateOfMonth:endDate.month andYear:endDate.year];
                    } else if([(NSString *)keywordComponents[0] containsString:@"年"])  {
                        endDate.year = [[keywordComponents[1] substringToIndex:4] integerValue];
                        endDate.month = 12;
                        endDate.day = 31;
                    }
                } else {
                    if (keywordComponents.count > 1) {
                        if ([(NSString *)keywordComponents[0] containsString:@"日"]) {
                            endDate.day = [[keywordComponents[0] substringToIndex:2] integerValue];
                        } else if([(NSString *)keywordComponents[0] containsString:@"月"]) {
                            endDate.month = [[keywordComponents[0] substringToIndex:2] integerValue];
                            endDate.day = [self getLastDateOfMonth:endDate.month andYear:endDate.year];
                        } else if([(NSString *)keywordComponents[0] containsString:@"年"])  {
                            endDate.year = [[keywordComponents[0] substringToIndex:4] integerValue];
                            endDate.month = 12;
                            endDate.day = 31;
                        }
                    }
                }
                if ([(NSString *)keywordComponents[0] containsString:@"日"] || [(NSString *)keywordComponents[0] containsString:@"月"] || [(NSString *)keywordComponents[0] containsString:@"年"]) {
                    endDate.hour = 23;
                    endDate.minute = 59;
                    endDate.second = 59;
                    sDate = [calendar dateFromComponents:startDate];
                    eDate = [calendar dateFromComponents:endDate];
                }
            }
            newKeyword = [keywordComponents lastObject];
        }
        
        NSMutableArray *queryList = [[NSMutableArray alloc] init];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *currentDateFormat = [calendar components:dateFlags fromDate:currentDate];
        
        //Siri bug: Time response Start date = 2:00, End date = 13:00 -> Fix time to be queryable
        //Siri bug: Year response = current year + 1 with search contains Month - EX: 10月29日 -> Fix year = current year to be queryable
        if(eDate){
            NSDateComponents *endDateFormat = [calendar components:dateFlags fromDate:eDate];
            endDateFormat.hour = 23;
            endDateFormat.minute = 59;
            endDateFormat.second = 59;
            if(endDateFormat.year > currentDateFormat.year){
                endDateFormat.year = currentDateFormat.year;
            }
            eDate = [calendar dateFromComponents:endDateFormat];
        }
        if(sDate){
            NSDateComponents *startDateFormat = [calendar components:dateFlags fromDate:sDate];
            startDateFormat.hour = 0;
            startDateFormat.minute = 0;
            startDateFormat.second = 0;
            if(startDateFormat.year > currentDateFormat.year){
                startDateFormat.year = currentDateFormat.year;
            }
            sDate = [calendar dateFromComponents:startDateFormat];
        }
        
        //Date in sqlite is Timespan from 1970 -> parse to be compareable in sqlite
        NSTimeInterval sDateUnix = [sDate timeIntervalSince1970];
        NSTimeInterval eDateUnix = [eDate timeIntervalSince1970];
        
        // Start date <= Current date <= End date AND content contains KEYWORD
        if ([keyword containsString:@"以降"] || [keyword containsString:@"以前"] || [keywordByArr containsString:@"以後"]) {
            if ([keyword containsString:@"以降"] || [keywordByArr containsString:@"以後"]) {
                [queryList addObject:[NSString stringWithFormat:@"date >= %f", sDateUnix]];
            } else{
                [queryList addObject:[NSString stringWithFormat:@"date <= %f", eDateUnix]];
            }
        } else {
            if(sDate){
                [queryList addObject:[NSString stringWithFormat:@"date >= %f", sDateUnix]];
            }
            if(eDate){
                [queryList addObject:[NSString stringWithFormat:@"date <= %f", eDateUnix]];
            }
        }
        if (newKeyword && ![newKeyword isEqualToString:@""]) {
            [queryList addObject: [NSString stringWithFormat:@"(title LIKE '%%%@%%' OR lang_key_with_content_map_json LIKE '%%%@%%')",newKeyword, newKeyword]];
        }
        
        NSString *query = @"SELECT lang_key_with_content_map_json, date FROM scan_code_sql_entities";
        
        //Map QUERY condition with query
        if(queryList != nil && queryList.count > 0){
            NSString *queryCondition = [queryList componentsJoinedByString:@" AND "];
            NSString *queryConditionStr =[NSString stringWithFormat:@" WHERE %@", queryCondition];
            query = [query stringByAppendingString:queryConditionStr];
        }
        
        // Call DB
        NSString *kDbName = @"db.sqlite";
        NSURL *groupURL = [[self applicationGroupDirectory] URLByAppendingPathComponent:kDbName];
        
        NSMutableArray *resFiles = [[NSMutableArray alloc] init];
        sqlite3 *_database;
        NSString *dbURL = groupURL.path;
        if (sqlite3_open([dbURL UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
        
        //Run Query
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK) {
            //check query result and add to Note list
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *contentJsonStr=[[NSString alloc]initWithUTF8String:(char *) sqlite3_column_text(statement, 0)];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 1)];
                NSString *content = [self contentBySiriLang:contentJsonStr];
                INNote *resNote = [[INNote alloc] initWithTitle:[[INSpeakableString alloc] initWithSpokenPhrase: [NSString stringWithFormat:@"%@",content]] contents:@[] groupName:nil createdDateComponents:[calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date] modifiedDateComponents:[calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date] identifier:nil];
                [resFiles addObject:resNote];
            }
            sqlite3_finalize(statement);
            sqlite3_close(_database);
        }
        
        INSearchForNotebookItemsIntentResponse *response = [[INSearchForNotebookItemsIntentResponse alloc] initWithCode:INSearchForNotebookItemsIntentResponseCodeSuccess userActivity:nil];
        response.notes = resFiles;
        completion(response);
    }
}



-(NSURL *) applicationGroupDirectory {
    NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
    NSString *groupBid;
    if([bid  isEqual: @"jp.uni-voice.blind.dev.UV-SiriExtension"]){
        groupBid = @"group.jp.uni-voice.blind.dev";
    } else if([bid  isEqual: @"jp.uni-voice.blind.stag.UV-SiriExtension"]) {
        groupBid = @"group.jp.uni-voice.blind.stag";
    } else {
        groupBid = @"group.jp.uni-voice.blind";
    }
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:groupBid];
}

-(NSString *) contentBySiriLang:(NSString*) content{
    //get siri lang
    NSString *code = [INPreferences siriLanguageCode];
    NSString *result;
    NSDictionary *dictionary = @{
        @"ja-JP" : @".jpn",
        @"en-US" : @".eng",
        @"zh-CN" : @".chi",
        @"ko-KR" : @".kor",
        @"zh-TW" : @".zho",
        @"vi-VN" : @".vie",
        @"fr-FR" : @".fre",
        @"de-DE" : @".ger",
        @"es-ES" : @".spa",
        @"is-IT" : @".ita",
        @"pt-PT" : @".por",
        @"ru-RU" : @".rus",
        @"th-TH" : @".tai",
        @"id-ID" : @".ind",
        @"ar-SA" : @".ara",
        @"nl-NL" : @".dut",
        @"hi-IN" : @".hin",
        @"fil-PH" : @".tgl",
        @"ms-MY" : @".may",
    };
    
    NSString *contentLangCode = dictionary[code];
    if(contentLangCode == nil){
        contentLangCode = @".jpn";
    }
    
    NSError *jsonError;
    NSData *objectData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    result = json[contentLangCode];
    if(result == nil && json != (NSDictionary*) [NSNull null]){
        id key = [[json allKeys] objectAtIndex:0];
        result = json[key];
    }
    return result;
}

-(NSInteger) getLastDateOfMonth:(NSInteger) month andYear:(NSInteger) year  {
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return 31;
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
        default:
            if (year % 4 == 0) {
                return 29;
            }
            return 28;
    }
}

@end
