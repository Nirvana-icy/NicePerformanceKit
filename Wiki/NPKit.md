### NPK 开发阶段提示.

### 线下自动化测试巡检.  

[UI Testing cheat sheet and examples](https://masilotti.com/ui-testing-cheat-sheet/)

[Writing Test Classes and Methods](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/04-writing_tests.html#//apple_ref/doc/uid/TP40014132-CH4-SW8)

### 线上 APM & Organizer.

## NPK 

CPU、GPU、网络、定位是电量消耗大户.

线下CPU/GPU监控 记录高消耗时的 堆栈.



[Appdelegate didFinishLaunch] --> [NPKLaunchManager launchConfigure:appOptions] --> [NPKLaunchTaskService startLaunchTask:withConfig:withAppOptions]

[self addLaunchRunLoopObserver]
[self parseLaunchLifeCycle]

@"life_cycle": @{
     @"did_launch" : @[
         @{@"class" : @"xxxInitTask"},
         @{@"class" : @"xxxInitTask"}
     ],
     @"home_page_onload" : @[],
     @"view_appear" : @[],
     @"idle_time" : @[]
}