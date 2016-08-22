//
//  IMLocalizeManager.h
//  Pods
//
//  Created by Inigo Mato on 01/07/2016.
//
//

#import <Foundation/Foundation.h>

@interface IMLocalizeManager : NSObject

@property (nonatomic, strong) NSString *languageIdentifier;
@property (nonatomic, strong) NSDictionary *languageDictionary;
@property (nonatomic, strong) NSMutableDictionary *missingTranslations;

+ (IMLocalizeManager *)shared;

+ (NSDictionary *)missingTranslations;

- (void)setup;
- (NSString *)languageIdentifierPreferred;
- (NSString *)languageIdentifierStored;
- (void)updateLanguageIdentifier:(NSString *)languageIdentifier;
- (void)updateLanguageIdentifier:(NSString *)languageIdentifier
               completionHandler:(void (^)(void))block;
- (NSArray *)allJSONFileNamesArray;

NSString *IMLocalize(NSString *defaultString);

@end
