//
//  FSKeyboardAvoidingUIView.m
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSKeyboardAvoidingUIView.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface FSKeyboardAvoidingUIView ()
{
    CGFloat    _priorY;
    BOOL            _priorYSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGRect  _originRect;
}
- (UIView*)findFirstResponderBeneathView:(UIView*)view;
- (UIEdgeInsets)contentInsetForKeyboard;
- (CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space;
- (CGRect)keyboardRect;
@end

@implementation FSKeyboardAvoidingUIView

- (void)setup {
    _priorYSaved = NO;
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(id)initWithFrame:(CGRect)frame {
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    [self setup];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self setup];
    return self;
}

-(void)awakeFromNib {
    [self setup];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self findFirstResponderBeneathView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    _keyboardRect = [[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardVisible = YES;
    
    UIView *firstResponder = [self findFirstResponderBeneathView:self];
    if ( !firstResponder ) {
        // No child view is the first responder - nothing to do here
        return;
    }
    
    if (!_priorYSaved) {
        _priorY = self.frame.origin.y;
        _priorYSaved = YES;
    }
    
    // Shrink view's inset by the keyboard's height, and scroll to show the text field/view being edited
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    NSLog(@"x:%f,y:%f,height:%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.height);
    NSLog(@"keyboard y:%f,height:%f",_keyboardRect.origin.y,_keyboardRect.size.height);
    UIView *superV = self.superview;
    CGFloat superOriginY = self.frame.origin.y;
    CGFloat superHeight = self.frame.size.height;
    if (superV)
    {
        superOriginY = superV.frame.origin.y;
        superHeight = superV.frame.size.height;
    }
    self.frame =CGRectMake(self.frame.origin.x,superHeight -_keyboardRect.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height); //CGRectMake(self.frame.origin.x, _keyboardRect.origin.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    _keyboardRect = CGRectZero;
    _keyboardVisible = NO;
    UIView *firstResponder = [self findFirstResponderBeneathView:self];
    if ( !firstResponder ) {
        // No child view is the first responder - nothing to do here
        return;
    }

    // Restore dimensions to prior size
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
      self.frame = CGRectMake(self.frame.origin.x, _priorY, self.frame.size.width, self.frame.size.height);
    _priorYSaved = NO;
    [UIView commitAnimations];
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}


@end
