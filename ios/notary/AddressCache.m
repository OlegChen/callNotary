//
//  AddressCache.m
//  notary
//
//  Created by 肖 喆 on 13-4-1.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "AddressCache.h"
#import "NSString+TKUtilities.h"
#import "SearchCoreManager.h"

#import "Address_Sqlite_Tool.h"

//当有多个电话的时候 由于实体RecordID相同 导致搜索不好用
//所以设置一个大值区分RecordID+20000 
#define DEFAULT_TMP_RecordID   20000

@interface AddressCache()




@end

static AddressCache * instance;
@implementation AddressCache

+ (id)sharedInstance
{
    if (nil == instance) {
        instance = [[[self class] alloc]init];
    }
    return instance;
}
//当地址簿增加或者减少的时候会发上变化与_contactPersonCount值不同 修改不会
- (int)getAddressCount
{
    ABAddressBookRef addressBooks = [self initABAddressBookRef];
    
    NSArray * array = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    NSLog(@"联系人数量 %lu",(unsigned long)array.count);
    
    return array.count;
}
- (ABAddressBookRef)initABAddressBookRef{
    
   
    
    if (nil == _cardDic) {
        _cardDic = [[ NSMutableDictionary alloc] init];
    }
    if (nil == _listContent) {
        _listContent = [[NSMutableArray alloc] init];
    }
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    ABAddressBookRef addressBooks = nil;
    
//    if(version >= 6.0f) {
//
//        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
//        //等待用户许可
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//        ABAddressBookRequestAccessWithCompletion(addressBooks,
//                                                 ^(bool granted, CFErrorRef error)
//                                                 {
//                                                     dispatch_semaphore_signal(sema);
//                                                 });
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//
//
//    }
//    else if (version < 6.0f) {
//
//        addressBooks = ABAddressBookCreate();
//
//    }
    
    addressBooks = ABAddressBookCreateWithOptions(NULL, NULL); ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
        if (granted) {
            NSLog(@"Authorized");
            CFRelease(addressBooks);
            
        }else{
            NSLog(@"Denied or Restricted");
            
        }});
    return addressBooks;
}

- (void)initAddressBook
{
 
    //通讯录数组
    NSMutableArray *addressArr = [NSMutableArray array];
    
    @try {
    
    
    _contactPersonCount = 0;
    [_listContent removeAllObjects];
    [_cardDic removeAllObjects];
    
    ABAddressBookRef addressBooks = [self initABAddressBookRef];
    
    NSMutableArray * addressBookTemp = [NSMutableArray array];
   
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
         NSLog(@"--addressBookTemp%@",allPeople);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
        
    
    [Address_Sqlite_Tool setupAddressSqlite];
        
        
    for (NSInteger i = 0; i < nPeople; i++)
    {
        
        AddressCard * card = [[AddressCard alloc] init];
        
        //用来解决 显示两个号码的问题
        AddressCard * card2 = [[AddressCard alloc] init];
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
         NSLog(@"--person%@",person);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = ( __bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        if (nameString != nil) {
            NSLog(@"-----nameString:%@",nameString);
            card.name = nameString;
            card.recordID = (int)ABRecordGetRecordID(person);
            card.rowSelected = NO;
            
            card2.name = nameString;
            card2.recordID = (int)ABRecordGetRecordID(person) + 20000;
            card2.rowSelected = NO;
        }
        

        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
           // kABPersonEmailProperty
        };
        
        
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        NSLog(@"multiPropertiesTotal----%ld",(long)multiPropertiesTotal);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++)
        {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                //调试用的临时变量
//                NSString * v = [(__bridge NSString *)value telephoneWithReformat];
//                
//                NSLog(@"name:%@ k值%d %@",card.name,k,v);
                //这里k 原来用的是j
                switch (k) {
                    case 0: {// Phone number
                        NSLog(@"---[(__bridge NSString *)value telephoneWithReformat]-%@",[(__bridge NSString *)value telephoneWithReformat]);
                        card.tel = [(__bridge NSString *)value telephoneWithReformat];
                        
                        card.tel = [[card.tel componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
#pragma - mark 保存 数据库
                        
//                        if ([card.name isEqualToString:@"李果"]) {
//
//                        }
                        
                        //[Address_Sqlite_Tool insertAddressWithName:card.name phoneNum:card.tel];
                        
                        [addressArr addObject:card];
                        
                        
                        break;
                    }
                    case 1: {// Email
                        //                        card.email = ( __bridge NSString*)value;
                        NSLog(@"---22222[(__bridge NSString *)value telephoneWithReformat]-%@",[(__bridge NSString *)value telephoneWithReformat]);
                        NSString * phone2 = [(__bridge NSString *)value telephoneWithReformat];
                        if (phone2 != nil ){
                           card2.tel = phone2;
                        }
                        break;
                        
                    }
                    case 2: {// Email
                        //                        card.email = ( __bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
            
            

            
            
        }
        
        
        [addressBookTemp addObject:card];
        _contactPersonCount += 1;
        
        

        
        

        //        [addressBook release];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
        
//        NSArray * tels = nil;
//        if (card.tel != nil) {
//            tels = [NSArray arrayWithObject:card.tel];
//        }
//        NSArray * tels2 = nil;
//        if (card2.tel != nil) {
//            
//            [addressBookTemp addObject:card2];
//            
//            tels2 = [NSArray arrayWithObject:card2.tel];
//            
//            //phone2
//            [[SearchCoreManager share] AddContact:[NSNumber numberWithInteger:card2.recordID] name:card2.name phone:tels2];
//            [self.cardDic setObject:card2 forKey:[NSNumber numberWithInteger:card2.recordID]];
//        }
//      
//        [[SearchCoreManager share] AddContact:[NSNumber numberWithInteger:card.recordID] name:card.name phone:tels];
//        [self.cardDic setObject:card forKey:[NSNumber numberWithInteger:card.recordID]];
//        
//        
       
    }//end for
    
    
    // Sort data
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (AddressCard *addressBook in addressBookTemp) {
        NSInteger sect = [theCollation sectionForObject:addressBook
                                collationStringSelector:@selector(name)];
        addressBook.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (AddressCard *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        //NSLog(@"------sectionArray:%@",sectionArray);
            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
            [_listContent addObject:sortedSection];
       
    
    }
        

        
        
    }
   @catch (NSException *exception) {
        NSLog(@"-------exception:%@",exception);
    }
    @finally {
        
    }

    NSLog(@"_contactPersonCount %d",_contactPersonCount);
    NSLog(@"联系人 %d",_listContent.count);
    NSLog(@"地址 %d",_cardDic.count);
    
    
    
    //批量插入
    
    [Address_Sqlite_Tool insertData:addressArr];
    
}

@end
