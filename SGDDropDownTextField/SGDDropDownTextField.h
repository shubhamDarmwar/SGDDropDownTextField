//
//  SGDDropDownTextField.h
//  SGDDropDownTextField
//
//  Created by Shbham Daramwar on 10/06/16.
//  Copyright © 2016 Shubham Daramwar. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "DropDownTable.h"
#import "DropdownTableViewCell.h"

@class DropdownTableViewCell;
@class SGDDropDownTextField;
IB_DESIGNABLE
@protocol SGDDropDownTextFieldDelegate <NSObject>
@optional

-(BOOL)textField:(SGDDropDownTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(void)textFieldDidBeginEditing:(SGDDropDownTextField *)textField;
-(void)textFieldDidEndEditing:(SGDDropDownTextField *)textField;
-(BOOL)textFieldShouldBeginEditing:(SGDDropDownTextField *)textField;
-(BOOL)textFieldShouldClear:(SGDDropDownTextField *)textField;
-(BOOL)textFieldShouldEndEditing:(SGDDropDownTextField *)textField;
-(BOOL)textFieldShouldReturn:(SGDDropDownTextField *)textField;
-(void)textFieldDidSelectDopdown:(SGDDropDownTextField *)textField withIndex: (int )index;

@end

@interface SGDDropDownTextField :  UITextField< UITextFieldDelegate >

@property (nonatomic, retain) IBInspectable UIColor * bottomColor;
@property (nonatomic ,retain) IBInspectable NSString * suggetionText;
@property (nonatomic,retain) IBInspectable UIColor * suggetionColor;
@property (nonatomic)IBInspectable BOOL error;
@property (nonatomic) IBInspectable BOOL isDropdown;
@property (nonatomic) IBInspectable BOOL isDownSided;
@property (nonatomic) IBInspectable BOOL isDatePicker;
@property (nonatomic,retain) NSString * dateFormat;
@property (nonatomic,retain) NSMutableArray * dropDownlist;
@property(weak,nonatomic) IBOutlet id <SGDDropDownTextFieldDelegate> SGDDropDownTextFieldDelegate;
@property(nonatomic, retain) UIDatePicker *datePicker;
//+(void)removeDropdown;


@end
