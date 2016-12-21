//
//  ViewController.m
//  ScrollView+Keyboard
//
//  Created by Palade Timotei on 12/21/16.
//  Copyright © 2016 Timotei Alexandru Palade. All rights reserved.
//

#import "ViewController.h"
#import "TwoLevelsDeep.h"

@interface ViewController () <SimpleProtocol,UITextFieldDelegate>
{
    CGFloat originalContentHeight;
    UITextField *currentActiveTextField;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    originalContentHeight       = 0.0f;
    currentActiveTextField    = nil;
    
    //Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UITextField *textFieldOne = [self giveMeATextField];
    textFieldOne.delegate = self;
    [self addViewToScrollView:textFieldOne padding:self.view.frame.size.height / 1.8];
    
    TwoLevelsDeep * twoLevelsDeepView = [[TwoLevelsDeep alloc]init];
    twoLevelsDeepView.delegate = self;
    [self addViewToScrollView:twoLevelsDeepView padding:10];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield init

-(UITextField*)giveMeATextField{
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 55, 30)];
    textField.borderStyle  = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor lightGrayColor];
    return textField;
}

#pragma mark - Keyboard Notifications

-(void)willShowKeyboard:(NSNotification*)notification{
    
    CGRect keyboardRect = [[notification.userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"]CGRectValue];
    CGSize keyboardSize = keyboardRect.size;
    
    if (!currentActiveTextField) {
        return;
    }
    
    CGPoint halfPointOnScreenWithKeyboard = CGPointMake(0, (self.view.frame.size.height - keyboardSize.height)/2);
    CGPoint currentOriginTextField        = [self currentOriginForView:currentActiveTextField];
    
    CGFloat delta = currentOriginTextField.y - halfPointOnScreenWithKeyboard.y;
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, originalContentHeight + keyboardSize.height)];
    
    //Use this when only the textfields below halfPointOnScreenWithKeyboard should be lifted
//    if (delta > 0) {
//        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + delta)];
//    }
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + delta)];
    
}

-(void)didHideKeyboard:(NSNotification*)notification{
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, originalContentHeight)];
    currentActiveTextField = nil;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    currentActiveTextField = textField;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Simple Protocol

-(void)activeTextField:(UITextField *)textField{
    currentActiveTextField = textField;
}

#pragma mark - Util Scroll View

-(void)addViewToScrollView:(UIView*)view padding:(CGFloat)padding{
    
    static CGFloat yOffset  = 0.0f;
    
    CGSize  viewSize                = view.bounds.size;
    CGSize  scrollViewSize          = self.scrollView.frame.size;
    CGSize  scrollViewContentSize   = self.scrollView.contentSize;
    
    CGFloat xOrigin = view.frame.origin.x > 0 ? view.frame.origin.x : 0;
    
    CGFloat viewWidth = view.frame.size.width > 0 ? view.frame.size.width : scrollViewSize.width;
    
    [view setFrame:CGRectMake(xOrigin, yOffset + padding, viewWidth, viewSize.height)];
    
    yOffset += padding + viewSize.height;
    
    CGFloat width = scrollViewContentSize.width > viewSize.width ? scrollViewContentSize.width : viewSize.width;
    [self.scrollView addSubview:view];
    [self.scrollView setContentSize:CGSizeMake(width, scrollViewContentSize.height + viewSize.height + padding)];
    
    originalContentHeight += viewSize.height + padding;
}

-(void)removeViewFromScrollView:(UIView*)view padding:(CGFloat)padding{
    
    CGSize contentSize = self.scrollView.contentSize;
    CGSize viewSize    = view.bounds.size;
    
    [view removeFromSuperview];
    [self.scrollView setContentSize:CGSizeMake(contentSize.width, contentSize.height - viewSize.height - padding)];
    
    originalContentHeight -= (viewSize.height + padding);
}

#pragma mark - Util Origin

-(CGPoint)currentOriginForView:(UIView*)view{ //by View I mean self.view
    
    CGPoint absoluteOrigin = [self originForView:view];
    CGPoint offset         = self.scrollView.contentOffset;
    
    return [self substractPoint:offset fromPoint:absoluteOrigin];
}

-(CGPoint)originForView:(UIView*)view{ //origin in self.view - don't pass in self.view 
    return [self recursive:view];
}

-(CGPoint)recursive:(UIView*)view{
    if ([view.superview isEqual:self.view]) {
        return view.frame.origin;
    }
    return [self addPoint:view.frame.origin andPoint:[self recursive:view.superview]];
}

-(CGPoint)addPoint:(CGPoint)point1 andPoint:(CGPoint)point2{
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

-(CGPoint)substractPoint:(CGPoint)point1 fromPoint:(CGPoint)point2{
    return CGPointMake(point2.x - point1.x, point2.y - point1.y);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
