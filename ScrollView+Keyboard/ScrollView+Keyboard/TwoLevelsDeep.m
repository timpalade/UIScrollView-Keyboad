//
//  TwoLevelsDeep.m
//  ScrollView+Keyboard
//
//  Created by Palade Timotei on 12/21/16.
//  Copyright © 2016 Timotei Alexandru Palade. All rights reserved.
//

#import "TwoLevelsDeep.h"

@implementation TwoLevelsDeep


-(id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"Levels" owner:self options:nil] objectAtIndex:0];
    
    if (self) {
        _textField.delegate = self;
    }
    
    return self;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(activeTextField:)]) {
        [self.delegate activeTextField:textField];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
