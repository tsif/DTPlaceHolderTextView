/*
 *
 * DTPlaceHolderTextView.m
 *
 */


#import "DTPlaceHolderTextView.h"

const NSInteger DTPlaceHolderLabelTag = 55233;

@interface DTPlaceHolderTextView () {
    
    NSString *placeholder;
    UIColor  *placeholderColor;
    UILabel  *placeHolderLabel;
}

-(void)_textChanged:(NSNotification*)notification;

@end

@implementation DTPlaceHolderTextView

@synthesize placeHolderLabel;
@synthesize placeHolder;
@synthesize placeHolderColor;

#pragma mark - LIFECYCLE

- (id)initWithFrame:(CGRect)frame {
    
    if((self = [super initWithFrame:frame])) {
        
        [self setPlaceHolder:@""];
        [self setPlaceHolderColor:[UIColor lightGrayColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setPlaceHolder:@""];
    [self setPlaceHolderColor:[UIColor lightGrayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - PROPERTIES

- (void)setText:(NSString*)text {
    [super setText:text];
    [self _textChanged:nil];
}

#pragma mark - NOTIFICATIONS

- (void)_textChanged:(NSNotification *)notification {
    
    CGRect  line     = [self caretRectForPosition:self.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height - (self.contentOffset.y + self.bounds.size.height - self.contentInset.bottom - self.contentInset.top);
    
    if(overflow > 0) {
        
        // via http://stackoverflow.com/a/19298022/9771
        
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        
        CGPoint offset  = self.contentOffset;
        offset.y       += overflow + 7; // leave 7 pixels margin
        
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:0.2f animations:^{
            [self setContentOffset:offset];
        }];
    }
    
    if([[self placeHolder] length] == 0) {
        return;
    }
    
    if([[self text] length] == 0) {
        [[self viewWithTag:DTPlaceHolderLabelTag] setAlpha:1.0f];
    
    } else {
    
        [[self viewWithTag:DTPlaceHolderLabelTag] setAlpha:0.0f];
    }
}

#pragma mark - DRAWING

- (void)drawRect:(CGRect)rect {
    
    if([[self placeHolder] length] > 0) {
        
        if(placeHolderLabel == nil) {
           
            placeHolderLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 8.0f, self.bounds.size.width - 16.0f, 0.0f)];
            placeHolderLabel.lineBreakMode   = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines   = 0;
            placeHolderLabel.font            = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor       = self.placeHolderColor;
            placeHolderLabel.alpha           = 0.0f;
            placeHolderLabel.tag             = DTPlaceHolderLabelTag;
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeHolder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if([[self text] length] == 0 && [[self placeHolder] length] > 0) {
        [[self viewWithTag:DTPlaceHolderLabelTag] setAlpha:1];
    }
    
    [super drawRect:rect];
}

#pragma mark - CLEANUP CREW

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#if __has_feature(objc_arc)
#else
    [placeHolderLabel release]; placeHolderLabel = nil;
    [placeholderColor release]; placeholderColor = nil;
    [placeholder release]; placeholder = nil;
    [super dealloc];
#endif
    
}

@end
