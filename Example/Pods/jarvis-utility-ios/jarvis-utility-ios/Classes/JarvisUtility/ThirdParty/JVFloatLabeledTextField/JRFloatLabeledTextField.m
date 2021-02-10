//
//  JRFloatLabelTextField.m
//  jarvis-auth-ios
//
//  Created by Abhinav Kumar Roy on 09/04/19.
//

#import "JRFloatLabeledTextField.h"

@interface JRFloatLabeledTextField ()
@property (nonatomic,strong) NSString *floatingText;
@property (nonatomic,strong) NSString *placeHolderText;
@end

@implementation JRFloatLabeledTextField

- (void)setPlaceHolder:(NSString *)placeholder :(NSString *)floatingTitle{
    self.placeHolderText = placeholder;
    super.placeholder = placeholder;
    self.floatingText = floatingTitle;
}

- (void)setPlaceHolderTextWithFontAndColour:(NSString *)placeholder :(UIFont *)font : (UIColor *)color{
    self.placeHolderText = placeholder;
    super.placeholder = placeholder;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
    self.font = font;
}

- (void)setFloatingTextWithFontAndColour:(NSString *)floatingTitle :(UIFont *)font : (UIColor *)color{
    [super setFloatingLabelTextColor:color];
    [super setFloatingLabelFont: font];
    self.floatingText = floatingTitle;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if([super floatingLabel].alpha == 0){
        [super setPlaceholder:_placeHolderText];
    }else{
        [super setPlaceholder:_floatingText];
    }
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds{
    CGRect rect = [super clearButtonRectForBounds:bounds];
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y + 7, rect.size.width, rect.size.height);
    return newRect;
}

- (void)deleteBackward{
    [super deleteBackward];
    id <JRFloatLabeledTextFieldDelegate> delegate = _jRFloatLabeledTextFieldDelegate;
    if(delegate != nil && [delegate conformsToProtocol:@protocol(JRFloatLabeledTextFieldDelegate)] && [delegate respondsToSelector:@selector(textFieldDidDeleteButtonPressed:)]){
        
        [delegate textFieldDidDeleteButtonPressed:self];
    }
}

@end
