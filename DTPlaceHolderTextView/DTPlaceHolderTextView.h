/*
 *
 * DTPlaceHolderTextView.h
 *
 */


#import <Foundation/Foundation.h>

@interface DTPlaceHolderTextView : UITextView {
}

@property (nonatomic, strong) UILabel  *placeHolderLabel;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) UIColor  *placeHolderColor;

@end
