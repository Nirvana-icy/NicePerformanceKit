//
//  NPKSysResCostInfo.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/21.
//

#import "NPKSysResCostInfo.h"

#if TARGET_OS_IPHONE
#include <mach/mach.h>
#endif

@implementation NPKSysResCostInfo

+ (NSString *)appCostInfo {
    return [NSString stringWithFormat:@"CPU: %0.1f RAM: %0.1f", [NPKSysResCostInfo currentAppCpuUsage], [NPKSysResCostInfo currentAppMemory]];
}

+ (NSString *)sysLoadInfo {
    return [NSString stringWithFormat:@"CPU: %0.1f 线程: %lu", [NPKSysResCostInfo currentSystemCpuUsage], (unsigned long)[NPKSysResCostInfo currentAppThreadCount]];
}

+ (float)currentAppMemory {
    NSUInteger memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kr = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kr == KERN_SUCCESS) {
        memoryUsageInByte = (NSUInteger) vmInfo.phys_footprint;
    } else {
        return -1;
    }
    return memoryUsageInByte/1024.0/1024.0;
}

+ (float)currentSystemCpuUsage {
    kern_return_t kr;
    mach_msg_type_number_t count;
    static host_cpu_load_info_data_t previous_info = {0, 0, 0, 0};
    host_cpu_load_info_data_t info;
    
    count = HOST_CPU_LOAD_INFO_COUNT;
    
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    float system_cpu = 0.0;
    natural_t user   = info.cpu_ticks[CPU_STATE_USER] - previous_info.cpu_ticks[CPU_STATE_USER];
    natural_t nice   = info.cpu_ticks[CPU_STATE_NICE] - previous_info.cpu_ticks[CPU_STATE_NICE];
    natural_t system = info.cpu_ticks[CPU_STATE_SYSTEM] - previous_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle   = info.cpu_ticks[CPU_STATE_IDLE] - previous_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t total  = user + nice + system + idle;
    previous_info    = info;
    system_cpu = (user + nice + system) * 100.0 / total;
    if (isnan(system_cpu)) {
        system_cpu = 0.0;
    }
    return system_cpu;
}

+ (float)currentAppCpuUsage {
    kern_return_t           kr;
    thread_array_t          thread_list;
    mach_msg_type_number_t   thread_count;
    thread_info_data_t       thinfo;
    mach_msg_type_number_t   thread_info_count;
    thread_basic_info_t      basic_info_th;

    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    float cpu_usage = 0;

    for (int i = 0; i < thread_count; i++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[i], THREAD_BASIC_INFO,(thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }

        basic_info_th = (thread_basic_info_t)thinfo;

        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            cpu_usage += basic_info_th->cpu_usage;
        }
    }

    NSUInteger CPUNum = [NSProcessInfo processInfo].activeProcessorCount;
    cpu_usage = cpu_usage / (float)TH_USAGE_SCALE * 100.0 / CPUNum;

    vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));

    return cpu_usage;
}

+ (NSUInteger)currentAppThreadCount {
    thread_act_array_t threads;
    mach_msg_type_number_t thread_count = 0;

    const task_t    this_task = mach_task_self();
    const thread_t  this_thread = mach_thread_self();

    // 1. Get a list of all threads (with count):
    kern_return_t kr = task_threads(this_task, &threads, &thread_count);

    if (kr != KERN_SUCCESS) {
        printf("error getting threads: %s", mach_error_string(kr));
        return 0;
    }

    mach_port_deallocate(this_task, this_thread);
    vm_deallocate(this_task, (vm_address_t)threads, sizeof(thread_t) * thread_count);
    
    return thread_count;
}

@end
