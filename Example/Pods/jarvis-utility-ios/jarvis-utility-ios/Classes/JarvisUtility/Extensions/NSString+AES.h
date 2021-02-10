//
//  NSString+AES.h
//  AESEncryptionDemo

//

#import <Foundation/Foundation.h>
#import "NSData+AES.h"


@interface NSString (AES)
- (NSString *)AES128EncryptWithKey:(NSString *)key;
- (NSString *)AES128DecryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key andIV:(NSString *)iv;
- (NSString *)AES256EncryptWithKey:(NSString *)key andIV:(NSString *)iv;
- (NSString *)AES256DecryptWithKeyUsingECB:(NSString *)key andIV:(NSString *)iv;
- (NSString *)AES256EncryptWithKeyUsingECB:(NSString *)key andIV:(NSString *)iv;

@end
