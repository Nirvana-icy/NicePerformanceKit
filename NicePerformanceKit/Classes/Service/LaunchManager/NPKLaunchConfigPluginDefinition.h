//
//  NPKLaunchConfigPluginDefinition.h
//  Pods
//
//  Created by JinglongBi on 2021/9/20.
//

#ifndef NPKLaunchConfigPluginDefinition_h
#define NPKLaunchConfigPluginDefinition_h

typedef struct {
    const char *cls;
} NPKLaunchConfigPluginMeta;

/// 注册业务配置类
#define NPK_LAUNCH_PLUGIN(pluginCls) \
__attribute__((used, section("__DATA , npk_launch_plug"))) \
static const NPKLaunchConfigPluginMeta __##npk_launch_plugin_##pluginCls##__ = {#pluginCls};

#endif /* NPKLaunchConfigPluginDefinition_h */
