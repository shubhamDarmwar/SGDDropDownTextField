//
//  DropDownTable.m
//  SGDDropDownTextField
//
//  Created by Shbham Daramwar on 10/06/16.
//  Copyright © 2016 Shubham Daramwar. All rights reserved.

#import "DropDownTable.h"
static DropDownTable * sharedInstance = nil;
@interface DropDownTable(){
}

@end
@implementation DropDownTable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

}*/


+(DropDownTable *)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL]init];
        sharedInstance.background = [[UIView alloc]init];
        sharedInstance.background.backgroundColor = [UIColor whiteColor];
        sharedInstance.background.layer.shadowOffset = CGSizeMake(0, 10);
        sharedInstance.background.layer.shadowRadius = 4;
        sharedInstance.background.layer.shadowOpacity = 0.5;
        sharedInstance.background.clipsToBounds = NO;
        sharedInstance.bounces = NO;
        
    
    }
    
    
    
    
    return sharedInstance;
}

@end
