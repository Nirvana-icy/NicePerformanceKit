//
//  NPKSysResCostInfo.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/21.
//

#import "NPKSysResCostInfo.h"

#if TARGET_OS_IPHONE
#import <mach/mach.h>
#import <os/proc.h>
#endif

@implementation NPKSysResCostInfo

+ (NSString *)appCostInfo {
    return [NSString stringWithFormat:@"CPU: %0.1f RAM: %0.1f 线程: %lu", [NPKSysResCostInfo currentAppCpuUsage], [NPKSysResCostInfo currentAppMemory], (unsigned long)[NPKSysResCostInfo currentAppThreadCount]];
}

+ (NSString *)sysLoadInfo {
    return [NSString stringWithFormat:@"CPU: %0.1f", [NPKSysResCostInfo currentSystemCpuUsage]];
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
    previous_info   = info;
    system_cpu = (user + nice + system) * 100.0 / total;
    if (isnan(system_cpu)) {
        system_cpu = 0.0;
    }
    return system_cpu;
}

+ (float)currentAppCpuUsage {
    kern_return_t           kr;
    thread_array_t          threadList;         // 保存当前Mach task的线程列表
    mach_msg_type_number_t  threadCount;        // 保存当前Mach task的线程个数
    thread_info_data_t      threadInfo;         // 保存单个线程的信息列表
    mach_msg_type_number_t  threadInfoCount;    // 保存当前线程的信息列表大小
    thread_basic_info_t     threadBasicInfo;    // 线程的基本信息
    
    // 通过“task_threads”API调用获取指定 task 的线程列表
    //  mach_task_self_，表示获取当前的 Mach task
    kr = task_threads(mach_task_self(), &threadList, &threadCount);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    double cpuUsage = 0;
    for (int i = 0; i < threadCount; i++) {
        threadInfoCount = THREAD_INFO_MAX;
        // 通过“thread_info”API调用来查询指定线程的信息
        //  flavor参数传的是THREAD_BASIC_INFO，使用这个类型会返回线程的基本信息，
        //  定义在 thread_basic_info_t 结构体，包含了用户和系统的运行时间、运行状态和调度优先级等
        kr = thread_info(threadList[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        threadBasicInfo = (thread_basic_info_t)threadInfo;
        if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) {
            cpuUsage += threadBasicInfo->cpu_usage;
        }
    }
    
    // 回收内存，防止内存泄漏
    vm_deallocate(mach_task_self(), (vm_offset_t)threadList, threadCount * sizeof(thread_t));
    
    return cpuUsage / (double)TH_USAGE_SCALE * 100.0;
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

+ (float)totalMemoryForDevice {
    return (float)([NSProcessInfo processInfo].physicalMemory / 1024 / 1024);
}

+ (float)totalAvailableMemoryForApp {
    if (@available(iOS 13.0, *)) {
        task_vm_info_data_t taskInfo;
        mach_msg_type_number_t infoCount = TASK_VM_INFO_COUNT;
        kern_return_t kernReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&taskInfo, &infoCount);

        if (kernReturn != KERN_SUCCESS) {
            return 0;
        }
        return (taskInfo.phys_footprint + os_proc_available_memory()) / 1024.0 / 1024.0;
    } else {
        float totalMemory = [NPKSysResCostInfo totalMemoryForDevice];
        float limitMemory;
        if (totalMemory <= 1024) {
            limitMemory = totalMemory * 0.45;
        } else if (totalMemory >= 1024 && totalMemory <= 2048) {
            limitMemory = totalMemory * 0.45;
        } else if (totalMemory >= 2048 && totalMemory <= 3072) {
            limitMemory = totalMemory * 0.50;
        } else {
            limitMemory = totalMemory * 0.55;
        }
        return limitMemory;
    }
}

@end
