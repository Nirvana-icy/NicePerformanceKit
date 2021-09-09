//
//  NPKSignpostLog.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/6/30.
//

#import <NicePerformanceKit/NPKSignpostLog.h>

// signpost log of TimeProfile

os_log_t _npk_time_profile_shared_os_log_t() {
#ifdef DEBUG
    return NPKCreateOnce(os_log_create("com.NicePerformanceKit.signpost", "TimeProfile"));
#else
    return OS_LOG_DISABLED;
#endif
}

os_signpost_id_t _npk_time_profile_spid_generate() {
    if (@available(iOS 12.0, *)) {
        return os_signpost_id_generate(_npk_time_profile_shared_os_log_t());
    } else {
        return OS_SIGNPOST_ID_NULL;
    }
}

// signpost log of point of interest

os_log_t _npk_poi_shared_os_log_t() {
#ifdef DEBUG
    return NPKCreateOnce(os_log_create("com.NicePerformanceKit.signpost", OS_LOG_CATEGORY_POINTS_OF_INTEREST));
#else
    return OS_LOG_DISABLED;
#endif
}

