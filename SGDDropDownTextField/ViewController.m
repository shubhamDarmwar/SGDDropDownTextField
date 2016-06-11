//
//  ViewController.m
//  SGDDropDownTextField
//
//  Created by Shbham Daramwar on 10/06/16.
//  Copyright © 2016 Shubham Daramwar. All rights reserved.

#import "ViewController.h"

@interface ViewController ()<SGDDropDownTextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dropDownTextField.dropDownlist = [[NSMutableArray alloc]
                                           initWithObjects:@"Element 1",
                                           @"Element 2",@"Element 3",
                                           @"Element 4",@"Element 5",
                                           @"Element 6", nil];
    self.textFieldWithUpSidedDropDown.dropDownlist = [[NSMutableArray alloc]
                                                     initWithObjects:@"Element 1",
                                                     @"Element 2",@"Element 3",
                                                     @"Element 4",@"Element 5",
                                                     @"Element 6", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Mark - Button Action

- (IBAction)setError:(UISwitch *)sender {
    self.dropDownTextField.error = sender.on;
}

#pragma Mark SGDDropDownTextField Delegates

-(BOOL)textFieldShouldReturn:(SGDDropDownTextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(SGDDropDownTextField *)textField{
    if (textField==self.textFieldWithoutDropDown ||
        textField == self.textFieldWithDatePicker || textField == self.textFieldWithoutDropdownAndSuggetion) {
        return YES;
    }
    return NO;
}

-(BOOL)textField:(SGDDropDownTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.textFieldWithoutDropDown ||
        textField == self.textFieldWithDatePicker || textField == self.textFieldWithoutDropdownAndSuggetion ) {
        return YES;
    }
    return NO;
}

-(void)textFieldDidEndEditing:(SGDDropDownTextField *)textField{
    if (textField.text.length == 0) {
        textField.error = YES;
    }else{
        textField.error = NO;
    }
}

@end
