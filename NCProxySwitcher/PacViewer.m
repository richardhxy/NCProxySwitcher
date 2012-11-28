//
//  PacViewer.m
//  NCProxySwitcher
//
//  Created by ding_yuanyi on 12-11-26.
//
//

#import "PacViewer.h"
#import <QuartzCore/QuartzCore.h>

#define kPacViewerRectEditing   CGRectMake(self.frame.origin.x, 20, self.frame.size.width, 244)

#define kPacViewerSize          self.bounds.size

#define kTextViewRect           CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 35)
#define kCloseBtnRect           CGRectMake(0, self.bounds.size.height - 35, self.bounds.size.width, 35)
#define kBgViewRect             CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 35)

@implementation PacViewer
@synthesize bgView;
@synthesize textView;
@synthesize closeBtn;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.autoresizesSubviews = YES;
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kPacViewerSize.width, 0)];
        textView.delegate = self;
        textView.alpha = 0;
        textView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        textView.textColor = [UIColor whiteColor];
        
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = YES;
//        textView.layer.shadowOffset = CGSizeMake(2, 2);
//        textView.layer.shadowOpacity = 0.6;
//        textView.layer.shadowRadius = 10;
//        textView.layer.shadowColor = [UIColor blackColor].CGColor;
  
        [self addSubview:textView];
        
        closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kPacViewerSize.height - 35, kPacViewerSize.width, 0)];
        closeBtn.alpha = 0;
        closeBtn.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        bgView = [[UIView alloc] initWithFrame:kBgViewRect];
        bgView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        [UIView animateWithDuration:0.3f animations:^{
            textView.alpha = 1;
            textView.frame = kTextViewRect;
        } completion:^(BOOL finished){
            if (finished)
            {
                [self insertSubview:bgView atIndex:0];
                [UIView animateWithDuration:0.3f animations:^{
                    closeBtn.alpha = 1;
                    closeBtn.frame = kCloseBtnRect;
                }];
            }
        }];
    }    
    
    return self;
}

- (void)dealloc
{
    [bgView release];
    [textView release];
    [closeBtn release];
    [super dealloc];
}

- (void)close:(UIButton *)sender
{
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated
{
    if ([textView isFirstResponder])
    {
        [textView resignFirstResponder];
    }
    
    NSLog(@"dissmissing.......");
    
    if (animated)
    {
        [UIView animateWithDuration:0.15f animations:^{
            CGRect closeBtnRect = closeBtn.frame;
            closeBtnRect.size.height -= 35;
            closeBtn.alpha = 0;
            closeBtn.frame = closeBtnRect;
        } completion:^(BOOL finished){
            if (finished)
            {
                [UIView animateWithDuration:0.2f animations:^{
                    textView.alpha = 0;
                    textView.frame = CGRectMake(0, 0, kPacViewerSize.width, 0);
                    bgView.alpha = 0;
                    bgView.frame = CGRectMake(0, 0, kPacViewerSize.width, 0);
                } completion:^(BOOL finished){
                    [delegate pacViewerWillDismiss];
                    [self removeFromSuperview];
                }];
            }
        }];
    }
    else
    {
        [delegate pacViewerWillDismiss];
        [self removeFromSuperview];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = kPacViewerRectEditing;
        self.textView.frame = kTextViewRect;
        bgView.frame = kBgViewRect;
        closeBtn.frame = kCloseBtnRect;
    } completion:^(BOOL finished){
        if (finished)
        {
            self.userInteractionEnabled = YES;
        }
    }];
}

@end
