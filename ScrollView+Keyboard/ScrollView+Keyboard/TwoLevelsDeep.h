//
//  TwoLevelsDeep.h
//  ScrollView+Keyboard
//
//  Created by Palade Timotei on 12/21/16.
//  Copyright © 2016 Timotei Alexandru Palade. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimpleProtocol <NSObject>

-(void)activeTextField:(UITextField*)textField;

@end


@interface TwoLevelsDeep : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) id <SimpleProtocol> delegate;
@end
