//
//  IMViewController.m
//  IMLocalize
//
//  Created by Inigo Mato on 08/22/2016.
//  Copyright (c) 2016 Inigo Mato. All rights reserved.
//

#import "IMViewController.h"

@import IMLocalize;
#import "IMLocalize.h"

@interface IMViewController ()

@end

@implementation IMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Setup picker view
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    
    //Setup initial language selected in picker view
    NSArray *allJSONFileNamesArray = [[IMLocalizeManager shared] allJSONFileNamesArray];
    NSString *jsonFileName = [NSString stringWithFormat:@"%@.json",[[IMLocalizeManager shared] languageIdentifierStored]];
    NSInteger languageIndex = [allJSONFileNamesArray indexOfObject:jsonFileName];
    [self.pickerView selectRow:languageIndex inComponent:0 animated:NO];
    
    [self updateLocalizedItems];
}

#pragma mark - Localization
- (void)updateLocalizedItems
{
    //text
    self.label.text = IMLocalize(@"hello_world_tag_online");
    //self.label.text = IMLocalize(@"home_navigation_welcome_tag");

    //images
    NSString *imageUrl = [NSString stringWithFormat:@"https://raw.githubusercontent.com/inigo333/IMLocalize/master/json_online/image1_%@.jpg", [[IMLocalizeManager shared] languageIdentifierStored]];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       self.imageView.image = [UIImage imageWithData:imageData];
                   });
}

#pragma mark - UIPickerView delegate+source methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Change Language to the selected one
    NSString *languageIdentifier = [[[[IMLocalizeManager shared] allJSONFileNamesArray] objectAtIndex:row] substringToIndex:2];
    [[IMLocalizeManager shared] updateLanguageIdentifier:languageIdentifier
                                                    completionHandler:^
     {
         [self updateLocalizedItems];
     }];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[[IMLocalizeManager shared] allJSONFileNamesArray] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[[IMLocalizeManager shared] allJSONFileNamesArray] objectAtIndex:row];
}

#pragma mark -

@end
