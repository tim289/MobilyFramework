/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 Mobily TEAM                   */
/*                                                  */
/* Permission is hereby granted, free of charge,    */
/* to any person obtaining a copy of this software  */
/* and associated documentation files               */
/* (the "Software"), to deal in the Software        */
/* without restriction, including without           */
/* limitation the rights to use, copy, modify,      */
/* merge, publish, distribute, sublicense,          */
/* and/or sell copies of the Software, and to       */
/* permit persons to whom the Software is furnished */
/* to do so, subject to the following conditions:   */
/*                                                  */
/* The above copyright notice and this permission   */
/* notice shall be included in all copies or        */
/* substantial portions of the Software.            */
/*                                                  */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT        */
/* WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        */
/* INCLUDING BUT NOT LIMITED TO THE WARRANTIES      */
/* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR     */
/* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   */
/* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR   */
/* ANY CLAIM, DAMAGES OR OTHER LIABILITY,           */
/* WHETHER IN AN ACTION OF CONTRACT, TORT OR        */
/* OTHERWISE, ARISING FROM, OUT OF OR IN            */
/* CONNECTION WITH THE SOFTWARE OR THE USE OR       */
/* OTHER DEALINGS IN THE SOFTWARE.                  */
/*                                                  */
/*--------------------------------------------------*/
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import <MobilyCore/MobilyDataContainer+Private.h>

/*--------------------------------------------------*/

@implementation MobilyDataContainerCalendar

#pragma mark Synthesize

@synthesize calendar = _calendar;
@synthesize canShowMonth = _canShowMonth;
@synthesize canSelectMonth = _canSelectMonth;
@synthesize monthMargin = _monthMargin;
@synthesize monthHeight = _monthHeight;
@synthesize monthSpacing = _monthSpacing;
@synthesize canShowWeekdays = _canShowWeekdays;
@synthesize canSelectWeekdays = _canSelectWeekdays;
@synthesize weekdaysMargin = _weekdaysMargin;
@synthesize weekdaysHeight = _weekdaysHeight;
@synthesize weekdaysSpacing = _weekdaysSpacing;
@synthesize canShowDays = _canShowDays;
@synthesize canSelectDays = _canSelectDays;
@synthesize canSelectPreviousDays = _canSelectPreviousDays;
@synthesize canSelectNextDays = _canSelectNextDays;
@synthesize canSelectEarlierDays = _canSelectEarlierDays;
@synthesize canSelectCurrentDay = _canSelectCurrentDay;
@synthesize canSelectAfterDays = _canSelectAfterDays;
@synthesize daysMargin = _daysMargin;
@synthesize daysHeight = _daysHeight;
@synthesize daysSpacing = _daysSpacing;
@synthesize beginDate = _beginDate;
@synthesize endDate = _endDate;
@synthesize displayBeginDate = _displayBeginDate;
@synthesize displayEndDate = _displayEndDate;
@synthesize monthItem = _monthItem;
@synthesize weekdayItems = _weekdayItems;
@synthesize dayItems = _dayItems;

#pragma mark Init / Free

+ (instancetype)containerWithCalendar:(NSCalendar*)calendar {
    return [[self alloc] initWithCalendar:calendar];
}

- (instancetype)initWithCalendar:(NSCalendar*)calendar {
    self = [super init];
    if(self != nil) {
        _calendar = calendar;
        _canShowMonth = YES;
        _canSelectMonth = NO;
        _monthMargin = UIEdgeInsetsZero;
        _monthHeight = 64.0f;
        _monthSpacing = 0.0f;
        _canShowWeekdays = YES;
        _canSelectWeekdays = NO;
        _weekdaysMargin = UIEdgeInsetsZero;
        _weekdaysHeight = 21.0f;
        _weekdaysSpacing = UIOffsetZero;
        _canShowDays = YES;
        _canSelectDays = YES;
        _canSelectPreviousDays = NO;
        _canSelectNextDays = NO;
        _canSelectEarlierDays = YES;
        _canSelectCurrentDay = YES;
        _canSelectAfterDays = YES;
        _daysMargin = UIEdgeInsetsZero;
        _daysHeight = 44.0f;
        _daysSpacing = UIOffsetZero;
        _weekdayItems = NSMutableArray.array;
        _dayItems = MobilyMutableGrid.grid;
    }
    return self;
}

#pragma mark Property

- (void)setCanShowMonth:(BOOL)canShowMonth {
    if(_canShowMonth != canShowMonth) {
        _canShowMonth = canShowMonth;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setCanSelectMonth:(BOOL)canSelectMonth {
    if(_canSelectMonth != canSelectMonth) {
        _canSelectMonth = canSelectMonth;
        if(_monthItem != nil) {
            _monthItem.allowsSelection = _canSelectMonth;
        }
    }
}

- (void)setMonthMargin:(UIEdgeInsets)monthMargin {
    if(UIEdgeInsetsEqualToEdgeInsets(_monthMargin, monthMargin) == NO) {
        _monthMargin = monthMargin;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setMonthHeight:(CGFloat)monthHeight {
    if(_monthHeight != monthHeight) {
        _monthHeight = monthHeight;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setMonthSpacing:(CGFloat)monthSpacing {
    if(_monthSpacing != monthSpacing) {
        _monthSpacing = monthSpacing;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setCanShowWeekdays:(BOOL)canShowWeekdays {
    if(_canShowWeekdays != canShowWeekdays) {
        _canShowWeekdays = canShowWeekdays;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setCanSelectWeekdays:(BOOL)canSelectWeekdays {
    if(_canSelectWeekdays != canSelectWeekdays) {
        _canSelectWeekdays = canSelectWeekdays;
        [_weekdayItems moEach:^(MobilyDataItemCalendarWeekday* weekdayItem) {
            weekdayItem.allowsSelection = _canSelectWeekdays;
        }];
    }
}

- (void)setWeekdaysMargin:(UIEdgeInsets)weekdaysMargin {
    if(UIEdgeInsetsEqualToEdgeInsets(_weekdaysMargin, weekdaysMargin) == NO) {
        _weekdaysMargin = weekdaysMargin;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setWeekdaysHeight:(CGFloat)weekdaysHeight {
    if(_weekdaysHeight != weekdaysHeight) {
        _weekdaysHeight = weekdaysHeight;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setWeekdaysSpacing:(UIOffset)weekdaysSpacing {
    if(UIOffsetEqualToOffset(_weekdaysSpacing, weekdaysSpacing) == NO) {
        _weekdaysSpacing = weekdaysSpacing;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setCanShowDays:(BOOL)canShowDays {
    if(_canShowDays != canShowDays) {
        _canShowDays = canShowDays;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setCanSelectDays:(BOOL)canSelectDays {
    if(_canSelectDays != canSelectDays) {
        _canSelectDays = canSelectDays;
        [_weekdayItems moEach:^(MobilyDataItemCalendarDay* dayItem) {
            if(([dayItem.date moIsAfterOrSame:_beginDate] == YES) && ([dayItem.date moIsEarlierOrSame:_endDate] == YES)) {
                dayItem.allowsSelection = _canSelectDays;
            }
        }];
    }
}

- (void)setCanSelectPreviousDays:(BOOL)canSelectPreviousDays {
    if(_canSelectPreviousDays != canSelectPreviousDays) {
        _canSelectPreviousDays = canSelectPreviousDays;
        [_weekdayItems moEach:^(MobilyDataItemCalendarDay* dayItem) {
            if([dayItem.date moIsAfter:_endDate] == YES) {
                dayItem.allowsSelection = _canSelectNextDays;
            }
        }];
    }
}

- (void)setCanSelectNextDays:(BOOL)canSelectNextDays {
    if(_canSelectNextDays != canSelectNextDays) {
        _canSelectNextDays = canSelectNextDays;
        [_weekdayItems moEach:^(MobilyDataItemCalendarDay* dayItem) {
            if([dayItem.date moIsEarlier:_beginDate] == YES) {
                dayItem.allowsSelection = _canSelectPreviousDays;
            }
        }];
    }
}

- (void)setCanSelectEarlierDays:(BOOL)canSelectEarlierDays {
    if(_canSelectEarlierDays != canSelectEarlierDays) {
        _canSelectEarlierDays = canSelectEarlierDays;
        
        NSDate* now = NSDate.date.moWithoutTime;
        [_weekdayItems moEach:^(MobilyDataItemCalendarDay* dayItem) {
            if([dayItem.date moIsEarlier:now] == YES) {
                dayItem.allowsSelection = _canSelectEarlierDays;
            }
        }];
    }
}

- (void)setCanSelectAfterDays:(BOOL)canSelectAfterDays {
    if(_canSelectAfterDays != canSelectAfterDays) {
        _canSelectAfterDays = canSelectAfterDays;
        
        NSDate* now = NSDate.date.moWithoutTime;
        [_weekdayItems moEach:^(MobilyDataItemCalendarDay* dayItem) {
            if([dayItem.date moIsAfter:now] == YES) {
                dayItem.allowsSelection = _canSelectAfterDays;
            }
        }];
    }
}

- (void)setDaysMargin:(UIEdgeInsets)daysMargin {
    if(UIEdgeInsetsEqualToEdgeInsets(_daysMargin, daysMargin) == NO) {
        _daysMargin = daysMargin;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setDaysHeight:(CGFloat)daysHeight {
    if(_daysHeight != daysHeight) {
        _daysHeight = daysHeight;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setDaysSpacing:(UIOffset)daysSpacing {
    if(UIOffsetEqualToOffset(_daysSpacing, daysSpacing) == NO) {
        _daysSpacing = daysSpacing;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

#pragma mark Public

- (MobilyDataItemCalendarWeekday*)weekdayItemForDate:(NSDate*)date {
    NSDateComponents* dateComponents = [_calendar components:NSCalendarUnitWeekday fromDate:date];
    for(MobilyDataItemCalendarWeekday* weekdayItem in _weekdayItems) {
        NSDateComponents* weekdayComponents = [_calendar components:NSCalendarUnitWeekday fromDate:weekdayItem.date];
        if(weekdayComponents.weekday == dateComponents.weekday) {
            return weekdayItem;
        }
    }
    return nil;
}

- (MobilyDataItemCalendarDay*)dayItemForDate:(NSDate*)date {
    NSDate* beginDate = date.moBeginningOfDay;
    __block MobilyDataItemCalendarDay* result = nil;
    [_dayItems enumerateColumnsRowsUsingBlock:^(MobilyDataItemCalendarDay* dayItem, NSUInteger column __unused, NSUInteger row __unused, BOOL* stopColumn, BOOL* stopRow) {
        if([dayItem.date isEqualToDate:beginDate] == YES) {
            result = dayItem;
            *stopColumn = YES;
            *stopRow = YES;
        }
    }];
    return result;
}

- (void)prepareBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate {
    [self prepareBeginDate:beginDate endDate:endDate monthBlock:^id(NSDate* beginDate, NSDate* endDate) {
        return [NSNull null];
    } weekdayBlock:^id(NSDate* date, NSUInteger index) {
        return [NSNull null];
    } dayBlock:^id(NSDate* date) {
        return [NSNull null];
    }];
}

- (void)prepareBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate dayBlock:(MobilyDataContainerCalendarDayCreateBlock)dayBlock {
    [self prepareBeginDate:beginDate endDate:endDate monthBlock:^id(NSDate* beginDate, NSDate* endDate) {
        return [NSNull null];
    } weekdayBlock:^id(NSDate* date, NSUInteger index) {
        return [NSNull null];
    } dayBlock:dayBlock];
}

- (void)prepareBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate monthBlock:(MobilyDataContainerCalendarMonthCreateBlock)monthBlock weekdayBlock:(MobilyDataContainerCalendarWeekdayCreateBlock)weekdayBlock dayBlock:(MobilyDataContainerCalendarDayCreateBlock)dayBlock {
    if(([_beginDate isEqualToDate:beginDate] == NO) || ([_endDate isEqualToDate:endDate] == NO)) {
        [self cleanup];
        _beginDate = beginDate;
        _displayBeginDate = _beginDate.moBeginningOfWeek;
        _endDate = endDate;
        _displayEndDate = endDate.moEndOfWeek;
        if(_canShowMonth == YES) {
            _monthItem = [MobilyDataItemCalendarMonth itemWithCalendar:_calendar beginDate:_beginDate endDate:_endDate displayBeginDate:_displayBeginDate displayEndDate:_displayEndDate data:monthBlock(_beginDate, _endDate)];
            _monthItem.allowsSelection = _canSelectMonth;
            [self _appendEntry:_monthItem];
        }
        if(_canShowWeekdays == YES) {
            NSDate* weekdayDate = _beginDate.moBeginningOfWeek;
            for(NSUInteger weekdayIndex = 0; weekdayIndex < 7; weekdayIndex++) {
                MobilyDataItemCalendarWeekday* weekdayItem;
                if(_canShowMonth == YES) {
                    weekdayItem = [MobilyDataItemCalendarWeekday itemWithMonthItem:_monthItem date:weekdayDate data:weekdayBlock(weekdayDate, weekdayIndex)];
                } else {
                    weekdayItem = [MobilyDataItemCalendarWeekday itemWithCalendar:_calendar date:weekdayDate data:weekdayBlock(weekdayDate, weekdayIndex)];
                }
                weekdayItem.allowsSelection = _canSelectWeekdays;
                [_weekdayItems addObject:weekdayItem];
                [self _appendEntry:weekdayItem];
                weekdayDate = weekdayDate.moNextDay;
            }
        }
        if(_canShowDays == YES) {
            NSDate* now = NSDate.date.moWithoutTime;
            NSDate* beginDayDate = [_displayBeginDate copy];
            NSDate* endDayDate = [_displayEndDate copy];
            NSInteger weekOfMonth = [beginDayDate moWeeksToDate:endDayDate.moNextSecond];
            if(weekOfMonth > 0) {
                [_dayItems setNumberOfColumns:7 numberOfRows:weekOfMonth];
                for(NSUInteger weekIndex = 0; weekIndex < weekOfMonth; weekIndex++) {
                    for(NSUInteger weekdayIndex = 0; weekdayIndex < 7; weekdayIndex++) {
                        MobilyDataItemCalendarDay* dayItem;
                        if(_canShowWeekdays == YES) {
                            dayItem = [MobilyDataItemCalendarDay itemWithWeekdayItem:_weekdayItems[weekdayIndex] date:beginDayDate data:dayBlock(beginDayDate)];
                        } else {
                            dayItem = [MobilyDataItemCalendarDay itemWithCalendar:_calendar date:beginDayDate data:dayBlock(beginDayDate)];
                        }
                        if([dayItem.date moIsEarlier:_beginDate] == YES) {
                            dayItem.allowsSelection = (_canSelectDays == YES) ? _canSelectPreviousDays : _canSelectDays;
                        } else if([dayItem.date moIsAfter:_endDate] == YES) {
                            dayItem.allowsSelection = (_canSelectDays == YES) ? _canSelectNextDays : _canSelectDays;
                        } else {
                            if([dayItem.date moIsEarlier:now] == YES) {
                                dayItem.allowsSelection = (_canSelectDays == YES) ? _canSelectEarlierDays : _canSelectDays;
                            } else if([dayItem.date moIsAfter:now] == YES) {
                                dayItem.allowsSelection = (_canSelectDays == YES) ? _canSelectAfterDays : _canSelectDays;
                            } else {
                                dayItem.allowsSelection = (_canSelectDays == YES) ? _canSelectCurrentDay : _canSelectDays;
                            }
                        }
                        [_dayItems setObject:dayItem atColumn:weekdayIndex atRow:weekIndex];
                        [self _appendEntry:dayItem];
                        beginDayDate = beginDayDate.moNextDay;
                    }
                }
            }
        }
    }
}

- (void)replaceDate:(NSDate*)date data:(id)data {
    __block NSUInteger foundColumn = NSNotFound, foundRow = NSNotFound;
    [_dayItems enumerateColumnsRowsUsingBlock:^(MobilyDataItemCalendarDay* day, NSUInteger column, NSUInteger row, BOOL* stopColumn, BOOL* stopRow) {
        if([day.date isEqualToDate:date] == YES) {
            foundColumn = column;
            foundRow = row;
            *stopColumn = YES;
            *stopRow = YES;
        }
    }];
    if((foundColumn != NSNotFound) && (foundRow != NSNotFound)) {
        MobilyDataItemCalendarDay* oldDayItem = [_dayItems objectAtColumn:foundColumn atRow:foundRow];
        MobilyDataItemCalendarDay* newDayItem;
        if(oldDayItem.weekdayItem != nil) {
            newDayItem = [MobilyDataItemCalendarDay itemWithWeekdayItem:oldDayItem.weekdayItem date:date data:data];
        } else {
            newDayItem = [MobilyDataItemCalendarDay itemWithCalendar:oldDayItem.calendar date:date data:data];
        }
        newDayItem.allowsSelection = oldDayItem.allowsSelection;
        [_dayItems setObject:newDayItem atColumn:foundColumn atRow:foundRow];
        [self _replaceOriginEntry:oldDayItem withEntry:newDayItem];
    }
}

- (void)cleanup {
    if(_monthItem != nil) {
        [self _deleteEntry:_monthItem];
        _monthItem = nil;
    }
    if(_weekdayItems.count > 0) {
        [self _deleteEntries:_weekdayItems];
        [_weekdayItems removeAllObjects];
    }
    if(_dayItems.count > 0) {
        [self _deleteEntries:_dayItems.objects];
        [_dayItems removeAllObjects];
    }
    _beginDate = nil;
    _endDate = nil;
}

- (void)eachDayItemsWithWeekdayItem:(MobilyDataItemCalendarWeekday*)weekdayItem block:(MobilyDataContainerCalendarEachDayItemsBlock)block {
    NSUInteger weekdayIndex = [_weekdayItems indexOfObject:weekdayItem];
    if(weekdayIndex != NSNotFound) {
        [_dayItems moEach:^(MobilyDataItemCalendarDay* dayItem, NSUInteger column __unused, NSUInteger row __unused) {
            block(dayItem);
        } byColumn:weekdayIndex];
    }
}

- (void)eachWeekdayByDayItem:(MobilyDataItemCalendarDay*)dayItem block:(MobilyDataContainerCalendarEachDayItemsBlock)block {
    NSUInteger dayIndex = NSNotFound;
    [_dayItems findObjectUsingBlock:^BOOL(MobilyDataItemCalendarDay* item) {
        return dayItem == item;
    } inColumn:&dayIndex inRow:NULL];
    if(dayIndex != NSNotFound) {
        [_dayItems moEach:^(MobilyDataItemCalendarDay* item, NSUInteger column, NSUInteger row) {
            block(item);
        } byColumn:dayIndex];
    }
}

- (void)eachWeekByDayItem:(MobilyDataItemCalendarDay*)dayItem block:(MobilyDataContainerCalendarEachDayItemsBlock)block {
    NSUInteger weekIndex = NSNotFound;
    [_dayItems findObjectUsingBlock:^BOOL(MobilyDataItemCalendarDay* item) {
        return dayItem == item;
    } inColumn:NULL inRow:&weekIndex];
    if(weekIndex != NSNotFound) {
        [_dayItems moEach:^(MobilyDataItemCalendarDay* item, NSUInteger column, NSUInteger row) {
            block(item);
        } byRow:weekIndex];
    }
}

#pragma mark Private override

- (CGRect)_validateEntriesForAvailableFrame:(CGRect)frame {
    BOOL canShowMonth = _canShowMonth;
    UIEdgeInsets monthMargin = (canShowMonth == YES) ? _monthMargin : UIEdgeInsetsZero;
    CGFloat monthHeight = (canShowMonth == YES) ? _monthHeight - (monthMargin.top + monthMargin.bottom) : 0.0f;
    CGFloat monthSpacing = (canShowMonth == YES) ? _monthSpacing : 0.0f;
    BOOL canShowWeekdays = _canShowWeekdays;
    UIEdgeInsets weekdaysMargin = (canShowWeekdays == YES) ? _weekdaysMargin : UIEdgeInsetsZero;
    CGFloat weekdaysHeight = (canShowWeekdays == YES) ? _weekdaysHeight - (weekdaysMargin.top + weekdaysMargin.bottom) : 0.0f;
    UIOffset weekdaysSpacing = (canShowWeekdays == YES) ? _weekdaysSpacing : UIOffsetZero;
    BOOL canShowDays = _canShowDays;
    UIEdgeInsets daysMargin = (canShowDays == YES) ? _daysMargin : UIEdgeInsetsZero;
    CGFloat daysHeight = (canShowDays == YES) ? _daysHeight - (daysMargin.top + daysMargin.bottom) : 0.0f;
    UIOffset daysSpacing = (canShowDays == YES) ? _daysSpacing : UIOffsetZero;
    CGFloat monthWidth = frame.size.width - (monthMargin.left + monthMargin.right);
    CGFloat availableWeekdaysWidth = monthWidth - (weekdaysMargin.left + weekdaysMargin.right) - (weekdaysSpacing.horizontal * 6);
    CGFloat defaultWeekdaysWidth = MOBILY_FLOOR(availableWeekdaysWidth / 7);
    CGFloat lastWeekdaysWidth = availableWeekdaysWidth - (defaultWeekdaysWidth * 6);
    CGFloat availableDaysWidth = monthWidth - (daysMargin.left + daysMargin.right) - (daysSpacing.horizontal * 6);
    CGFloat defaultDaysWidth = MOBILY_FLOOR(availableDaysWidth / 7);
    CGFloat lastDaysWidth = availableDaysWidth - (defaultDaysWidth * 6);
    __block CGPoint offset = CGPointMake(frame.origin.x + monthMargin.left, frame.origin.y + monthMargin.top);
    __block CGSize cumulative = CGSizeMake(monthWidth, 0.0f);
    if(canShowMonth == YES) {
        _monthItem.updateFrame = CGRectMake(offset.x, offset.y, monthWidth, monthHeight);
        cumulative.height += monthHeight;
        offset.y += monthHeight;
    }
    if(canShowWeekdays == YES) {
        NSUInteger lastIndex = _weekdayItems.count - 1;
        __block CGFloat weekdayOffset = offset.x + weekdaysMargin.left;
        cumulative.height += weekdaysMargin.top;
        offset.y += weekdaysMargin.top;
        [_weekdayItems moEachWithIndex:^(MobilyDataItemCalendarWeekday* weekdayItem, NSUInteger index) {
            if(index != lastIndex) {
                weekdayItem.updateFrame = CGRectMake(weekdayOffset, offset.y, defaultWeekdaysWidth, weekdaysHeight);
                weekdayOffset += defaultWeekdaysWidth + weekdaysSpacing.horizontal;
            } else {
                weekdayItem.updateFrame = CGRectMake(weekdayOffset, offset.y, lastWeekdaysWidth, weekdaysHeight);
                cumulative.height += weekdaysHeight + weekdaysSpacing.vertical;
                offset.y += weekdaysHeight + weekdaysSpacing.vertical;
            }
        }];
        cumulative.height += weekdaysMargin.bottom - weekdaysSpacing.vertical;
        offset.y += weekdaysMargin.bottom - weekdaysSpacing.vertical;
    }
    if(canShowDays == YES) {
        NSUInteger lastColumn = _dayItems.numberOfColumns - 1;
        __block CGFloat dayOffset = offset.x + daysMargin.left;
        cumulative.height += daysMargin.top;
        offset.y += daysMargin.top;
        [_dayItems eachRowsColumns:^(MobilyDataItemCalendarDay* dayItem, NSUInteger column, NSUInteger row __unused) {
            if(column != lastColumn) {
                dayItem.updateFrame = CGRectMake(dayOffset, offset.y, defaultDaysWidth, daysHeight);
                dayOffset += defaultDaysWidth + daysSpacing.horizontal;
            } else {
                dayItem.updateFrame = CGRectMake(dayOffset, offset.y, lastDaysWidth, daysHeight);
                cumulative.height += daysHeight + daysSpacing.vertical;
                offset.y += daysHeight + daysSpacing.vertical;
                dayOffset = offset.x + daysMargin.left;
            }
        }];
        cumulative.height += daysMargin.bottom - daysSpacing.vertical;
        offset.y += daysMargin.bottom - daysSpacing.vertical;
    }
    if(canShowMonth == YES) {
        cumulative.height += monthSpacing - monthSpacing;
    }
    return CGRectMake(frame.origin.x, frame.origin.y, monthMargin.left + cumulative.width + monthMargin.right, monthMargin.top + cumulative.height + monthMargin.bottom);
}

- (void)_willEntriesLayoutForBounds:(CGRect __unused)bounds {
}

@end

/*--------------------------------------------------*/

NSString* MobilyDataContainerCalendarMonthIdentifier = @"MobilyDataContainerCalendarMonthIdentifier";
NSString* MobilyDataContainerCalendarWeekdayIdentifier = @"MobilyDataContainerCalendarWeekdayIdentifier";
NSString* MobilyDataContainerCalendarDayIdentifier = @"MobilyDataContainerCalendarDayIdentifier";

/*--------------------------------------------------*/
