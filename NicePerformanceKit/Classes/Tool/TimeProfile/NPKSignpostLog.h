//
//  NPKSignpostLog.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/6/30.
//

#import <Foundation/Foundation.h>
#import <os/signpost.h>
#import <NicePerformanceKit/NPKBaseDefine.h>

// Profile 多行代码耗时：
// npk_time_profile_begin("xxxxEvent", "begin");
// [XXXX func1];
// [xxxx func2];
// npk_time_profile_end("xxxxEvent", "end");

#define npk_time_profile_begin(eventName, spid, ...) \
        if (@available(iOS 12.0, *)) {\
            os_signpost_interval_begin(_npk_time_profile_shared_os_log_t(), spid, eventName, "begin", ##__VA_ARGS__);\
        }

#define npk_time_profile_end(eventName, spid, ...) \
        if (@available(iOS 12.0, *)) {\
            os_signpost_interval_end(_npk_time_profile_shared_os_log_t(), spid, eventName, "end", ##__VA_ARGS__);\
        }

// Profile 单行代码耗时 npk_time_profile("XXSDK setup", [XXSDK setup]);
#define npk_time_profile(eventName, impl, ...) \
        if (@available(iOS 12.0, *)) {\
            os_signpost_id_t signpost_id = os_signpost_id_generate(_npk_time_profile_shared_os_log_t());\
            os_signpost_interval_begin(_npk_time_profile_shared_os_log_t(), signpost_id, eventName, "begin", ##__VA_ARGS__);\
            impl;\
            os_signpost_interval_end(_npk_time_profile_shared_os_log_t(), signpost_id, eventName, "end", ##__VA_ARGS__);\
        }

// Emit one signpost event with eventName and eventDetail.
// 开发者可以在代码中使用NPK提供的 npk_signpost_emit_event 宏，便捷的对关键点打点。 eg. npk_signpost_emit_event("eventName", "eventDetail");
#define npk_signpost_emit_event(eventName, eventDetail, ...) \
        if (@available(iOS 12.0, *)) {\
            os_signpost_event_emit(_npk_poi_shared_os_log_t(), os_signpost_id_generate(_npk_poi_shared_os_log_t()), eventName, eventDetail, ##__VA_ARGS__);\
        }

/*!
 * @function _npk_time_profile_shared_os_log_t
 *
 * @abstract
 * Creates one shared os_log object used for time profile of nice performance kit.
 *
 * @discussion
 * 开发者可以使用signpost对代码块的执行时间进行Profile，并可以方便的在instrument中(添加os_signpost模版)进行观测。
 * _npk_time_profile_shared_os_log_t 创建了一个以 "com.NicePerformanceKit.signpost"为名字的os_log子系统，"TimeProfile"为类别的os_log单例。
 * 开发者可以使用NPK提供的宏，便捷的对关注的代码执行块进行 Time Profile。
 * Profile 单行代码耗时可以选用: npk_time_profile("XXXSDK setup",  [XXXXSDK setup]);
 * Profile 多行代码耗时可以选用：
 * npk_time_profile_begin("xxxxEvent", "begin");
 * // ....code ....
 * npk_time_profile_end("xxxxEvent", "end");
 *
 * @result
 * Returns one shared os_log object with the specified os log subsystem's name of "com.NicePerformanceKit.signpost" and the specified category name of "TimeProfile".
 */
NPK_EXTERN os_log_t _npk_time_profile_shared_os_log_t();

NPK_EXTERN os_signpost_id_t _npk_time_profile_spid_generate();
/*!
 * @function _npk_poi_shared_os_log_t
 *
 * @abstract
 * Creates one shared os_log object used for point of interest of nice performance kit.
 *
 * @discussion
 * 开发者可以使用signpost在代码中对感兴趣或者关键的代码逻辑执行点进行打点，并可以方便的在instrument中(添加os_signpost模版)的时间轴上观察到打点事件。
 * _NPKPointOfInterestLog 创建了一个以 "com.NicePerformanceKit.signpost"为名字的os_log子系统，OS_LOG_CATEGORY_POINTS_OF_INTEREST类别的os_log单例。
 * 开发者可以使用NPK提供的 npk_signpost_emit_event 宏，便捷的对关键点打点。 eg.  npk_signpost_emit_event("eventName", "eventDetail");
 *
 * @result
 * Returns one shared os_log object with the specified os log subsystem's name of "com.NicePerformanceKit.signpost" and the specifiled category of OS_LOG_CATEGORY_POINTS_OF_INTEREST.
 */
NPK_EXTERN os_log_t _npk_poi_shared_os_log_t();
