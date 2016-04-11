//
//  adylog.h
//  Created by Taras Kalapun on 3/3/15.
//

#ifndef __adylog__
#define __adylog__


#include <stdlib.h>
#include <stdio.h>

#if defined(__OBJC__) && (!defined(_adylog_C_MODE))
#  define __adylog_objc_mode
#endif

#define _adylog_default_component "adyen.main"

#ifndef adylog_component
#  define adylog_component _adylog_default_component
#endif

// Log levels, prefixed with 'adylcl_v'.
enum _adylog_enum_level_t {
    adylog_vOff = 0,
    
    adylog_vCritical,              // critical situation
    adylog_vError,                 // error situation
    adylog_vWarning,               // warning
    adylog_vInfo,                  // informational message
    adylog_vDebug,                 // coarse-grained debugging information
    adylog_vTrace,                 // fine-grained debugging information
    
    _adylog_level_t_count,
    _adylog_level_t_first = 0,
    _adylog_level_t_last  = _adylog_level_t_count-1
};

// Log level type.
typedef uint32_t _adylog_level_t;


typedef int (*adylog_render_line)(const char *str);


typedef struct {
    void (*render_linec)(const char *component, int level, const char *prefix, const char *str);
    void (*render_line)(const char *str);
} adylog_driver;


typedef struct {
    adylog_driver *driver;
    _adylog_level_t default_log_level;
    char *filepath;
    FILE *file;
    int use_colors;
    char **components;
    uint32_t components_count;
    uint32_t *components_levels;
} adylog_t;

// Public
void adylog_init(char *components[], int count);
void adylog_add_component(const char *name);
void adylog_free();

void adylog_configure_by_name(const char *name, _adylog_level_t level);
int adylog_component_active(const char *component, _adylog_level_t level);

void adylog_set_render_linec(void (*render_line_ptr)(const char *component, int level, const char *prefix, const char *str));
void adylog_set_render_line(void (*render_line_ptr)(const char *str));

int adylog_set_log_file(const char *filepath);
void adylog_set_enable_colors(int enable);

char *adylog_get_time(void);


void adylog_log_line(const char *component, int level, const char *prefix, const char *str);
void adylog_log_linef(const char *component, int level, const char *func, int line, const char *format, ...);
// Private
void adylog_renderer_linec(const char *component, int level, const char *prefix, const char *str);
void adylog_renderer_line(const char *str);

extern const char * const _adylog_level_header_1[_adylog_level_t_count];  // header with 1 character
extern const char * const _adylog_level_header_1c[_adylog_level_t_count]; // header with 1 character, colored

#ifndef _adylog_filename
#  define _adylog_filename (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
#endif

#ifdef __adylog_objc_mode
#  define _ady_str @""
#else
#  define _ady_str ""
#endif

#if DEBUG
#  define _adylog_debug_mode 1
#  define _adylog_color 1
#else
#  define _adylog_debug_mode 0
#  define _adylog_color 0
#endif


#define _adylog_prefix "" __func__ ":"__LINE__

#ifdef __adylog_objc_mode
#  define _adylog_c_str(s, ...) [[NSString stringWithFormat:s, ## __VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding]
#else
#  define _adylog_c_str(s, ...) s, ## __VA_ARGS__
#endif


#define adylog_log(_component, _level, _format, ...)                             \
    do {                                                                         \
        if (adylog_component_active(_component, _level)) {                       \
            adylog_log_linef(_component, _level, __func__, __LINE__, _adylog_c_str(_format, ## __VA_ARGS__)); \
        } \
    } while (0)


#define adylog_log_if(_component, _level, _predicate, _format, ...)             \
    do {                                                                       \
        if (_predicate) {                                                      \
            adylog_log(_component, _level, _format, ##__VA_ARGS__);             \
        }                                                                      \
    } while (0)



#define adylog_configure(_component, _level) \
    adylog_configure_by_name(log_component_prefix _component, _level)


#define log_critical(...)                                                        \
    adylog_log(adylog_component, adylog_vCritical, _ady_str __VA_ARGS__)

#define log_error(...)                                                           \
    adylog_log(adylog_component, adylog_vError, _ady_str __VA_ARGS__)

#define log_warning(...)                                                         \
    adylog_log(adylog_component, adylog_vWarning, _ady_str __VA_ARGS__)

#define log_info(...)                                                            \
    adylog_log(adylog_component, adylog_vInfo, _ady_str __VA_ARGS__)

#define log_debug(...)                                                           \
    adylog_log(adylog_component, adylog_vDebug, _ady_str __VA_ARGS__)

#define log_trace(...)                                                           \
    adylog_log(adylog_component, adylog_vTrace, _ady_str __VA_ARGS__)

#define log_critical_if(predicate, ...)                                          \
    adylog_log_if(adylog_component, adylog_vCritical, predicate, _ady_str __VA_ARGS__)

#define log_error_if(predicate, ...)                                             \
    adylog_log_if(adylog_component, adylog_vError, predicate, _ady_str __VA_ARGS__)

#define log_warning_if(predicate, ...)                                           \
    adylog_log_if(adylog_component, adylog_vWarning, predicate, _ady_str __VA_ARGS__)

#define log_info_if(predicate, ...)                                              \
    adylog_log_if(adylog_component, adylog_vInfo, predicate, _ady_str __VA_ARGS__)

#define log_debug_if(predicate, ...)                                             \
    adylog_log_if(adylog_component, adylog_vDebug, predicate, _ady_str __VA_ARGS__)

#define log_trace_if(predicate, ...)                                             \
    adylog_log_if(adylog_component, adylog_vTrace, predicate, _ady_str __VA_ARGS__)


#endif /* defined(__Pods__adylog__) */

