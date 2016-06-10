//
//  DropdownTableViewCell.m
//  SGDDropDownTextField
//
//  Created by Laxman Murugappan on 5/17/16.
//  Copyright © 2016 EmpoweringVisions. All rights reserved.
//

#import "DropdownTableViewCell.h"

@implementation DropdownTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(self.frame.origin.x + 3, self.textLabel.frame.origin.y, self.frame.size.width - 3, self.textLabel.frame.size.height);
    
//    NSLog(@"cell frame %@",self.frame);
    
}

@end
