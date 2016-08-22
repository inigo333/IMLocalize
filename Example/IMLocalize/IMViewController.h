//
//  IMViewController.h
//  IMLocalize
//
//  Created by Inigo Mato on 08/22/2016.
//  Copyright (c) 2016 Inigo Mato. All rights reserved.
//

@import UIKit;

@interface IMViewController : UIViewController < UIPickerViewDelegate, UIPickerViewDataSource >

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;

@end
