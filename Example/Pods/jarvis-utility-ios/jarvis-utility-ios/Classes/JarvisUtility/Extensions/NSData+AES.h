//
//  NSData+AES.h
//  AESEncryptionDemo
//

//

#import <Foundation/Foundation.h>

@interface NSData (AES)
- (NSData *)AES128EncryptWithKey:(NSString *)key;
- (NSData *)AES128DecryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key withIv:(NSString *)iv;
- (NSData *)AES256EncryptWithKey:(NSString *)key withIv:(NSString *)iv;
- (NSData *)AES256DecryptWithKeyUsingECB:(NSString *)key withIv:(NSString *)iv;
- (NSData *)AES256EncryptWithKeyUsingECB:(NSString *)key withIv:(NSString *)iv;
- (NSData *)AES256EncryptWithDataKeyUsingECB:(NSData *)key withIv:(NSData *)iv;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;
- (NSString *)base64EncodingWithLineLength:(NSUInteger)lineLength;

- (BOOL)hasPrefixBytes:(const void *)prefix length:(NSUInteger)length;
- (BOOL)hasSuffixBytes:(const void *)suffix length:(NSUInteger)length;

@end
