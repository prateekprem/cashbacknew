//
//  JRFloatLabelTextField.h
//  jarvis-auth-ios
//
//  Created by Abhinav Kumar Roy on 09/04/19.
//

#import <Foundation/Foundation.h>
#import "JVFloatLabeledTextField.h"

NS_ASSUME_NONNULL_BEGIN

@class JRFloatLabeledTextField;

@protocol JRFloatLabeledTextFieldDelegate <NSObject>
-(void)textFieldDidDeleteButtonPressed:(JRFloatLabeledTextField *)textField;
@end

@interface JRFloatLabeledTextField : JVFloatLabeledTextField

@property (nonatomic,weak) NSObject<JRFloatLabeledTextFieldDelegate> *jRFloatLabeledTextFieldDelegate;

- (void)setPlaceHolder:(NSString *)placeholder :(NSString *)floatingTitle;
- (void)setPlaceHolderTextWithFontAndColour:(NSString *)placeholder :(UIFont *)font : (UIColor *)color;
- (void)setFloatingTextWithFontAndColour:(NSString *)floatingTitle :(UIFont *)font : (UIColor *)color;
- (void)layoutSubviews;
- (CGRect)clearButtonRectForBounds:(CGRect)bounds;
- (void)deleteBackward;

@end


NS_ASSUME_NONNULL_END
