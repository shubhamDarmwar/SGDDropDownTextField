//
//  SGDDropDownTextField.m
//  SGDDropDownTextField
//
//  Created by Shbham Daramwar on 10/06/16.
//  Copyright © 2016 Shubham Daramwar. All rights reserved.
//

#import "SGDDropDownTextField.h"
#import <AudioToolbox/AudioToolbox.h>
static CGRect mainFrame1;
IB_DESIGNABLE
const int labelPadding = 3;
@interface SGDDropDownTextField ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel * customText;
    UILabel * customplaceHolder;
    UILabel * suggetionLabel;
    UIView * backView;
    UIButton * removeButton;
    
    DropdownTableViewCell * cell ;
    UIBezierPath * trianglePath,*linePath ;
    NSIndexPath  *selectedIndexPath;
}
@property (nonatomic , retain)  NSString * ctext;
@property (nonatomic, retain)  UIColor * cTextColor;
@property (nonatomic,retain)  NSString * cplaceholder ;
@property(nonatomic,retain)  DropDownTable * dropdownTable;

@end

@implementation SGDDropDownTextField
@synthesize dropdownTable = dropdownTable;

@synthesize SGDDropDownTextFieldDelegate;

-(instancetype)init{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
        
    }
    return self;
}

///@@@@@@@@@@@@@@@@@@ DON'T OVERRIDE THIS METHODE @@@@@@@@@@@@@@@
//-(instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self customInit];
//
//
//    }
//    return self;
//}

-(void)awakeFromNib{
    [self customInit];
}

-(void)customInit{
    self.delegate = self;
    self.borderStyle = UITextBorderStyleNone;
    self.cTextColor = self.textColor ;
    self.ctext = self.text;
    self.textColor = [UIColor clearColor];
    
    customText =[[UILabel alloc]init];
    customplaceHolder = [[UILabel alloc]init];
    suggetionLabel =[[UILabel alloc]init];
    self.dropDownlist = [[NSMutableArray alloc]init];
    trianglePath = [UIBezierPath bezierPath];
    linePath = [UIBezierPath bezierPath];
    selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
    
    UIView * paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelPadding, self.frame.size.height)];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = paddingView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    mainFrame1 = CGRectMake(0, 0, 100, 100);
//    NSLog(@"i == %f",mainFrame1.origin.x);
    self.dateFormat = @"dd MMMM yy";
    [self creatDatePicker];
}


- (void)drawRect:(CGRect)rect {
    
    if (self.placeholder) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor clearColor]}];
    }
    self.textColor = [UIColor clearColor];
    // @@@@@@@@@@ HORIZONTAL LINE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
    
    float mid = CGRectGetHeight(rect)/2;
    [linePath moveToPoint:CGPointMake(0,mid)];//rect.size.height/2)];
    
    [linePath addLineToPoint:CGPointMake( rect.size.width, mid )];
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 1.0;
    if (self.error) {
        lineLayer.strokeColor = self.suggetionColor.CGColor;
        lineLayer.fillColor = self.suggetionColor.CGColor;
    }else{
        lineLayer.strokeColor = self.bottomColor.CGColor;
        lineLayer.fillColor = self.bottomColor.CGColor;
    }
    lineLayer.path = linePath.CGPath;
    [self.layer addSublayer:lineLayer];
    
    // @@@@@@@@@@ TRIANGLE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    float triangleConst = rect.size.height/5 ;
    [trianglePath moveToPoint:CGPointMake(rect.size.width - triangleConst, mid)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width, mid)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width, mid - triangleConst)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width - triangleConst , mid)];
    CAShapeLayer * triangleLayer = [CAShapeLayer layer];
    triangleLayer.lineWidth = 1.0;
    if (self.error) {
        triangleLayer.strokeColor = self.suggetionColor.CGColor;
        triangleLayer.fillColor  = self.suggetionColor.CGColor;
    }else{
        triangleLayer.fillColor = self.bottomColor.CGColor;
        triangleLayer.strokeColor = self.bottomColor.CGColor;
    }
    triangleLayer.path = trianglePath.CGPath ;
    
    if (self.isDropdown) {
        [self.layer addSublayer:triangleLayer];
    }
    
    
    // @@@@@@@@@ CUSTOM PLACEHOLDER @@@@@@@@@@@@@@@@@@@@@@@@@
    
    customplaceHolder.textAlignment = self.textAlignment;
    customplaceHolder.frame = CGRectMake(labelPadding, 0, self.frame.size.width, self.frame.size.height/2 - 1);
    
    
    customplaceHolder.userInteractionEnabled = NO;
    if (self.ctext.length == 0 ) {
        
        customplaceHolder.text = self.placeholder;//self.cplaceholder;
    }else{
        customplaceHolder.text = @"";
    }
    
    
    
    customplaceHolder.textColor = [UIColor grayColor];
    customplaceHolder.backgroundColor = [UIColor clearColor];
    customplaceHolder.font = self.font;
    [self addSubview:customplaceHolder];
    
    //@@@@@@@@@ CUSTOM TEXT @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    customText.textAlignment = self.textAlignment;
    
    // if (self.suggetionText.length != 0) {
    
    customText.frame = CGRectMake(labelPadding, -2,
                                  self.frame.size.width, self.frame.size.height/2);
    
    
    customText.text = self.ctext;
    customText.textColor =self.cTextColor;
    customText.backgroundColor = [UIColor clearColor];
    customText.font = self.font;
    customText.userInteractionEnabled = NO;
    [self addSubview:customText];
    
    // @@@@@@@@@@ TO CUT HALF CURSOR @@@@@@@@@@@@@@@@@@@
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2 + 1,
                                                       self.frame.size.width, self.frame.size.height/2)];
    backView.backgroundColor = self.backgroundColor;
    backView.userInteractionEnabled = NO;
    [self addSubview:backView];
    
    
    //@@@@@@@@ SUGGETION LABLE @@@@@@@@@@@@@@@@@@@@
    
    suggetionLabel.frame = CGRectMake(labelPadding, self.frame.size.height/2 ,
                                      self.frame.size.width, self.frame.size.height/2);
    suggetionLabel.text = self.suggetionText;
    suggetionLabel.textColor = self.suggetionColor;
    suggetionLabel.backgroundColor = [UIColor clearColor];
    suggetionLabel.font = [self.font fontWithSize:self.font.pointSize - 3 ];
    suggetionLabel.hidden = YES;
    suggetionLabel.userInteractionEnabled = NO;
    
    [self addSubview:suggetionLabel];
    if (self.error) {
        suggetionLabel.hidden = NO;
    }else{
        suggetionLabel.hidden = YES;
    }
    
    self.text = self.ctext;
    // @@@@@@@ IF NO SUGGETION @@@@@@@@@@@@@@@@@@
    
    if (self.suggetionText.length == 0) {
        
        
        [linePath removeAllPoints];
        [triangleLayer removeFromSuperlayer];
        [trianglePath removeAllPoints];
        
        float mid = CGRectGetHeight(rect);
        
        customplaceHolder.frame = CGRectMake(labelPadding, 0, self.frame.size.width, self.frame.size.height);
        
        customText.frame = CGRectMake(labelPadding, 0,
                                      self.frame.size.width, self.frame.size.height);
        
        // @@@@@@@@@@ HORIZONTAL LINE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
        
        [linePath moveToPoint:CGPointMake(0,mid)];
        
        [linePath addLineToPoint:CGPointMake( rect.size.width, mid )];
        
        lineLayer.lineWidth = 1.0;
        if (self.error) {
            lineLayer.strokeColor = self.suggetionColor.CGColor;
            lineLayer.fillColor = self.suggetionColor.CGColor;
        }else{
            lineLayer.strokeColor = self.bottomColor.CGColor;
            lineLayer.fillColor = self.bottomColor.CGColor;
        }
        
        lineLayer.path = linePath.CGPath;
        [self.layer addSublayer:lineLayer];
        
        
        // @@@@@@@@@@ TRIANGLE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
        
        float triangleConst = rect.size.height/5 ;
        [trianglePath moveToPoint:CGPointMake(rect.size.width - triangleConst, mid)];
        [trianglePath addLineToPoint:CGPointMake(rect.size.width, mid)];
        [trianglePath addLineToPoint:CGPointMake(rect.size.width, mid - triangleConst)];
        [trianglePath addLineToPoint:CGPointMake(rect.size.width - triangleConst , mid)];
        CAShapeLayer * triangleLayer = [CAShapeLayer layer];
        triangleLayer.lineWidth = 1.0;
        if (self.error) {
            triangleLayer.strokeColor = self.suggetionColor.CGColor;
            triangleLayer.fillColor  = self.suggetionColor.CGColor;
        }else{
            triangleLayer.fillColor = self.bottomColor.CGColor;
            triangleLayer.strokeColor = self.bottomColor.CGColor;
        }
        triangleLayer.path = trianglePath.CGPath ;
        if (_isDropdown) {
            [self.layer addSublayer:triangleLayer];
        }
    }
    
}


#pragma mark - SGDDropDownTextFieldDelegate
#pragma mark -
-(BOOL)textField:(SGDDropDownTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if ([SGDDropDownTextFieldDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
    {
        
        
        bool returnFlag = [SGDDropDownTextFieldDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
        //        returnFlag = YES;
        if (returnFlag) {
            if ([self.text isEqualToString: @""]) {
                self.ctext = string;
            }else{
                self.ctext = [self.ctext stringByAppendingString:string];
            }
            if ([string isEqualToString:@""]) {
                self.ctext = [self.ctext substringToIndex:(self.ctext).length - 1];
            }
            [self setNeedsDisplay];
        }
        return returnFlag;
    }
    
    return NO;
    
}
-(void)textFieldDidBeginEditing:(SGDDropDownTextField *)textField{
    [self setNeedsDisplay];
    
    
    [self presentDropdown];
    if ([SGDDropDownTextFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [SGDDropDownTextFieldDelegate textFieldDidBeginEditing:textField];
    }
}

-(void)textFieldDidEndEditing:(SGDDropDownTextField *)textField{
    if ([SGDDropDownTextFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [SGDDropDownTextFieldDelegate textFieldDidEndEditing:textField];
    }
    UIView * view = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(0,0 , view.frame.size.width, view.frame.size.height);
    }];
}
-(BOOL)textFieldShouldBeginEditing:(SGDDropDownTextField *)textField{
    [self presentDropdown];
    if ([SGDDropDownTextFieldDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [SGDDropDownTextFieldDelegate textFieldShouldBeginEditing:textField];
    }
    
    return NO;
}
-(BOOL)textFieldShouldClear:(SGDDropDownTextField *)textField{
    if ([SGDDropDownTextFieldDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [SGDDropDownTextFieldDelegate textFieldShouldClear:textField];
    }
    return NO;
}
-(BOOL)textFieldShouldEndEditing:(SGDDropDownTextField *)textField{
    if ([SGDDropDownTextFieldDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return  [SGDDropDownTextFieldDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(SGDDropDownTextField *)textField{
    if ([SGDDropDownTextFieldDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        
        bool returnFlag = [SGDDropDownTextFieldDelegate textFieldShouldReturn:textField];
        if (returnFlag) {
            [self resignFirstResponder];
        }
    }
    return YES;
}

-(CGRect)caretRectForPosition:(UITextPosition *)position{
    CGRect originalRect = [super caretRectForPosition:position];
    
    if (self.suggetionText.length != 0) {
        originalRect.origin.y = 0;
    }
    
    return originalRect;
}

#pragma mark
#pragma mark SETTER METHODES
#pragma mark

-(void)setError:(BOOL)error{
    
    if (_error != error) {
        _error = error;
        [self setNeedsDisplay];
    }
}

-(void)setCtext:(NSString *)ctext{
    _ctext = ctext;
    
    [self setNeedsDisplay];
}

-(void)setText:(NSString *)text{
    self.ctext = text;
    super.text = text;
}

-(void)setDropDownlist:(NSMutableArray *)dropDownlist{
    
    _dropDownlist = dropDownlist;
    //    [self createTable];
}

-(void)setIsDatePicker:(BOOL)isDatePicker{
    _isDatePicker = isDatePicker;
    [self creatDatePicker];
}


#pragma mark
#pragma mark DROPDOWN METHODES
#pragma mark


-(void)presentDropdown{
    [self.dropdownTable reloadData];
    mainFrame1 = [self convertRect:self.bounds toView:nil];
    CGRect newFrame = [self convertRect:self.bounds toView:nil];
    ///Table height
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    float maxHeight;
    float minHeight;
    if (self.isDownSided) {
        maxHeight = screenHeight - newFrame.origin.y - newFrame.size.height -20;
        minHeight = 25 * self.dropDownlist.count;
    }else{
        maxHeight = newFrame.origin.y - 20;
        minHeight = 25 * self.dropDownlist.count;
    }
    if (self.dropDownlist.count == 0) {
        minHeight = 0;
    }
    float tableHeight =  fminf(minHeight, maxHeight);
    
    // Y Position
    float Y ;
    if (self.isDownSided) {
        if (self.suggetionText.length == 0) {
            Y= newFrame.origin.y + newFrame.size.height + 1 ;
        }else{
            Y  = newFrame.origin.y + newFrame.size.height/2 +1 ;
        }
    }else{
        Y= newFrame.origin.y - tableHeight ;
    }
    [UIView animateWithDuration:0.2 animations:^{
        if (dropdownTable) {
            dropdownTable.frame = CGRectMake(newFrame.origin.x + newFrame.size.width,Y, 0, 0);
            dropdownTable.background.frame = CGRectMake(newFrame.origin.x +newFrame.size.width,Y, 0, 0);
        }
    }completion:^(BOOL finished){
        [dropdownTable removeFromSuperview];
        [dropdownTable.background removeFromSuperview];
        [removeButton removeFromSuperview];
   
        if (self.dropDownlist.count != 0) {
            dropdownTable = [DropDownTable sharedInstance];
            dropdownTable.backgroundColor = [UIColor orangeColor];
            if (self.isDownSided) {
                dropdownTable.frame = CGRectMake(newFrame.origin.x + newFrame.size.width,Y, 0, 0);
                dropdownTable.background.frame = CGRectMake(newFrame.origin.x + newFrame.size.width ,Y,0, 0);
            }else{
                dropdownTable.frame = CGRectMake(newFrame.origin.x + newFrame.size.width,newFrame.origin.y, 0, 0);
                dropdownTable.background.frame = CGRectMake(newFrame.origin.x + newFrame.size.width ,newFrame.origin.y,0, 0);
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                dropdownTable.frame = CGRectMake(newFrame.origin.x, Y, newFrame.size.width, tableHeight);
                dropdownTable.background.frame = CGRectMake(newFrame.origin.x,Y, newFrame.size.width, tableHeight);
            }];
            dropdownTable.delegate = self;
            dropdownTable.dataSource = self;
            [dropdownTable registerClass:[DropdownTableViewCell class] forCellReuseIdentifier:@"cell"];
            dropdownTable.backgroundColor = [UIColor whiteColor];
            dropdownTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            //@@@@@@@@@@@@@ BACKGROUD BUTTON @@@@@@@@@@@@@@@
            removeButton = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [removeButton addTarget:self action:@selector(hideDropdown) forControlEvents:UIControlEventTouchUpInside];
            [self.superview.window addSubview:removeButton];
            [self.superview.window addSubview:dropdownTable.background];
            [self.superview.window addSubview:dropdownTable];
        }
    }
     ];
}


-(void)hideDropdown{
    CGRect newFrame = [self convertRect:self.bounds toView:nil];
    float Y ;
    if (self.suggetionText.length == 0) {
        Y= newFrame.origin.y + newFrame.size.height + 1 ;
    }else{
        Y  = newFrame.origin.y + newFrame.size.height/2 +1 ;
    }
    
    if (dropdownTable) {
        
        [UIView animateWithDuration:0.2 animations:^{
            dropdownTable.frame = CGRectMake(newFrame.origin.x + newFrame.size.width,Y, 0, 0);
            dropdownTable.background.frame = CGRectMake(newFrame.origin.x + newFrame.size.width,Y, 0, 0);
        }completion:^(BOOL finished){
            [dropdownTable removeFromSuperview];
            [dropdownTable.background removeFromSuperview];
            [removeButton removeFromSuperview];
        }];
    }
}

#pragma mark
#pragma mark TABLEVIEW DELEGATE METHODES
#pragma mark


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dropDownlist.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = (self.dropDownlist)[indexPath.row];
    cell.textLabel.font = self.font;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    if (selectedIndexPath.row == indexPath.row) {
        cell.textLabel.textColor = [UIColor colorWithRed:186/255.f green:34/255.f blue:59/255.f alpha:1];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.ctext = _dropDownlist[indexPath.row];
    selectedIndexPath = [[NSIndexPath alloc]init];
    selectedIndexPath = indexPath;
    if ([self.SGDDropDownTextFieldDelegate respondsToSelector:@selector(textFieldDidSelectDopdown:withIndex:)]) {
        [self.SGDDropDownTextFieldDelegate textFieldDidSelectDopdown:self withIndex:indexPath.row];
    }
    
    [self hideDropdown];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int kHeight = MIN(keyboardSize.height,keyboardSize.width);
    CGRect screemFrame = [UIScreen mainScreen].bounds;
    //    mainFrame1;
    if (mainFrame1.origin.x != 0) {
        float difference = (mainFrame1.origin.y + mainFrame1.size.height) - ( screemFrame.size.height - kHeight);
        
        if (difference > 0) {
            UIView * view = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = CGRectMake(0, - difference , view.frame.size.width, view.frame.size.height);
            }];
        }
    }
}



-(void)creatDatePicker {
    if (self.isDatePicker) {
        self.datePicker = [[UIDatePicker alloc]init];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.inputView = self.datePicker;
        
        UIToolbar * toolBar = [[UIToolbar alloc]init];
        [toolBar sizeToFit];
        UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        done.tintColor = [UIColor grayColor];
        [toolBar setItems:@[ flexible,done] animated:YES];
        self.inputAccessoryView = toolBar;
    }
}

-(void)doneClicked:(UIBarButtonItem *)sender{
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    df.dateFormat = self.dateFormat;
    self.text = [df stringFromDate:self.datePicker.date];
    [self resignFirstResponder];
}


@end
