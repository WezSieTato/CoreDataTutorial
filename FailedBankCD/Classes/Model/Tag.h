//
//  Tag.h
//  FailedBankCD
//
//  Created by Marcin Stepnowski on 01/12/14.
//  Copyright (c) 2014 weblify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FailedBankDetails;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *bankDetails;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addBankDetailsObject:(FailedBankDetails *)value;
- (void)removeBankDetailsObject:(FailedBankDetails *)value;
- (void)addBankDetails:(NSSet *)values;
- (void)removeBankDetails:(NSSet *)values;

@end
