//
//  IMLocalizeManager.m
//  Pods
//
//  Created by Inigo Mato on 01/07/2016.
//
//

#import "IMLocalizeManager.h"

#define kIMLanguageDictionaryKey @"IMLanguageDictionary"
#define kIMLanguageIdentifierKey @"IMLanguageIdentifier"
#define kIMLanguageDictionaryURLKey @"IMLanguageDictionaryURLKey"


static NSMutableDictionary *_missingTranslations;

#pragma mark - Interface

@interface IMLocalizeManager ()

@end

#pragma mark - Implementation

@implementation IMLocalizeManager

+ (instancetype)shared
{
    static IMLocalizeManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedInstance = [[IMLocalizeManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - language Setup

- (void)setupWithUrlString:(NSString *)urlString
{
    [self saveObject:urlString forKey:kIMLanguageDictionaryURLKey];
    [self updateLanguageIdentifier:[self languageIdentifierPreferred]];
}

- (NSString *)languageIdentifierPreferred
{
    //Check if we have a language already chosen in the app settings
    NSString *languageIdentifier = [self languageIdentifierStored];
    
    //If not, take the device language
    if (!languageIdentifier)
    {
        languageIdentifier = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    
    //If we don't support the device language, then we go to default language: English
    NSString *languageJSONFileName = [languageIdentifier stringByAppendingString:@".json"];
    if(![[self allJSONFileNamesArray] containsObject: languageJSONFileName])
    {
        languageIdentifier = @"en";
    }
    
    return languageIdentifier;
}

- (NSString *)languageIdentifierStored
{
    NSString *languageIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:kIMLanguageIdentifierKey];
    
    return languageIdentifier;
}

- (NSDictionary *)languageDictionaryStored
{
    NSDictionary *languageDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kIMLanguageDictionaryKey];
    
    return languageDictionary;
}

- (NSDictionary *)languageDictionaryURLStored
{
    NSDictionary *languageDictionaryURL = [[NSUserDefaults standardUserDefaults] objectForKey:kIMLanguageDictionaryURLKey];
    
    return languageDictionaryURL;
}

- (NSArray *)allJSONFileNamesArray
{
    NSArray *array = [self allFileNamesArray];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH[cd] '.json'"];
    NSArray *allJSONFileNamesArray = [array filteredArrayUsingPredicate:predicate];
    
    return allJSONFileNamesArray;
}

- (NSArray *)allFileNamesArray
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *directoryAndFileNames = [fm contentsOfDirectoryAtPath:path
                                                             error:&error];
    
    return directoryAndFileNames;
}

- (void)updateLanguageIdentifier:(NSString *)languageIdentifier
               completionHandler:(void (^)(void))block
{
    //We save the language identifier for next session
    [self saveObject:languageIdentifier forKey:kIMLanguageIdentifierKey];
    self.languageIdentifier = languageIdentifier;
    [self updateDictionaryWithLanguageIdentifier:languageIdentifier];
    
    NSString *callUrlString = [NSString stringWithFormat:@"%@/%@.json", [self languageDictionaryURLStored], languageIdentifier];
    NSURL *url = [NSURL URLWithString:callUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    __block typeof (self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error)
     {
         if(data && !error)
         {
             NSDictionary* languageDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                                  error:&error];
             [self saveObject:languageDictionary forKey:kIMLanguageDictionaryKey];
             weakSelf.languageDictionary = languageDictionary;
         }
         else
         {
             NSLog(@"IMLocalizeManager connection error: %@", error);
         }
         
         if (block)
         {
             block();
         }
     }];
}

- (void)updateLanguageIdentifier:(NSString *)languageIdentifier
{
    [self updateLanguageIdentifier:languageIdentifier
                 completionHandler:nil];
}

- (void)updateDictionaryWithLanguageIdentifier:(NSString *)languageIdentifier
{
    //We save the language dictionary for next session
    NSString *filePath = [[NSBundle mainBundle] pathForResource:languageIdentifier
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    if (data)
    {
        NSDictionary *languageDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
        [self saveObject:languageDictionary forKey:kIMLanguageDictionaryKey];
        self.languageDictionary = languageDictionary;
    }
}

- (void)saveObject:(id)objectToSave forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:objectToSave forKey:key];
}

#pragma mark - Localization

NSString *IMLocalize(NSString *defaultString)
{
    NSString *translatedString = [[IMLocalizeManager shared] languageValueForKeyPath:defaultString];
    
    if (!translatedString || ![translatedString isKindOfClass:[NSString class]])
    {
        IMRecordMissingTranslation(defaultString);
        translatedString = defaultString;
    }
    
    return translatedString;
}

- (id)languageValueForKeyPath:(NSString *)key
{
    return [self.languageDictionary valueForKeyPath:key];
}

void IMRecordMissingTranslation(NSString *defaultString)
{
    //We must keep track of missing translations in order to create them afterwards
    if (!_missingTranslations)
    {
        _missingTranslations = [NSMutableDictionary dictionary];
    }
    
    [_missingTranslations setValue:defaultString forKeyPath:defaultString];
}

#pragma mark -

+ (NSDictionary *)missingTranslations
{
    return _missingTranslations;
}

#pragma mark -

@end
